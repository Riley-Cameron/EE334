; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include p18f46k22.inc
    
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START

CBlock  0x300 ; -----  User RAM.Data in Access Bank 
Count2, Count1, Count0   ; counter for Delay
	; ------  for  LCD_p18LCD_Subs.asm  routines
COUNTER		; counter for delay loops
delay		; amount  of  delay for delay subroutines
temp_wr		; temporary register for LCD written data
temp_rd		; temporary register for data read from the LCD controller
ptr_pos, ptr_count, cmd_byte	; used by LCD routines
EndC
	
;Guess digits
GA EQU 0x10
GB EQU 0x11
GC EQU 0x12
GD EQU 0x13

;# of each possible digit
B0 EQU 0x20
B1 EQU 0x21
B2 EQU 0x22
B3 EQU 0x23
B4 EQU 0x24
B5 EQU 0x25

;variables for guessing different combinations
C_A EQU 0x30
C_B EQU 0x31
C_C EQU 0x32
C_D EQU 0x33
 
;variables for displaying guess
display_A EQU 0x40
display_B EQU 0x41
display_C EQU 0x42
display_D EQU 0x43

input_black EQU 0x50	;user input black count
input_white EQU 0x51
X EQU 0x52		;X is any digit that isnt in the code
Btotal EQU 0x53		;keeps track of total black count in loop1

a EQU 0
 
;START PROGRAM:
    MOVLB 0FH
    MOVLW 0F0H
    MOVWF ANSELB
    BSF TRISA,4
    BSF TRISB,0
    
;clear RAM (Bank 0 & 1)
    LFSR 0,0x0FF
    LFSR 1,0x1FF
CLEAR_LOOP
    CLRF INDF0,a
    CLRF INDF1,a
    DECF FSR0L,F,a
    DECF FSR1L,F,a
    BNZ CLEAR_LOOP
    CLRF INDF0,a
    CLRF INDF1,a
    
    CALL	LCDInit		; Initialize PORTA, PORTD, and LCD Module
    CALL	LCDLine_1	;move cursor to line 1
	
    CALL DELAY		;wait 0.1 seconds
    
    CALL DISPLAY_INFO
    CALL WAIT_SW3
    
    CALL DISPLAY_WELCOME
    CALL WAIT_SW2
    
    
    CALL SEND_GUESS
    GOTO $
 
;wait for sw2 press & release
WAIT_SW2
    BTFSC PORTA,4
    BRA WAIT_SW2
SW2_RELEASE
    BTFSS PORTA,4
    BRA SW2_RELEASE
    RETURN

;wait for sw3 press & release
WAIT_SW3
    BTFSC PORTB,0
    BRA WAIT_SW3
SW3_RELEASE
    BTFSS PORTB,0
    BRA SW3_RELEASE
    RETURN
    
;Send guess to player and get feedback
SEND_GUESS
    MOVLW 1H
    MOVWF temp_wr
    CALL i_write	;clear LCD

    CALL DELAY

    CALL LCDLine_1

    MOVLW 0EH
    MOVWF temp_wr
    CALL i_write	;show cursor

    MOVLW A'M'
    MOVWF temp_wr
    CALL d_write

    MOVLW A'y'
    MOVWF temp_wr
    CALL d_write

    MOVLW A' '
    MOVWF temp_wr
    CALL d_write

    MOVLW A'G'
    MOVWF temp_wr
    CALL d_write

    MOVLW A'u'
    MOVWF temp_wr
    CALL d_write

    MOVLW A'e'
    MOVWF temp_wr
    CALL d_write

    MOVLW A's'
    MOVWF temp_wr
    CALL d_write

    MOVLW A's'
    MOVWF temp_wr
    CALL d_write

    MOVLW A':'
    MOVWF temp_wr
    CALL d_write

    MOVLW A' '
    MOVWF temp_wr
    CALL d_write

    MOVF display_A,W
    ADDLW 30H
    MOVWF temp_wr
    CALL d_write

    MOVF display_B,W
    ADDLW 30H
    MOVWF temp_wr
    CALL d_write

    MOVF display_C,W
    ADDLW 30H
    MOVWF temp_wr
    CALL d_write

    MOVF display_D,W
    ADDLW 30H
    MOVWF temp_wr
    CALL d_write
    
    CALL LCDLine_2
    
    MOVLW A'B'
    MOVWF temp_wr
    CALL d_write

    MOVLW A':'
    MOVWF temp_wr
    CALL d_write
    
    MOVLW A' '
    MOVWF temp_wr
    CALL d_write

    MOVLW A' '
    MOVWF temp_wr
    CALL d_write
    
    MOVLW A'W'
    MOVWF temp_wr
    CALL d_write

    MOVLW A':'
    MOVWF temp_wr
    CALL d_write
    
    MOVLW 10H
    MOVWF temp_wr
    CALL i_write
    
    MOVLW 10H
    MOVWF temp_wr
    CALL i_write
    
    MOVLW 10H
    MOVWF temp_wr
    CALL i_write
    
    MOVLW 10H
    MOVWF temp_wr
    CALL i_write
    
    CLRF input_black
    MOVF input_black,W
    ADDLW 30H
    CALL d_write
    MOVLW 10H
    MOVWF temp_wr
    CALL i_write
GET_BLACK_COUNT
    BTFSS PORTB,0
    CALL BC_SW3
    BTFSC PORTA,4
    BRA GET_BLACK_COUNT
    
    RETURN

;helper subroutine for black count when SW3 is pressed
BC_SW3
    BTFSS PORTB,0
    BRA BC_SW3
    INCF input_black,F
    MOVLW 4H
    CPFSGT input_black
    CLRF input_black
    MOVF input_black,W
    ADDLW 30H
    CALL d_write
    MOVLW 10H
    MOVWF temp_wr
    CALL i_write
    RETURN
    
;display welcome message:
DISPLAY_WELCOME
	MOVLW 1
	MOVWF temp_wr
	CALL i_write
	CALL DELAY
	
	CALL LCDLine_1
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'M'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'A'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'S'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'T'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'E'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'R'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'M'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'I'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'N'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'D'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	CALL LCDLine_2
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'R'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'E'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'V'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'E'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'R'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'S'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'E'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A' '
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'G'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'A'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'M'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'E'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW 0CH
	MOVWF temp_wr
	CALL i_write
	
	RETURN

;display info:
DISPLAY_INFO
	MOVLW 1
	MOVWF temp_wr
	CALL i_write
	CALL DELAY
	
	CALL LCDLine_1
	
	MOVLW A'C'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'o'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'n'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A't'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'r'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'o'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'l'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A's'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A':'
	MOVWF temp_wr
	CALL d_write
	
	CALL LCDLine_2
	
	MOVLW A'S'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'W'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'2'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A':'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'N'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'e'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'x'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A't'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A' '
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'S'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'W'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'3'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A':'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'+'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'/'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW A'-'
	MOVWF temp_wr
	CALL d_write
	
	MOVLW 0CH
	MOVWF temp_wr
	CALL i_write
	
	RETURN
; ---------------- Wait a while = 1 x256 x256 x3 uSec = 0.1 sec
DELAY
	movLW	1
	movWF	Count2
	clrF	Count1
	clrF	Count0
WLoo	
	decFsZ	Count0
	bra		WLoo
	decFsZ	Count1
	bra		WLoo
	decFsZ	Count2
	bra		WLoo	
        RETURN

;include file for the LCD subroutines
#Include LCD_p18LCD_Subs_New.asm  ; Contains:
; --- LCDInit:		>> initialize
; --- LCDLine_1:	>> Cursor to Line_1
; --- LCDLine_2:	>> Cursor to to Line_2
; --- i_write:  	>> instruction write
; --- d_write:		>> data        write
	
    END