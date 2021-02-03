#import "m65opcodes.asm"
#import "m65macros.s"
	
	
	BasicUpstart65(Entry)
*=$2020
Entry:
		sei
		lda #$35
		sta $01

		//enable40Mhz()
		enableVIC4Registers()
		//disableC65ROM()

		//Disable CIA and IRQ interrupts
		lda #$7f
		sta $dc0d 
		sta $dd0d 

		lda #$00
		sta $d01a //Interupt control register

		cli
		
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
		sta $d020 //set back color to black



		//4. Put color pallete into Color Registers
		jsr fill_pallete_regs


		*=$2800 // screen data is 16 bit
		.for (var y=0; y<25; y++) {
			.for(var x=0;x<40;x++)
			{
				.word (y*40+x)+$1000 // pointers to FCM characters, warning heighest 3 bits (13-15 bits) in 2 byte pointer is for trimming
									 // so valid range for pointer values is 0x1000-0x1FFFF without trimming
			}
			
		}

!:
 		inc $d021
	  	jmp !-

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
		cmp #pallete_g-pallete_r
		bne !-
		rts 
}
//#import "mega65_checker.asm"
#import "mega65_prince.asm"


