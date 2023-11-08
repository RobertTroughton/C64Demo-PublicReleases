/*
 *  NuCrunch 1.0
 *  Christopher Jam
 *  May 2018
 */
#[macro_use]
extern crate clap;
extern crate nucrunch;

use clap::{App, Arg, ArgGroup};
use nucrunch::{process, read_prg, Conf, InputChunk, TargetLocation};
use std::process;

struct InputSpec {
    pub file_name: String,
    pub end_of_group: bool,
}

fn load_input_chunks(file_names: Vec<&str>) -> Vec<InputChunk> {
    let mut input_fn_list: Vec<InputSpec> = file_names
        .iter()
        .map(|x: &&str| {
            let mut x = x.to_string();
            match x.pop().unwrap() {
                ',' => InputSpec {
                    file_name: x,
                    end_of_group: true,
                },
                e => {
                    x.push(e);
                    InputSpec {
                        file_name: x,
                        end_of_group: false,
                    }
                }
            }
        })
        .collect();
    match input_fn_list.pop() {
        None => unreachable!(),
        Some(group_end) => input_fn_list.push(InputSpec {
            file_name: group_end.file_name,
            end_of_group: true,
        }),
    }
    input_fn_list
        .iter()
        .map(|x| InputChunk {
            chunk: match read_prg(&x.file_name) {
                Ok(x) => x,
                Err(e) => {
                    eprintln!("Could not read {} ({})", x.file_name, e);
                    process::exit(1);
                }
            },
            end_of_group: x.end_of_group,
        })
        .collect()
}

fn parse_u16(arg: &str) -> Result<u16, String> {
    if arg.len() > 2 && &arg[..2] == "0x" {
        u16::from_str_radix(&arg[2..], 16)
            .map_err(|_| format!("Invalid hex string in arguments ('{}')", arg))
    } else {
        u16::from_str_radix(arg, 10)
            .map_err(|_| format!("could not parse number in arguments ('{}')", arg))
    }
}

fn build_app<'a, 'b>() -> App<'a, 'b> {
    App::new("nucrunch")
        .version(crate_version!())
        .author("Christopher Phillips <shrydar@jaruth.com>")
        .arg(
            Arg::with_name("inputs")
                .multiple(true)
                .required(true)
                .takes_value(true),
        )
        .arg(
            Arg::with_name("output")
                .short("o")
                .long("output")
                .value_name("OUTPUT.PRG")
                .help("sets filename for output .prg")
                .required(true),
        )
        .arg(
            Arg::with_name("exec_addr")
                .short("j")
                .long("jmp")
                .value_name("0xEXEC_ADDR")
                .requires("sea")
                .help("execution address for self extracting .prg (requires -x)"),
        )
        .arg(
            Arg::with_name("memory_config")
                .short("m")
                .long("memory_config")
                .value_name("0xCFG")
                .requires("sea")
                .help("0x01 value post decrunch (default 0x37, requires -x)"),
        )
        .arg(
            Arg::with_name("zero_fill")
                .short("z")
                .long("zero_fill")
                .requires("sea")
                .help("zero fills the areas between chunks (requires -x)"),
        )
        .arg(
            Arg::with_name("sei")
                .short("I")
                .long("sei")
                .requires("sea")
                .help("wrap decrunch in SEI/CLI instead of turning off CIA timer (requires -x)"),
        )
        .arg(
            Arg::with_name("set_eob")
                .short("b")
                .long("set_eob")
                .requires("sea")
                .help("sets the eof pointer at 2d/2e to end of highest input chunk (requires -x)"),
        )
        .arg(
            Arg::with_name("sea")
                .short("x")
                .long("sea")
                .help("produce self extracting output .prg (implies -r)"),
        )
        .arg(
            Arg::with_name("load")
                .short("l")
                .long("load")
                .value_name("LOAD_ADDRESS")
                .help("sets load address for raw output .prg"),
        )
        .arg(
            Arg::with_name("end")
                .short("e")
                .long("end")
                .value_name("END_ADDRESS")
                .help("sets end address for raw output .prg"),
        )
        .arg(
            Arg::with_name("auto")
                .short("A")
                .long("auto")
                // .conflicts_with("reverse")   // this didn't work - created clash with entire
                // group
                .help("determines minimal overhang location for raw output .prg."),
        )
        .group(
            ArgGroup::with_name("target")
                .args(&["sea", "load", "end", "auto"])
                .required(true),
        )
        .arg(
            Arg::with_name("reverse")
                .short("r")
                .long("reverse")
                //.conflicts_with("auto")
                .help("output for rdecrunch (unpacks from high to low)"),
        )
        .arg(
            Arg::with_name("compact")
                .short("c")
                .long("compact")
                .help("selects slightly smaller and slower decruncher for sea")
                .requires("sea"),
        )
        .arg(Arg::with_name("verbose").short("v").long("verbose"))
        .arg(
            Arg::with_name("log")
                .short("L")
                .long("log")
                .value_name("LOG_FILE")
                .help("log all the tokens produced"),
        )
        .after_help(
            "
    eg for a simple repack to a self extracting .prg
      nucrunch -cbxo output.prg onefileinput.prg

    Use commas to delineate groups, eg
      nucrunch f1g1.prg f2g1.prg, f1g2.prg, f1g3,prg f2g3.prg f3g3.prg -o out.prg -l 0x1000

    Call decrunch to unpack the first group, then decrunch_next_group for each subsequent group",
        )
}

fn parse_args(app: App) -> Result<Conf, String> {
    let matches = app.get_matches();

    let file_names: Vec<&str> = matches.values_of("inputs").unwrap().collect();
    let input_chunk_list = load_input_chunks(file_names);

    let load_location = match (
        matches.is_present("sea"),
        matches.is_present("load"),
        matches.is_present("end"),
        matches.is_present("auto"),
    ) {
        (true, _, _, _) => TargetLocation::SelfExtracting,
        (_, true, _, _) => TargetLocation::Start(parse_u16(&matches.value_of("load").unwrap())?),
        (_, _, true, _) => TargetLocation::End(parse_u16(&matches.value_of("end").unwrap())?),
        (_, _, _, true) => TargetLocation::Auto,
        _ => unreachable!(),
    };

    Ok(Conf {
        input_chunk_list,
        output_fn: matches.value_of("output").unwrap().to_string(),
        reverse: matches.is_present("reverse") || load_location == TargetLocation::SelfExtracting,
        zero_fill: matches.is_present("zero_fill"),
        sei: matches.is_present("sei"),
        set_eob: matches.is_present("set_eob"),
        load_location,
        compact: matches.is_present("compact"),
        log_fn: matches.value_of("log").and_then(|x| Some(x.to_string())),
        verbose: matches.is_present("verbose"),
        memory_config: parse_u16(matches.value_of("memory_config").unwrap_or("0x37"))? as u8,
        exec_addr: parse_u16(matches.value_of("exec_addr").unwrap_or("0x080d"))?,
    })
}

fn main() {
    let app = build_app();
    match parse_args(app).and_then(|conf| process(&conf)) {
        Err(e) => {
            eprintln!("error: {}", e);
            process::exit(1);
        }
        Ok(()) => {}
    };
}
