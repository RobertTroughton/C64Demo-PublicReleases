.const STANDALONE_BUILD = false

.const BASE_MUSICPLAY = $800

.const RaytraceNightmareStart = $b800

.const PartDone = $88f

.const music = LoadSid("data/Psych858o-Pulsate.sid")

.const r_zp_1 = $12 
.const r_zp_2 = $13
.const r_zp_3 = $14
.const r_zp_4 = $15

.const r_zp_a = $50				// used in stacked IRQs
.const r_zp_x = $51
.const r_zp_y = $52

.const screen = $4000 
.const screen2 = $a400

.const blank_charset_0 = $7800
.const blank_charset_1 = $8000

.const charset = $4800
.const d018_val = [[[screen & $3fff] / $0400] << 4] + [[[charset & $3fff] / $0800] << 1]

.const d018_val_blank0 = [[[screen & $3fff] / $0400] << 4] + [[[blank_charset_0 & $3fff] / $0800] << 1]
.const d018_val_blank1 = [[[screen2 & $3fff] / $0400] << 4] + [[[blank_charset_1 & $3fff] / $0800] << 1]

.const frame_src_zp = $20 
.const frame_addr = $18

.const frame_nr  = $16
.const palette_pt = $17

.const palette_list_pt = $19

//vsp
.const sinpt = $4a
.const dma_irq_line = $2e
.const dma_irq_d011 =  $10

.const d016_val = $33
.const badline_trigger = (dma_irq_line+2 & $7) | (dma_irq_d011 &$f8)
.const sin_lo = $3b
.const sin_hi = $3c
.const sin_pt = $34
.const bg_col = $35
.const d022_col = $36

//horizontal and vertical lines
.const horizontal_black_val = $3a
//.const first_sprite_x = $41
.const sprite_x_pt = $42 

.var screens = $9000 
.var sprites_0 = $4600
.var sprites_1 = $a200

.var irq_ct = $38
.const tmp = $44

.var illegal_table_addr = $400
.var illegal_table = illegal_table_addr

.var unrolled_irq_addr = $c000
