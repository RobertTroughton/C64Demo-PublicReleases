use std::collections::HashMap;
use std::fs::File;
use std::io;
use std::io::prelude::*;
use std::path::Path;

mod boot;

#[derive(Clone, Debug)]
pub struct DataChunk {
    pub data: Vec<u8>,
    pub addr: u16,
}
impl DataChunk {
    pub fn new(data: &[u8], addr: u16) -> Self {
        DataChunk {
            data: data.to_vec(),
            addr,
        }
    }
    pub fn from_prg_contents(prg: &[u8]) -> Self {
        let data = prg[2..prg.len()].to_vec();
        let lb = prg[0] as u16;
        let hb = prg[1] as u16;
        DataChunk {
            data: data,
            addr: lb + 256 * hb,
        }
    }
    pub fn end_addr(&self) -> u16 {
        self.data.len() as u16 + self.addr
    }
}

#[derive(Clone, Debug)]
pub struct InputChunk {
    pub chunk: DataChunk,
    pub end_of_group: bool,
}

#[derive(Debug, PartialEq)]
pub enum TargetLocation {
    Start(u16),
    End(u16),
    Auto,
    SelfExtracting,
}

#[derive(Debug)]
pub struct Conf {
    pub input_chunk_list: Vec<InputChunk>,
    pub output_fn: String,
    pub reverse: bool,
    pub zero_fill: bool,
    pub sei: bool,
    pub set_eob: bool,
    pub load_location: TargetLocation,
    pub compact: bool,
    pub log_fn: Option<String>,
    pub verbose: bool,
    pub memory_config: u8,
    pub exec_addr: u16,
}

impl Conf {
    pub fn new_sea(fnam: String) -> Self {
        Conf {
            input_chunk_list: Vec::new(),
            output_fn: fnam,
            reverse: true,
            zero_fill: false,
            sei: false,
            set_eob: false,
            load_location: TargetLocation::SelfExtracting,
            compact: false,
            log_fn: None,
            verbose: false,
            memory_config: 0x37,
            exec_addr: 0x080d,
        }
    }
    pub fn memory_config(&mut self, memory_config: u8) {
        self.memory_config = memory_config;
    }
    pub fn exec_addr(&mut self, exec_addr: u16) {
        self.exec_addr = exec_addr;
    }
    pub fn add_chunk(&mut self, c: &DataChunk) {
        self.input_chunk_list.push(InputChunk {
            chunk: c.clone(),
            end_of_group: false,
        });
    }
}

macro_rules! optlog {
    ( $log:expr, $($x:expr),* ) => { if let Some(ref mut f)=$log {let _ = writeln!(f,$($x,)*);} }
}
macro_rules! optprint {
    ( $cond:expr, $($x:expr),* ) => { if $cond {let _ = print!($($x,)*);} }
}
macro_rules! optprintln {
    ( $cond:expr, $($x:expr),* ) => { if $cond {let _ = println!($($x,)*);} }
}
const MAX_RUN: usize = 255;

pub fn read_prg(fnam: &str) -> Result<DataChunk, io::Error> {
    let v = std::fs::read(fnam)?;
    let chunk = DataChunk::from_prg_contents(&v);
    println!(
        "0x{:04x}-0x{:04x}: {:5} bytes read from {}",
        chunk.addr,
        chunk.end_addr(),
        v.len(),
        fnam
    );
    Ok(chunk)
}

fn write_prg(fnam: &str, chunk: &DataChunk) -> Result<(), io::Error> {
    let path = Path::new(fnam);
    let display = path.display();
    let mut file = File::create(&path)?;
    let addrv = vec![(chunk.addr & 0xff) as u8, (chunk.addr >> 8) as u8];

    file.write_all(&addrv)?;
    file.write_all(&chunk.data)?;
    println!(
        "0x{:04x}-0x{:04x}: {:5} bytes written to {}",
        chunk.addr,
        chunk.end_addr(),
        2 + chunk.data.len(),
        display
    );
    Ok(())
}

type DecompressionCost = usize;

const MAX_COST: DecompressionCost = 1000000000;

fn sym_cost(_last_offset: usize, offset: usize, len: usize) -> DecompressionCost {
    (if offset == 0 {
        encoding_costs::egl_k(len - 1, 0) + 8 * len
    } else {
        assert!(len >= 2);
        encoding_costs::egl_k(len - 2, 0) + encoding_costs::new_ofse(offset - 1) + 1
    }) as DecompressionCost
}

#[derive(Debug)]
struct Token {
    offset: usize,
    length: usize,
    cumulative_cost: DecompressionCost,
}

impl Token {
    fn new(predecessor: &Token, offset: usize, length: usize) -> Option<Token> {
        if (offset == 0 && predecessor.offset > 0) ||
            (offset == 0 && predecessor.length > 128) ||  //EXTENSION REQUIRED FOR THIS
            (offset > 0 && length >= 2)
        {
            let cumulative_cost =
                predecessor.cumulative_cost + sym_cost(predecessor.offset, offset, length);
            Some(Token {
                offset,
                length,
                cumulative_cost,
            })
        } else {
            None
        }
    }
}

fn crunch(src: &[u8]) -> Vec<Token> {
    let preflight_len = 32;

    let early_out = true;
    let preflight = true && (src.len() > preflight_len);

    let mut preflight_count = HashMap::new();

    let mut last_seen = HashMap::new();
    let mut tokens: Vec<Token> = Vec::with_capacity(src.len() + 1);
    tokens.push(Token {
        offset: 1,
        length: 0,
        cumulative_cost: 0,
    }); // dummy head needs offset>0 to make starting run legal

    if preflight {
        for spf in 0..src.len() - preflight_len + 1 {
            let key = &src[spf..spf + preflight_len];
            let count: usize = *(preflight_count.get(key).unwrap_or(&0)) + 1;
            preflight_count.insert(key, count);
        }
    }

    for target_len in 1..src.len() + 1 {
        let mut best_match: Token = Token {
            offset: 0,
            length: 0,
            cumulative_cost: MAX_COST,
        }; // this will be beaten

        let search_end = if target_len < MAX_RUN {
            target_len
        } else {
            MAX_RUN
        };
        let mut might_still_find_run_matches = true;
        let mut give_up_on_copies = false;

        for length in 1..search_end + 1 {
            let run_start = target_len - length;

            let predecessor = &tokens[run_start];

            let key = &src[run_start..target_len];
            if preflight && length == preflight_len {
                let k: usize = *preflight_count.get(key).unwrap_or(&0);
                if k == 0 {
                    panic!("run_start = {}, src.len()={}, k=0", run_start, src.len());
                }
                assert!(k >= 1);
                if k == 1 {
                    give_up_on_copies = true;
                }
            }

            if !give_up_on_copies {
                if might_still_find_run_matches || !early_out {
                    if let Some(match_start) = last_seen.get(key) {
                        if let Some(candidate) =
                            Token::new(predecessor, run_start - match_start, length)
                        {
                            if candidate.cumulative_cost <= best_match.cumulative_cost {
                                best_match = candidate;
                            }
                        }
                    } else {
                        might_still_find_run_matches = false;
                    }
                }
                last_seen.insert(key, run_start);
            }

            if let Some(candidate) = Token::new(predecessor, 0, length) {
                if candidate.cumulative_cost <= best_match.cumulative_cost {
                    best_match = candidate;
                }
            }
        }
        assert!(best_match.cumulative_cost != MAX_COST);
        tokens.push(best_match);
    }

    let mut result = Vec::<Token>::new();
    let mut endp = src.len();
    while endp > 0 {
        let next = tokens.swap_remove(endp);
        endp -= next.length;
        result.push(next);
    }
    assert!(endp == 0);
    result.reverse();
    result
}

mod encoding_costs {
    fn log2(mut v: usize) -> usize {
        let mut r = if v > 0xFFFF { 1usize << 4 } else { 0 };
        v >>= r;
        let mut shift = if v > 0xFF { 1usize << 3 } else { 0 };
        v >>= shift;
        r |= shift;
        shift = if v > 0xF { 1usize << 2 } else { 0 };
        v >>= shift;
        r |= shift;
        shift = if v > 0x3 { 1usize << 1 } else { 0 };
        v >>= shift;
        r |= shift;
        r | (v >> 1)
    }

    pub fn egl_k(i: usize, k: usize) -> usize {
        let i = i >> k;
        log2(i + 1) * 2 + 1 + k
    }

    pub fn new_ofse(i: usize) -> usize {
        let upper = i >> 8;
        let bits_for_upper = egl_k(upper, 0);

        if i < 256 {
            bits_for_upper + egl_k(i & 255, 3)
        } else {
            bits_for_upper + 8
        }
    }
}

struct BitStreamCursor {
    bits_written: usize,
    bits_index: usize,
    debug_str: String,
}

impl BitStreamCursor {
    fn new(debug_str: &str) -> BitStreamCursor {
        BitStreamCursor {
            bits_written: 8,
            bits_index: 0,
            debug_str: debug_str.to_string(),
        }
    }
}

struct Encoder {
    encoded_stream: Vec<u8>,
    single: BitStreamCursor,
    pairs: BitStreamCursor,
    nibbles: BitStreamCursor,

    last_symbol_was_copy: bool,
    first_symbol: bool,
    target_addr: u16,
    reverse: bool,

    bit_count: usize,
    // purely for instrumenting encode costs
    log: Option<File>,
    start_addr: u16,
}

impl Encoder {
    fn new(log: Option<File>, start_address: u16, reverse: bool) -> Encoder {
        Encoder {
            encoded_stream: Vec::new(),
            single: BitStreamCursor::new(" "),
            pairs: BitStreamCursor::new("\\/"),
            nibbles: BitStreamCursor::new("|T||"),
            last_symbol_was_copy: false,
            first_symbol: true,
            target_addr: 0,
            reverse: reverse,
            bit_count: 0,
            log: log,
            start_addr: start_address,
        }
    }
    fn _push_byte(&mut self, b: u8) {
        self.encoded_stream.push(b);
    }
    fn push_byte(&mut self, b: u8) {
        optlog!(
            self.log,
            "{:04x}  : {:02x}",
            self.encoded_stream.len() + (self.start_addr as usize),
            b
        );
        self._push_byte(b);
        self.bit_count += 8;
    }
    fn push_word(&mut self, w: u16) {
        self.push_byte((w & 0xff) as u8);
        self.push_byte((w >> 8) as u8);
    }
    fn push_bit(&mut self, b: u8) {
        self.push_bit_to_stream(b, 1)
    }
    fn push_pair_bit(&mut self, b: u8) {
        self.push_bit_to_stream(b, 2)
    }
    //fn push_nibble_bit  (&mut self, b:u8) { self.push_bit_to_stream(b, 4) }

    fn push_bit_to_stream(&mut self, b: u8, sid: usize) {
        let ref mut stream = match sid {
            1 => &mut self.single,
            2 => &mut self.pairs,
            4 => &mut self.nibbles,
            _ => panic!("undefined stream"),
        };

        if stream.bits_written == 8 {
            stream.bits_index = self.encoded_stream.len();
            self.encoded_stream.push(b << 7);
            stream.bits_written = 1;
        } else {
            self.encoded_stream[stream.bits_index] += b * (128 >> stream.bits_written);
            stream.bits_written += 1;
        }
        optlog!(
            self.log,
            "{:04x}.{}: {:}{:x}",
            stream.bits_index + (self.start_addr as usize),
            8 - stream.bits_written,
            &stream.debug_str[{
                                  let j = stream.bits_written % stream.debug_str.len();
                                  j..j + 1
                              }],
            b
        );
        self.bit_count += 1;
    }

    fn push_interleaved_exp_golom_k(
        &mut self,
        x: u16,
        k: i32,
        all_pairs: bool,
        nibble_wrapped: bool,
    ) {
        let remainder = x % (1 << k);
        let mut head = (x >> k) + 1;
        let mut bits: Vec<u8> = Vec::new();
        while head > 0 {
            bits.push((head % 2) as u8);
            head = head >> 1;
        }
        bits.pop(); //last 1 is implicit

        let headstream = if nibble_wrapped {
            4
        } else if all_pairs {
            2
        } else {
            1
        };

        if bits.len() == 0 {
            self.push_bit_to_stream(0, headstream);
        } else {
            self.push_bit_to_stream(1, headstream);

            while let Some(nextbit) = bits.pop() {
                self.push_pair_bit(nextbit);
                self.push_pair_bit(if bits.len() > 0 { 1 } else { 0 });
            }
        }
        if nibble_wrapped {
            assert!(k % 4 == 3)
        }
        for i in 0..k {
            let stream = if nibble_wrapped {
                4
            } else if i < (k - k % 2) || all_pairs {
                2
            } else {
                1
            };
            self.push_bit_to_stream(((remainder >> (k - i - 1)) % 2) as u8, stream);
        }
    }

    fn new_segment(&mut self, target_addr: u16) {
        self.push_word(target_addr);
        optlog!(self.log, "Segment address: {:04x}", target_addr);
        self.first_symbol = true;
        self.last_symbol_was_copy = false;
        self.target_addr = target_addr;
    }
    fn encode_literal(&mut self, data: &[u8]) {
        if self.last_symbol_was_copy {
            self.push_bit(0);
        } else {
            if !self.first_symbol {
                let target_addr = self.target_addr; //preserve what target was before ivar is disturbed by the marker encoding
                self.encode_copy(256, 2); //length 256 to terminate segment, offset of 2 to continue/1 to stop
                self.new_segment(target_addr);
            }
        }
        let length = data.len();
        assert!(length < 256);
        self.push_interleaved_exp_golom_k((length - 1) as u16, 0, false, false);
        for d in data {
            self.push_byte(*d);
        }
        optlog!(
            self.log,
            "           {:04x} ({:02x} {:04x}) {:}",
            self.target_addr,
            length,
            0,
            {
                let hd: Vec<String> = data.iter().map(|x| format!("{:02x}", x)).collect();
                hd.join(" ")
            }
        );
        self.last_symbol_was_copy = false;
        self.first_symbol = false;
        if self.reverse {
            self.target_addr -= length as u16;
        } else {
            self.target_addr += length as u16;
        }
    }
    fn encode_copy(&mut self, length: usize, offset: usize) {
        if self.last_symbol_was_copy {
            self.push_bit(1);
        }
        assert!(offset >= 1);
        let enc_offset = offset - 1;
        let oh = (enc_offset >> 8) as u8;
        let ol = (enc_offset & 0xff) as u8;

        self.push_interleaved_exp_golom_k(oh as u16, 0, true, false);
        if oh > 0 {
            self.push_byte(ol);
        } else {
            self.push_interleaved_exp_golom_k(ol as u16, 3, false, true);
        }
        assert!(length >= 2);
        self.push_interleaved_exp_golom_k((length - 2) as u16, 0, true, false);

        if length < 256 {
            optlog!(
                self.log,
                "           {:04x} ({:02x} {:04x})",
                self.target_addr,
                length,
                offset
            );
        }

        self.last_symbol_was_copy = true;
        self.first_symbol = false;
        if self.reverse {
            self.target_addr -= length as u16;
        } else {
            self.target_addr += length as u16;
        }
    }
}

pub fn process(conf: &Conf) -> Result<(), String> {
    let mut input_chunk_list = conf.input_chunk_list.clone();

    input_chunk_list.last_mut().unwrap().end_of_group = true;

    let self_extracting = match conf.load_location {
        TargetLocation::SelfExtracting => true,
        _ => false,
    };

    let log = conf.log_fn
        .clone()
        .and_then(|path| match File::create(&path) {
            Ok(x) => Some(x),
            _ => None,
        });

    let log_addr = match conf.load_location {
        TargetLocation::Start(addr) => addr,
        TargetLocation::End(_) => 0,
        TargetLocation::Auto => 0,
        TargetLocation::SelfExtracting => 0,
    };

    let mut e = Encoder::new(None, log_addr, conf.reverse);

    e.log = log;
    optlog!(e.log, "producing {}", conf.output_fn);
    optlog!(e.log, "Load address: {:04x}", log_addr);

    optprintln!(conf.verbose, "");

    let group_count = input_chunk_list.iter().filter(|x| x.end_of_group).count();
    if group_count > 1 {
        optprintln!(
            conf.verbose,
            "{} group{}",
            group_count,
            if group_count == 1 { "" } else { "s" }
        );
    }

    if self_extracting {
        let any_early_starters = input_chunk_list.iter().any(|x| x.chunk.addr < 0x0800);
        if any_early_starters {
            return Err(
                "self extracting option doesn't currently support destinations below $0800"
                    .to_owned(),
            );
        }
        if group_count != 1 {
            return Err(
                "self extracting option doesn't currently support multiple groups.".to_owned(),
            );
        }
        optprintln!(conf.verbose, "sorting input chunks");

        let j = input_chunk_list.len() - 1;
        input_chunk_list[j].end_of_group = false;
        input_chunk_list.sort_unstable_by_key(|x| 0xffff - x.chunk.addr);

        if conf.zero_fill {
            optprintln!(conf.verbose, "infilling with clear areas");
            let mut start_of_next = input_chunk_list[0].chunk.addr;
            for c in input_chunk_list[1..].iter_mut() {
                let ea = c.chunk.end_addr();
                if ea < start_of_next {
                    for _ in ea..start_of_next {
                        c.chunk.data.push(0);
                    }
                }
                start_of_next = c.chunk.addr;
            }
        }

        optprintln!(conf.verbose, "merging input chunks");
        let mut merged_chunks = vec![input_chunk_list[0].clone()];
        for c in input_chunk_list[1..].iter() {
            let mut c = c.clone();
            let psa = merged_chunks.last().unwrap().chunk.addr;
            let cea = c.chunk.end_addr();
            if psa == cea {
                {
                    let pred = &merged_chunks.last().unwrap().chunk;
                    c.chunk.data.extend(pred.data.clone());
                }
                merged_chunks.pop();
            }
            merged_chunks.push(c.clone());
        }
        input_chunk_list = merged_chunks;

        if conf.set_eob {
            fn lo(addr: u16) -> u8 {
                (addr & 0xff) as u8
            };
            fn hi(addr: u16) -> u8 {
                ((addr >> 8) & 0xff) as u8
            };
            let end_addr = input_chunk_list.last().unwrap().chunk.end_addr();
            optprintln!(
                conf.verbose,
                "adding chunk to set 0x2d/2e to 0x{:04x}",
                end_addr
            );
            input_chunk_list.insert(
                0,
                InputChunk {
                    chunk: DataChunk {
                        data: vec![lo(end_addr), hi(end_addr)],
                        addr: 0x002d,
                    },
                    end_of_group: false,
                },
            );
        }

        {
            let j = input_chunk_list.len() - 1;
            input_chunk_list[j].end_of_group = true;
        }
        optprintln!(conf.verbose, "");
    }

    let mut suggested_start_address = 0;
    let mut suggested_end_address = 0xffff;
    let mut first_in_group = true;
    for input_spec in input_chunk_list.iter() {
        if first_in_group {
            optprintln!(conf.verbose, "starting group");
            first_in_group = false;
        }

        let chunk = &input_spec.chunk;
        let mut buffer = chunk.data.clone();

        optprint!(
            conf.verbose,
            "0x{:04x}-0x{:04x}: {:5} bytes",
            chunk.addr,
            chunk.end_addr(),
            buffer.len()
        );

        let enc_target_addr = if conf.reverse {
            buffer.reverse();
            chunk.addr as usize + buffer.len() - 1
        } else {
            chunk.addr as usize
        };
        e.new_segment(enc_target_addr as u16);

        let tokens = crunch(&buffer);

        let pre_encode_len = e.encoded_stream.len();
        let mut encoded_bytes = 0;
        for t in tokens {
            if t.offset == 0 {
                let literal = &buffer[encoded_bytes..encoded_bytes + t.length];
                optlog!(e.log, "encoding literal token ({} bytes)", t.length);
                e.encode_literal(literal);
            } else {
                optlog!(
                    e.log,
                    "encoding copy token (length {}, offset {})",
                    t.length,
                    t.offset
                );
                e.encode_copy(t.length, t.offset);
            }

            encoded_bytes += t.length;

            // at this point, file has taken len(e.encoded_stream) bytes to encode encoded_bytes bytes from current chunk,
            if !conf.reverse {
                // forward stream; need to ensure
                //    compressed_start+e.encoded_stream.len()>=enc_target_addr+encoded_bytes
                //    compressed_start>=enc_target_addr+encoded_bytes-e.encoded_stream.len()
                if suggested_start_address + e.encoded_stream.len()
                    < encoded_bytes + enc_target_addr
                {
                    suggested_start_address =
                        encoded_bytes + enc_target_addr - e.encoded_stream.len();
                }
            } else {
                // reversed stream, must ensure
                //    compressed_end-e.encoded_stream.len()<=enc_target_addr-encoded_bytes
                //    compressed_end<=enc_target_addr-encoded_bytes+e.encoded_stream.len()
                if suggested_end_address + encoded_bytes > enc_target_addr + e.encoded_stream.len()
                {
                    assert!(enc_target_addr > encoded_bytes);
                    suggested_end_address =
                        enc_target_addr - encoded_bytes + e.encoded_stream.len();
                }
            }
        }

        if input_spec.end_of_group {
            e.encode_copy(256, 1); //length 256 to terminate segment, offset of 2 to continue/1 to stop
        } else {
            e.encode_copy(256, 2); //length 256 to terminate segment, offset of 2 to continue/1 to stop
        }
        let bytes_produced = e.encoded_stream.len() - pre_encode_len;

        if bytes_produced <= buffer.len() {
            optprintln!(
                conf.verbose,
                " compressed to {:5} bytes ({:5.1}% smaller)",
                bytes_produced,
                (buffer.len() as f32 - bytes_produced as f32) * 100f32 / (buffer.len() as f32)
            );
        } else {
            optprintln!(
                conf.verbose,
                " expanded to   {:5} bytes ({:5.1}% bigger)",
                bytes_produced,
                (bytes_produced as f32 - buffer.len() as f32) * 100f32 / (buffer.len() as f32)
            );
        }

        if !conf.reverse {
            let suggested_end_address = (suggested_start_address + e.encoded_stream.len()) as u16;
            optprintln!(
                conf.verbose && !self_extracting,
                "lowest usable end address now 0x{:04x}, 0x{:04x} bytes past end of chunk",
                suggested_end_address,
                suggested_end_address as usize - chunk.end_addr() as usize
            );
        } else {
            let suggested_start_address =
                (suggested_end_address - (e.encoded_stream.len() - 1)) as u16;
            optprintln!(
                conf.verbose && !self_extracting,
                "highest usable start address now 0x{:04x}, 0x{:04x} bytes before start of chunk",
                suggested_start_address,
                chunk.addr as usize - suggested_start_address as usize
            );
        }
        if input_spec.end_of_group {
            optprintln!(conf.verbose, "ending group\n");
            first_in_group = true;
        }
    }

    let load_addr = match conf.load_location {
        TargetLocation::Start(addr) => addr,
        TargetLocation::End(e_addr) => e_addr - (e.encoded_stream.len() as u16),
        TargetLocation::Auto => {
            (if conf.reverse {
                suggested_end_address - (e.encoded_stream.len() - 1)
            } else {
                suggested_start_address
            }) as u16
        }
        TargetLocation::SelfExtracting => 0x0801,
    };
    if conf.reverse {
        optprintln!(conf.verbose, "reversing stream");
        e.encoded_stream.reverse();
    }
    if let TargetLocation::SelfExtracting = conf.load_location {
        optprintln!(conf.verbose, "prepending boot");
        e.encoded_stream = boot::patch_and_prepend_boot(
            &e.encoded_stream,
            conf.exec_addr,
            conf.memory_config,
            conf.compact,
            conf.sei,
        );
    }
    write_prg(
        &conf.output_fn[..],
        &DataChunk {
            addr: load_addr,
            data: e.encoded_stream, // no need to clone, as we're done with the encoder now.
        },
    ).map_err(|e| format!("Could not write {} - {}", &conf.output_fn, e))
}
