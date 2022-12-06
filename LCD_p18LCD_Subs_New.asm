;*	Filename:  LCD_p18LCD_Subs.asm      CFD mods			*
;*	previously     p18LCD_m.asm    (EMD/CFD mods)			*
;*	           -- LCD Display Subroutines for general use.		*
;*	           -- Include this file in your  Program.asm,		*
;*   ** YOU MUST ** define the (commented-out) CBlock variables		*
;*               ** in your CBLOCK Section **				*
;*	This could be done with Relocatable Code, but not today.	*
;************************************************************************
; Routines ------------------------------------
; --- LCDInit:		>> initialize
; --- LCDLine_1:	>> Write 16 chars to Line_1
; --- LCDLine_2:	>> Write 16 chars to Line_2
; --- i_write:  	>> instruction write
; --- d_write:		>> data        write
; ---------------------------------------------
;
;*  Technical Phyzzie.babble on LCD technology
;*  Liquid crystal displays are made by assembling Top & Bottom polarizing
;       filters shifted by 90 degrees, with a thin layer of a twisted nematic 
;*	liquid placed between them.  A back-light is optional.
;*   The liquid crystal layer normally has chains of molecules that have
;       a natural twist that are aligned between the polarized sheets.
;       The thickness of the layer is such that the amount of twist from
;       the top to the bottom of the layer is 90 degrees.
;    The ends of the molecules attach to the grooves of the polarized layers.
;       First, light passes through the top polarizer, becoming plane polarized.
;       As the light passses through the liquid, the polarization rotates,
;       and reaches 90 degrees at the bottom polarizer and passes through it.
;    In this way, the sandwich is optically transmissive.	
; 
;    Thus, the cell is normally clear; but it turns dark when a potential is applied.
;       The polarizer plates are electrically conductive, so a potential difference
;       (i.e. electric field) can be applied between the plates.
;       The electric field straightens out the twist of the liquid, so that
;       light is not rotated sufficiently to pass through the bottom polarizer.
;        The cell then becomes absorptive.
;    In actual operation, a single sign of potential can not be used, because of
;        electro-plating effects, which would shorten the operating life.  In practice
;        a plus/minus drive is used, with 50% duty cycle
; 
;    In practice, most displays have their own hardware controller (a small microprocessor).
;       Commands and Data are sent to the controller, which controls the display.
;    Here, the controller has 3 control lines (Enable, Read/Write and Register-Select)
;       and a Data.Bus that can be either 4 or 8 bits wide.
;    The PICdem2 wiring is for a 4-bit Data.Bus.

;* These variables  **MUST BE**  declared in the **User's**  main Program code
;	CBLOCK  0x00 ; -----  User RAM.Data in Access Bank 
; COUNTER	; counter for delay loops
; delay		; amount  of  delay for delay subroutines
; temp_wr	; temporary register for LCD written data
; temp_rd	; temporary register for data read from the LCD controller
;	ENDC
;             original notation for ----------------------  READs
#define	LCD_D4		PORTD, 0	; LCD data bits for READs
#define	LCD_D5		PORTD, 1	; These form the 4 bit data bus
#define	LCD_D6		PORTD, 2	; The data bus is bidirectional
#define	LCD_D7		PORTD, 3
;             w-notation is for --------------------------  WRITES
#define	LCD_D4w		LATD, 0		; LCD data bits for WRITEs
#define	LCD_D5w		LATD, 1		; !! bSF and bCF should operate on LATs,
#define	LCD_D6w		LATD, 2		; !!                        not on PORTs
#define	LCD_D7w		LATD, 3		; !!

#define	LCD_D4_DIR	TRISD, 0	; LCD data direction bits
#define	LCD_D5_DIR	TRISD, 1	; The TRIS commands set the port
#define	LCD_D6_DIR	TRISD, 2	;   pin as input (1) or output (0)
#define	LCD_D7_DIR	TRISD, 3	; This allows the direction to be
					; changed under program control

;            w-notation is for --------------------------  WRITEing Commands & Clock
#define LCD_PWRw	LATD, 7
#define	LCD_Ew		LATD, 6		; LCD Enable = Clock. Transfers to the LCD
					;   are syncronized using this "clock" line
#define	LCD_RWw		LATD, 5		; LCD Read/write line
#define	LCD_RSw		LATD, 4		; LCD Register-Select line

#define LCD_PWR_DIR	TRISD, 7
#define	LCD_E_DIR	TRISD, 6	; Direction bits for the control lines
#define	LCD_RW_DIR	TRISD, 5	
#define	LCD_RS_DIR	TRISD, 4	

;****************************************************************************
LCDInit:			; Sets up the LCD controller and selects options
	clrf	PORTA
	
	bCf	LCD_PWR_DIR
	bCf	LCD_E_DIR	;configure control lines for output
	bCf	LCD_RW_DIR
	bCf	LCD_RS_DIR
	
	bCf	LCD_D4_DIR		; Set data bits to outputs
	bCf	LCD_D5_DIR
	bCf	LCD_D6_DIR
	bCf	LCD_D7_DIR
				; Why ??  Register 17-2, pg.182
	movLW	b'00001110'	; On device RESET, ANx pins are AnalogInput
	movWF	ADCON1		;                  by Default !!!

	bSf	LCD_PWRw	; Turn on LCD
	movLW	0xff		; Wait ~15ms @ 20 MHz
	movWF	COUNTER
lil1	movLW	0xFF
	movWF	delay
	rCall	DelayXCycles
	decfsz	COUNTER,F       ;skip over after 255 operations
	bra	lil1
	
	movLW	b'00110000'		;#1 Send control sequence 
	movWF	temp_wr
	bCf	STATUS,C
	rCall	LCDWriteNibble

	movLW	0xff			;Wait ~4ms @ 20 MHz
	movWF	COUNTER
lil2	movLW	0xFF
	movWF	delay
	rCall	DelayXCycles
	decfsz	COUNTER,F
	bra	lil2

	movLW	b'00110000'		;#2 Send control sequence
	movWF	temp_wr
	bCf	STATUS,C
	rCall	LCDWriteNibble

	movLW	0xFF			;Wait ~100us @ 20 MHz
	movWF	delay
	rCall	DelayXCycles
						
	movLW	b'0011000'		;#3 Send control sequence
	movWF	temp_wr
	bCf	STATUS,C
	rCall	LCDWriteNibble

	movLW	0xFF			;Wait ~100us @ 20 MHz
	movWF	delay
	rCall	DelayXCycles

	movLW	b'00100000'		;#4 set 4-bit
	movWF	temp_wr
	bCf	STATUS,C
	rCall	LCDWriteNibble

	rCall	LCDBusy			;Busy?
				
	movLW	b'00101000'		;#5   Function set
	movWF	temp_wr
	rCall	i_write

	movLW	b'00001101'		;#6  Display = ON
	movWF	temp_wr
	rCall	i_write
			
	movLW	b'00000001'		;#7   Display Clear
	movWF	temp_wr
	rCall	i_write

	movLW	b'00000110'		;#8   Entry Mode
	movWF	temp_wr
	rCall	i_write	

	movLW	b'10000000'		;DDRAM addresss 0000
	movWF	temp_wr
	rCall	i_write

	Return

;***************************************************************************
LCDLine_1:			; Select Line 1
	movLW	0x80
	movWF	temp_wr
	rCall	i_write		;instruction write subroutine
	return			;This sets the display cursor to line 1 

LCDLine_2:			; Select Line 2		
	movLW	0xC0	
	movWF	temp_wr
	rCall	i_write		;do instruction write
	return			;this sets line 2

;******************************************************************
i_write:			;write an instruction
	rCall	LCDBusy			
	bCf	STATUS, C	;clear the LCD_RS bit
	rCall	LCDWrite	;write the instruction
	return

;******************************************************************
d_write:			; write data
	rCall	LCDBusy		; check if the LCD controller is busy
	bSf	STATUS, C	; set the carry bit in the status register. 
				; this will set the LCD_RS bit for transmission
	rCall	LCDWrite	; write the data to the LCD
	return

; =====================================================================
; Routines used internally to p18LCD_Subs
; *********************************************************************
DelayXCycles:
	decfsz	delay,F
	bra	DelayXCycles
	return

; *******************************************************************
; LCDWrite sends the data in temp_wr, by first sending the upper nibble
;                                     and then sending the lower nibble. 
LCDWrite:				;writes the data in temp_wr to the LCD
;	rCall	LCDBusy
	rCall	LCDWriteNibble		;first, sent the upper nibble
	swapf	temp_wr,F		;then swap the upper and lower nibbles
	rCall	LCDWriteNibble		;and write the lower nibble
	swapf	temp_wr,F		;then swap them back again

	return				;done


; *******************************************************************
; LCDWriteNibble sends the upper 4 bits of temp_wr to the LCD controller
;     _    ______________________________
; RS  _>--<______________________________
;     _____
; RW       \_____________________________
;                  __________________
; E   ____________/                  \___
;     _____________                ______
; DB  _____________>--------------<______
;
; ===========================================================================
LCDWriteNibble:			;sends the upper 4 bits of temp_wr to the LCD
	btFsS	STATUS, C		; Set the register select
	bCf	LCD_RSw			; depending upon the carry flag
	btFsC	STATUS, C	
	bSf	LCD_RSw

	bCf	LCD_RWw			; Set write mode

	bCf	LCD_D4_DIR		; Set data bits to outputs
	bCf	LCD_D5_DIR
	bCf	LCD_D6_DIR
	bCf	LCD_D7_DIR

	NOP				; Small delay
	NOP
	bSf	LCD_Ew 			; Setup to clock data

			; ----- Set the data bus lines from temp_wr
			;   This is "essentially"  movFF temp_wr,LATD ;
			;   but it _does_Not_presume D4:D7 are bits <4:7>
			;   so it must deal with each bit individually.
	btFsS	temp_wr, 7
	bCf	LCD_D7w 	
	btFsC	temp_wr, 7
	bSf	LCD_D7w 

	btFsS	temp_wr, 6
	bCf	LCD_D6w 	
	btFsC	temp_wr, 6
	bSf	LCD_D6w 

	btFsS	temp_wr, 5
	bCf	LCD_D5w 	
	btFsC	temp_wr, 5
	bSf	LCD_D5w 

	btFsS	temp_wr, 4
	bCf	LCD_D4w 
	btFsC	temp_wr, 4
	bSf	LCD_D4w 

	NOP
	NOP
	bCf	LCD_Ew 		; Send the data

	Return

; *******************************************************************
; LCDRead reads the LCD. It does a full 8 bit read by doing
;                        a pair of 4 bit reads. 
;
;     _____    _____________________________________________________
; RS  _____>--<_____________________________________________________
;               ____________________________________________________
; RW  _________/
;                  ____________________      ____________________
; E   ____________/                    \____/                    \__
;     _________________                __________                ___
; DB  _________________>--------------<__________>--------------<___
;
; ===========================================================================
LCDRead:
	bSf	LCD_D4_DIR		; Set data bits to inputs
	bSf	LCD_D5_DIR		;  by setting all the bits to 1
	bSf	LCD_D6_DIR		;  they are all inputs
	bSf	LCD_D7_DIR		

	btFsS	STATUS, C	; Set the register select
	bCf	LCD_RSw 	;just as before, when the routine is called
	btFsC	STATUS, C	;the state of the carry bit determines the
	bSf	LCD_RSw 	;state of the LCD_RS bit.

	bSf	LCD_RWw 	;Read = 1
	NOP
	NOP			

	bSf	LCD_Ew 		; Set clock line
	NOP
	NOP
	NOP
	NOP

	bSf	temp_rd, 7
	btFsS	LCD_D7		; Set D4 - D7
	bCf	temp_rd, 7

	bSf	temp_rd, 6
	btFsS	LCD_D6			
	bCf	temp_rd, 6

	bSf	temp_rd, 5
	btFsS	LCD_D5			
	bCf	temp_rd, 5

	bSf	temp_rd, 4
	btFsS	LCD_D4
	bCf	temp_rd, 4

	bCf	LCD_Ew 		; Lower clock line
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	bSf	LCD_Ew 		; Raise clock line
	NOP
	NOP

	bSf	temp_rd, 3
	btFsS	LCD_D7			; Get low nibble
	bCf	temp_rd, 3

	bSf	temp_rd, 2
	btFsS	LCD_D6			
	bCf	temp_rd, 2

	bSf	temp_rd, 1
	btFsS	LCD_D5			
	bCf	temp_rd, 1

	bSf	temp_rd, 0
	btFsS	LCD_D4			
	bCf	temp_rd, 0

	bCf	LCD_Ew 		; Lower Clock line

FinRd
	Return

; *******************************************************************
LCDBusy:		; WAIT UNTIL the Busy Flag is Clear
	bCf	STATUS, C	; read the LCD with LCD_RS clear
	rCall	LCDRead	
	btFsC	temp_rd, 7
	bra    LCDBusy
	RETURN
