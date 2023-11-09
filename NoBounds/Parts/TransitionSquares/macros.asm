//--------------------------------------
//Common macros
//--------------------------------------
.macro clear_screen(screen,blank_char){
		ldx #0
		lda #blank_char
!:
		sta screen,x
		sta screen+$100,x
		sta screen+$200,x
		sta screen+$300,x
		dex
		bne !-
}

//Per cambiare bank
.macro bank_0(){
	lda $DD00
	and #%11111100
	ora #%00000011
	sta $DD00
}

.macro bank_1(){
	lda $DD00
	and #%11111100
	ora #%00000010
	sta $DD00
}

.macro bank_2(){
	lda $DD00
	and #%11111100
	ora #%00000001
	sta $DD00
}

.macro bank_3(){
	lda $DD00
	and #%11111100
	ora #%00000000
	sta $DD00
}

//--------------------------
.macro open_irq(){
	pha 
    txa 
    pha 
    tya 
    pha
}

.macro close_irq(){
	pla 
    tay 
    pla 
    tax 
    pla
}

.macro open_irq_zp(zpa,zpx,zpy){
	sta zpa 
    stx zpx 
    sty zpy
}

.macro close_irq_zp(zpa,zpx,zpy){
	lda zpa 
    ldx zpx 
    ldy zpy
}

.macro turn_off_cia_turn_on_raster_irq(){
		lda #$7f
		ldx #$01
		sta $dc0d
		sta $dd0d
		stx $d01a

		lda $dc0d
		lda $dd0d
		asl $d019
}

.macro kill_nmi(){
		lda #<nmi 
        sta $fffa
		lda #>nmi 
        sta $fffb
		jmp !+

nmi:
		rti
!:
}

//--------------------------
.macro kernal_off(){
		lda #$35
		sta $01
}

.macro kernal_on(){
		lda #$35
		sta $01
}
//------------------------

.macro wait(){
!:
		dey
		bne !-
}

.macro wait_y(y){
		ldy #y
!:
		dey
		bne !-
}

//----------------------------
//Cambia un indirizzo usando A
.macro set_addr(source,target){
	lda #>source
	sta target+2
	lda #<source
	sta target+1
}

//----------------------------
//Cambia un indirizzo usando x
.macro set_addr_x(source,target){
	ldx #>source
	stx target+2
	ldx #<source
	stx target+1
}

//----------------------------
//Cambia un indirizzo usando y
.macro set_addr_y(source,target){
	ldy #>source
	sty target+2
	ldy #<source
	sty target+1
}

//----------------------------
//Setta un indirizzo in ZP
.macro set_addr_zp(source,target){
	lda #>source
	sta target+1
	lda #<source
	sta target
}

.macro wait_frame(){
	bit $d011
	bpl *-3
	bit $d011
	bmi *-3
}

//---------------------------
//Punta irq
.macro set_irq(irq){
	lda #<irq
	sta $fffe
	lda #>irq
	sta $ffff
}
//----------------------------

.macro d011(val){
	lda #val
	sta $d011
}

.macro d012(val){
	lda #val
	sta $d012
}

.macro d016(val){
	lda #val
	sta $d016
}

.macro d018(val){
	lda #val
	sta $d018
}

.macro d020(val){
	lda #val
	sta $d020
}

.macro d021(val){
	lda #val
	sta $d021
}

//---------------------------
//Calcola $d018 dati screen e chars
.macro get_d018_charset(screen,chrs){
	.byte [[[screen & $3fff] / $0400] << 4] + [[[chrs & $3fff] / $0800] << 1]
}
