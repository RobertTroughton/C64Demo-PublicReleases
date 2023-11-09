.const STANDALONE_BUILD = false

.const BASE_MUSICPLAY = $800

.const TechTechStart = $9700

.const PartDone = $88f
    
.const music = LoadSid("../../Music/Acrouzet-Golden.sid")

.const r_zp_1 = $12
.const r_zp_2 = $13
.const r_zp_3 = $14

.const zp_addr_tech= $23
.const update_ct = $18 
.const update_amt = $19 
.const speed = $1a
.const unrolled_tg_addr = $28
.const dd00_store = $35 

.const transition_sin = $e500
.const temporary_colour_rasters_sin = transition_sin
.const temporary_colour_table = $400 
.const temporary_colour_movement_sin = $500 

//Tech tech variables
.const tech_screen_list = List().add(
    $4800,$4c00,$5000,$5400,$5800,$5c00,$6000,$6400,$6800,$6c00,$7000,$7400,$7800,$7c00,
    $8800,$8c00,$a000,$a400,$a800,$ac00,$b000,$b400,$b800,$bc00,$c800,$cc00
)

.function get_d018_val(screen_addr){
    .return [[[screen_addr & $3fff] / $0400] << 4] + [[[logo_charset_b1 & $3fff] / $0800] << 1]
}

.function get_bank_val(screen_addr){
    .const dd00_b0 = %00000011
    .const dd00_b1 = %00000010
    .const dd00_b2 = %00000001
    .const dd00_b3 = %00000000

    .var bank_list = List().add(dd00_b0, dd00_b1,dd00_b2,dd00_b3)
    .return bank_list.get(screen_addr/ $4000)
}

//extra tech screens for bankswitching - b3
//.const logo_charset_b0 = $3000
.const logo_charset_b1 = $4000
.const logo_charset_b2 = $8000
.const logo_charset_b3 = $c000 

.var d018_tech_list = List()
.var dd00_tech_list = List()
.for(var x=0;x<tech_screen_list.size();x++){
    .eval d018_tech_list.add(get_d018_val(tech_screen_list.get(x)))
    .eval dd00_tech_list.add(get_bank_val(tech_screen_list.get(x)))
}

.const MAX_SHIFT = d018_tech_list.size()
.const MAX_SHIFT_PX = MAX_SHIFT*8

//.print("MAX_SHIFT_PX: " + MAX_SHIFT_PX)

/*
.for(var x=0;x<tech_screen_list.size();x++){
    .print("screen: " + toHexString(tech_screen_list.get(x)) + " d018: " + toHexString(d018_tech_list.get(x)) + " dd00: " + toHexString(dd00_tech_list.get(x)))
}
*/