use DataChunk;

const BOOT_PRG: &[u8] = include_bytes!("../bin/boot.prg");
const SBOOT_PRG: &[u8] = include_bytes!("../bin/sboot.prg");
const BOOT_SEI_PRG: &[u8] = include_bytes!("../bin/boot_sei.prg");
const SBOOT_SEI_PRG: &[u8] = include_bytes!("../bin/sboot_sei.prg");
const OFFSET_BLOCK_SIZE: usize = 8;

fn lo(addr: usize) -> u8 {
    (addr & 0xff) as u8
}

fn hi(addr: usize) -> u8 {
    ((addr >> 8) & 0xff) as u8
}

struct PatchOfsets {
    memory_config: usize,
    exec_addr: usize,
    stream_start: usize,
    frag_copy: usize,
}

fn parse_boot(boot_prg: &[u8]) -> (Vec<u8>, PatchOfsets, usize) {
    let boot_chunk = DataChunk::from_prg_contents(boot_prg);
    let boot_end = boot_chunk.end_addr() as usize - OFFSET_BLOCK_SIZE;
    let mut boot = boot_chunk.data;
    let boot_len = boot.len();
    let offset_block = boot.split_off(boot_len - OFFSET_BLOCK_SIZE);
    let read_offset = |i| offset_block[i] as usize | ((offset_block[i + 1] as usize) << 8);
    let ofse = PatchOfsets {
        memory_config: read_offset(0),
        exec_addr: read_offset(2),
        stream_start: read_offset(4),
        frag_copy: read_offset(6),
    };
    (boot, ofse, boot_end)
}

pub fn patch_and_prepend_boot(
    stream: &[u8],
    exec_addr: u16,
    memory_config: u8,
    compact: bool,
    sei: bool,
) -> Vec<u8> {
    let boot_prg = match (compact, sei) {
        (false, false) => &BOOT_PRG,
        (false, true) => &BOOT_SEI_PRG,
        (true, false) => &SBOOT_PRG,
        (true, true) => &SBOOT_SEI_PRG,
    };

    let (mut boot, ofse, boot_end) = parse_boot(boot_prg);

    let stream_len = stream.len();

    let data_start = 0x07e8;
    let data_end = data_start + stream_len;

    // first frag_len bytes of the reversed stream are saved to the end,
    // then copied down by the boot, overwriting the area the boot was
    // loaded to.
    let frag_len = stream_len.min(boot_end - data_start);
    let remainder_len = stream_len - frag_len;
    let frag_address = boot_end + remainder_len;
    assert!(frag_len < 513);

    let a0 = frag_address;
    let a1 = frag_address + frag_len - 256;

    boot[ofse.memory_config + 1] = memory_config;
    boot[ofse.exec_addr + 1] = lo(exec_addr as usize);
    boot[ofse.exec_addr + 2] = hi(exec_addr as usize);
    boot[ofse.stream_start + 1] = lo(data_end);
    boot[ofse.stream_start + 3] = hi(data_end - 1);
    boot[ofse.frag_copy + 1] = lo(a0);
    boot[ofse.frag_copy + 2] = hi(a0);
    boot[ofse.frag_copy + 7] = lo(a1);
    boot[ofse.frag_copy + 8] = hi(a1);

    boot.extend(&stream[frag_len..]);
    boot.extend(&stream[..frag_len]);
    boot
}
