#import "m65opcodes.asm"
#import "m65macros.s"
	
	
	BasicUpstart65(Entry)
*=$2020
Entry:
		sei
		lda #$35
		sta $01

		enable40Mhz()
		enableVIC4Registers()
		//disableC65ROM()

		//Disable CIA and IRQ interrupts
		lda #$7f
		sta $dc0d 
		sta $dd0d
		lda $dc0d //cancel all CIA-IRQs in queue/unprocessed
		lda $dd0d //cancel all CIA-IRQs in queue/unprocessed 

		lda #$01  //Set Interrupt Request Mask for Raster Interupt
		sta $d01a //Interupt control register

		lda 788
        sta jiffys
        lda 789
        sta jiffys+1
        lda #<actor_animate_isr
        sta 788
        lda #>actor_animate_isr
        sta 789

        lda #250    // trigger first interrupt at row 250
        sta $d012 
        lda $d011   // Bit#0 of $d011 is basically... 
        and #$7f    // ...the 9th Bit for $d012 
        sta $d011   // we need to make sure it is set to zero  

		//VIC IV Full Color Mode (320x200x256) Checker Pattern
		//Does not work in XEMU because of prg size > 64K
		//Test on real Mega65 Hardware

		//1. Get into full - color mode (320x200x256)

		//Turn Off H640 mode or 80 characher mode 
		lda $d031
		and #%01111111
		sta $d031

		//2. Put Character data into memory
		VIC4_SetCharLocation($040000);

		//3. Put Pallete data into memory

		//3. Set video display to Character data
		VIC4_SetScreenLocation($00002800);

		//Logical characters per row (number of memory locations per row) is 80
		lda #$50
		sta $d058
		lda #$00
		sta $d059

		//Num of characters to display on each line is 40
		lda #$28
		sta $d05e

		lda $d054
		ora #%00000101 // set FCLRHI and CHR16
		sta $d054
		
		lda #$00
		sta $d021 //set screen color to black



		//4. Put color pallete into Color Registers
		jsr fill_pallete_regs

		//5. Main Loop
!start:	ldx #255
		lda $d061
		cmp #$2f
		bne !+
		lda $d060
		cmp #$d0
		bne !+
!reset:
		lda #0
		sta $d060
		lda #$28
		sta $d061
!:
		lda $d012
		cmp #250
		beq !raster+
		bne !-
!raster:
		dex
		cpx #0
		bne !-
		clc
		lda $d060
		adc #80
		sta $d060
		bcs !in+
		jmp !end+
!in:
		inc $d061
!end:	jmp !start-

		*=$2800 // screen data is 16 bit
		.for (var y=0; y<25; y++) {
			.for(var x=0;x<40;x++)
			{
				.word (y*40+x)+$1000 // pointers to FCM characters, warning heighest 3 bits (13-15 bits) in 2 byte pointer is for trimming
									 // so valid range for pointer values is 0x1000-0x1FFFF without trimming
			}
			
		}

		cli //uncomment for inerrupts



actor_animate_isr:
        dec $d019        // acknowledge IRQ 
                         // kad se uđe u ISR već je I flag na 1 --> interrupt disable
		//brk
		//lda $d060
		//adc 40
		//sta $d060
        jmp $EA81    // obavezno pozvati izgleda da ovisi o SYSTEM TIMER CIA postavkama
        // da li će jump biti na $EA81 ili $EA31
        //rti ili $EA81 za kraj RTI rutine PLA TAY PLA TAX PLA RTI ili $EA31 za početak
        //jiffy clock rutine

fill_pallete_regs:
{
		ldx #0
!:
		lda pallete_r,x
		sta $d100,x
		lda pallete_g,x
		sta $d200,x
		lda pallete_b,x
		sta $d300,x
		inx
		cpx #pallete_g-pallete_r
		bne !-
		rts 
}

jiffys:         .word 0
//#import "mega65_checker.asm"
#import "mega65_prince.asm"


