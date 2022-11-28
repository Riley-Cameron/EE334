;*******************************************************************************
;                                                                              *
;    Microchip licenses this software to you solely for use with Microchip     *
;    products. The software is owned by Microchip and/or its licensors, and is *
;    protected under applicable copyright laws.  All rights reserved.          *
;                                                                              *
;    This software and any accompanying information is for suggestion only.    *
;    It shall not be deemed to modify Microchip?s standard warranty for its    *
;    products.  It is your responsibility to ensure that this software meets   *
;    your requirements.                                                        *
;                                                                              *
;    SOFTWARE IS PROVIDED "AS IS".  MICROCHIP AND ITS LICENSORS EXPRESSLY      *
;    DISCLAIM ANY WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING  *
;    BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS    *
;    FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL          *
;    MICROCHIP OR ITS LICENSORS BE LIABLE FOR ANY INCIDENTAL, SPECIAL,         *
;    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, HARM TO     *
;    YOUR EQUIPMENT, COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR    *
;    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY   *
;    DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER      *
;    SIMILAR COSTS.                                                            *
;                                                                              *
;    To the fullest extend allowed by law, Microchip and its licensors         *
;    liability shall not exceed the amount of fee, if any, that you have paid  *
;    directly to Microchip to use this software.                               *
;                                                                              *
;    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF    *
;    THESE TERMS.                                                              *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Filename:                                                                 *
;    Date:                                                                     *
;    File Version:                                                             *
;    Author:                                                                   *
;    Company:                                                                  *
;    Description:                                                              *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Notes: In the MPLAB X Help, refer to the MPASM Assembler documentation    *
;    for information on assembly instructions.                                 *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Known Issues: This template is designed for relocatable code.  As such,   *
;    build errors such as "Directive only allowed when generating an object    *
;    file" will result when the 'Build in Absolute Mode' checkbox is selected  *
;    in the project properties.  Designing code in absolute mode is            *
;    antiquated - use relocatable mode.                                        *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Revision History:                                                         *
;                                                                              *
;*******************************************************************************



;*******************************************************************************
; Processor Inclusion
;
; TODO Step #1 Open the task list under Window > Tasks.  Include your
; device .inc file - e.g. #include <device_name>.inc.  Available
; include files are in C:\Program Files\Microchip\MPLABX\mpasmx
; assuming the default installation path for MPLAB X.  You may manually find
; the appropriate include file for your device here and include it, or
; simply copy the include generated by the configuration bits
; generator (see Step #2).
;
;*******************************************************************************

; TODO INSERT INCLUDE CODE HERE
#include p18f46k22.inc

;*******************************************************************************
;
; TODO Step #2 - Configuration Word Setup
;
; The 'CONFIG' directive is used to embed the configuration word within the
; .asm file. MPLAB X requires users to embed their configuration words
; into source code.  See the device datasheet for additional information
; on configuration word settings.  Device configuration bits descriptions
; are in C:\Program Files\Microchip\MPLABX\mpasmx\P<device_name>.inc
; (may change depending on your MPLAB X installation directory).
;
; MPLAB X has a feature which generates configuration bits source code.  Go to
; Window > PIC Memory Views > Configuration Bits.  Configure each field as
; needed and select 'Generate Source Code to Output'.  The resulting code which
; appears in the 'Output Window' > 'Config Bits Source' tab may be copied
; below.
;
;*******************************************************************************

; TODO INSERT CONFIG HERE

;*******************************************************************************
;
; TODO Step #3 - Variable Definitions
;
; Refer to datasheet for available data memory (RAM) organization assuming
; relocatible code organization (which is an option in project
; properties > mpasm (Global Options)).  Absolute mode generally should
; be used sparingly.
;
; Example of using GPR Uninitialized Data
;
;   GPR_VAR        UDATA
;   MYVAR1         RES        1      ; User variable linker places
;   MYVAR2         RES        1      ; User variable linker places
;   MYVAR3         RES        1      ; User variable linker places
;
;   ; Example of using Access Uninitialized Data Section (when available)
;   ; The variables for the context saving in the device datasheet may need
;   ; memory reserved here.
;   INT_VAR        UDATA_ACS
;   W_TEMP         RES        1      ; w register for context saving (ACCESS)
;   STATUS_TEMP    RES        1      ; status used for context saving
;   BSR_TEMP       RES        1      ; bank select used for ISR context saving
;
;*******************************************************************************

; TODO PLACE VARIABLE DEFINITIONS GO HERE

;*******************************************************************************
; Reset Vector
;*******************************************************************************
;LIST P=PIC18F46K22
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;*******************************************************************************
; TODO Step #4 - Interrupt Service Routines
;
; There are a few different ways to structure interrupt routines in the 8
; bit device families.  On PIC18's the high priority and low priority
; interrupts are located at 0x0008 and 0x0018, respectively.  On PIC16's and
; lower the interrupt is at 0x0004.  Between device families there is subtle
; variation in the both the hardware supporting the ISR (for restoring
; interrupt context) as well as the software used to restore the context
; (without corrupting the STATUS bits).
;
; General formats are shown below in relocatible format.
;
;------------------------------PIC16's and below--------------------------------
;
; ISR       CODE    0x0004           ; interrupt vector location
;
;     <Search the device datasheet for 'context' and copy interrupt
;     context saving code here.  Older devices need context saving code,
;     but newer devices like the 16F#### don't need context saving code.>
;
;     RETFIE
;
;----------------------------------PIC18's--------------------------------------
;
; ISRHV     CODE    0x0008
;     GOTO    HIGH_ISR
; ISRLV     CODE    0x0018
;     GOTO    LOW_ISR
;
; ISRH      CODE                     ; let linker place high ISR routine
; HIGH_ISR
;     <Insert High Priority ISR Here - no SW context saving>
;     RETFIE  FAST
;
; ISRL      CODE                     ; let linker place low ISR routine
; LOW_ISR
;       <Search the device datasheet for 'context' and copy interrupt
;       context saving code here>
;     RETFIE
;
;*******************************************************************************

; TODO INSERT ISR HERE

;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************

MAIN_PROG CODE                      ; let linker place main program

START

;define variables
 
CODES EQU 0x100 ;store in bank 1 starting at 0x00
 
;each row of GUESS is: 0 = GUESS1, 1 = GUESS2, 2 = GUESS3, 3 = GUESS4, 
;4 = GUESS_PACKEDH, 5 = GUESS_PACKEDL, 7 = BLK_CNT, 8 = WT_CNT
GUESS EQU 0x110 ;store in bank 1 starting at 0x10; next guess is at 0x20,0x30 etc
 
;index constants:
GUESS_P EQU 4	;0x1X4 and 0x1X5
black_count EQU 7   ;0x1X6
white_count EQU 8   ;0x1X7

;scratch pad
pack_iL EQU 0x10
pack_iH EQU 0x11	;high and low inputs to PACK
pack_o EQU 0x12		;output of PACK
unpack_i EQU 0x13	;input of UNPACK
unpack_oL EQU 0x14	
unpack_oH EQU 0x15	;high and low outputs of UNPACK
CNST5 EQU 0x16		;constant 5, used for random number counter
pot_val EQU 0x17	;A-D conversion of potentiometer signal (2-bytes)
display_digit EQU 0x19	;value to be displayed
prev_dd EQU 0x20	;previous display value (used to check if the display should be updated)
loop_var EQU 0x21	;general loop index 
 
;SFRs
PORTA EQU 0xF80 ;SW2 button (RA4 = PORTA[4])
TRISA EQU 0xF92	;set I/O of portA
BSR   EQU 0xFE0 ;bank select register
WREG  EQU 0xFE8 ;working register
FSR0L EQU 0xFE9	;Low byte of file select register 0
INDF0 EQU 0xFEF	;indirect file register 0
FSR1L EQU 0xFE1
INDF1 EQU 0xFE7
 
;define constants
unpack_mask EQU 0FH
a EQU 0 ;use access bank
F EQU 1 ;File is destination
b EQU 1 ;use BSR

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
	
;init variables and call subroutines
	MOVLW 5
	MOVWF CNST5	;set CNST5 to 5
	
	BSF TRISA,4,a	;set RA4 to input
	
	BSF TRISA,0,a   ;configure RA0 as input
	
	MOVLW 0FH
	MOVWF BSR,a
	BSF ANSELA,0,b  ;set RA0 to analog
	CLRF ANSELB,b   ;set PORTB to digital

	MOVLW b'11110001'
	MOVWF TRISB,a   ;set LEDs to output (RB0-RB3)
	
	;setup analog-digital converter
	MOVLW b'10010111'	;right justified H-L bytes, aquisition time = 4 TAD, clock = internal oscillator
	MOVWF ADCON2,a
	MOVLW b'00000000'
	MOVWF ADCON1,a	;references = Vdd and Vss
	MOVLW b'00000001'
	MOVWF ADCON0,a	;select channel 0 (AN0/RA0),turn on AD converter
	
;start counter loop for random code, loop ends when button is pressed
	LFSR 0,CODES ; each loop in the nest increments one CODE digit (starts at CODE1)
LOOP1
	INCF FSR0L,F,a	    ;increment FSR0 to access CODE2
LOOP2
	    INCF FSR0L,F,a	;increment FSR0 to access CODE3
LOOP3
		    INCF FSR0L,F,a	;increment FSR0 to access CODE4
LOOP4
		    BTFSS PORTA,4,a	;check if the button has been pressed
		    BRA PRESSED		;if its pressed, exit the loop
		    MOVF INDF0,F,a
		    BZ L4		;check if loop variable is 0, if it is jump to L4
		    DECF INDF0,F,a	;if not 0, decrement loop var and continue looping
		    BRA LOOP4
L4		    MOVFF CNST5,INDF0	;L4: set loop var back to 5
		    DECF FSR0L,F,a	;decrement FSR0 to access CODE3
		MOVF INDF0,a
		BZ L3
		DECF INDF0,F,a
		BRA LOOP3
L3		MOVFF CNST5,INDF0
		DECF FSR0L,F,a	    ;decrement FSR0 to access CODE2
	    MOVF INDF0,a
	    BZ L2
	    DECF INDF0,F,a
	    BRA LOOP2
L2	    MOVFF CNST5,INDF0
	    DECF FSR0L,F,a	;decrement FSR0 to access CODE1
	MOVF INDF0,a
	BZ L1
	DECF INDF0,F,a
	BRA LOOP1
L1	MOVFF CNST5,INDF0
	BRA LOOP1
	
PRESSED
	BTFSS PORTA,4,a	    ;wait for button release to start the game
	BRA PRESSED
	
;pack code
	LFSR 0,CODES
	MOVFF INDF0,pack_iH
	INCF FSR0L,F,a
	MOVFF INDF0,pack_iL
	CALL PACK
	MOVLW 4
	MOVWF FSR0L,a
	MOVFF pack_o,INDF0
	MOVLW 2
	MOVWF FSR0L,a
	MOVFF INDF0,pack_iH
	INCF FSR0L,F,a
	MOVFF INDF0,pack_iL
	CALL PACK
	MOVLW 5
	MOVWF FSR0L,a
	MOVFF pack_o,INDF0
	
;MAIN GAME LOOP:
	LFSR 0,GUESS	
MAIN_LOOP
	CALL GET_GUESS	    ;get a guess from the player
	CALL PACK_GUESS	    ;store a packed version of the guess
	CALL BLK_CNT	    ;count exact matches
	CALL WT_CNT	    ;count color matches
	CALL CLEAN_CODE	    ;clean markers off the CODE
	MOVLW 10H
	ADDWF FSR0L,F,a	    ;increment to next guess
	MOVF FSR0L,W,a
	SUBLW 0D0H	    ;check if loop is at 12 yet (0CH)
	BNZ MAIN_LOOP	    ;break after 12 iterations
	
	;see bank 0 for code and processed guesses
	GOTO $

	
;PACK subroutine
PACK
	MOVFF pack_iL,pack_o ;put the low byte into pack_output (O = 0x0L)
	SWAPF pack_iH	    ;swap nibbles of high byte (H = 0xH0)
	MOVF pack_iH,W
	ADDWF pack_o,F	    ;add high byte to output (O = 0xHL)
	RETURN

;subroutine packs the guess in the current FSR0 line
PACK_GUESS	
	MOVFF INDF0,pack_iH
	INCF FSR0L,F,a
	MOVFF INDF0,pack_iL
	CALL PACK	    ;move first two digits into pack input and call the function
	MOVLW 3
	ADDWF FSR0L,F,a	    
	MOVFF pack_o,INDF0  ;store result
	MOVLW 2
	SUBWF FSR0L,F,a
	MOVFF INDF0,pack_iH ;repeat same process as above for next two digits
	INCF FSR0L,F,a
	MOVFF INDF0,pack_iL
	CALL PACK	    
	MOVLW 2
	ADDWF FSR0L,F,a
	MOVFF pack_o,INDF0
	MOVLW 0F0H
	ANDWF FSR0L,F,a	    ;clear lower nibble of FSR0
	RETURN
	
;UNPACK subroutine
UNPACK
	MOVF unpack_i,W	    ;move input into WREG (I = 0xHL)
	ANDLW unpack_mask   ;mask gets only lower nibble
	MOVWF unpack_oL	    ;store value in output low register (0x0L)
	SWAPF unpack_i,W    ;swap nibbles in input (I = 0xLH)
	ANDLW unpack_mask   
	MOVWF unpack_oH	    ;store in output high register (0x0H)
	RETURN
	
;BLK_CNT subroutine
BLK_CNT
	MOVLW 00H
	MOVWF black_count   ;start black count at 0
	LFSR 1,CODES
BC_LOOP	MOVF INDF0,W,a	    ;read code at index of loop
	CPFSEQ INDF1,a	    ;compare code and guess
	BRA DEC_LOOP	    ;if they aren't equal, skip next 3 instructions
	INCF black_count    ;if equal:	add one to black count
	MOVLW 0B0H			;mark matched guess and code with BX and AX so 
	ADDWF INDF0,F,a			;it wont be matched in WT_CNT
	MOVLW 0A0H
	ADDWF INDF1,F,a
DEC_LOOP
	INCF FSR0L,F,a
	INCF FSR1L,F,a	    ;increment FSR1 and FSR0 to loop through each index
	MOVLW 3H
	CPFSGT FSR1L,a
	BRA BC_LOOP	    ;break the loop after all 4 digits are compared
	MOVLW 0F0H
	ANDWF FSR0L,F,a
	MOVLW black_count
	ADDWF FSR0L,F,a
	MOVFF black_count,INDF0
	BCF FSR0L,0,a
	BCF FSR0L,1,a
	BCF FSR0L,2,a
	RETURN

;WT_CNT subroutine
WT_CNT
	MOVLW 00H
	MOVWF white_count   ;start white count at 0
	LFSR 1,CODES
	MOVLW 4H
	ADDWF FSR0L
WT_LP1	DECF FSR0L,F,a	    ;decrement outer loop variable
	MOVLW 4H
	MOVWF FSR1L
	MOVF INDF0,W,a
WT_LP2  DECF FSR1L,F,a	    ;decrement FSR1 to loop through each index of CODE
	CPFSEQ INDF1,a	    ;compare code and guess
	BRA CONT_L	    ;if they aren't equal, skip next 3 instructions and continue looping
	INCF white_count    ;if equal:	add one to white count
	MOVLW 0C0H	    ;change code to CX so it wont be matched again
	ADDWF INDF1,F,a
	MOVLW 0E0H	    ;change matched guess to EX so it wont be matched twice
	ADDWF INDF0,F,a
	MOVLW 0F0H
	ANDWF FSR1L,F,a
CONT_L	MOVF FSR1L,F,a
	BNZ WT_LP2
	MOVF FSR0L,W,a
	ANDLW 0FH
	BNZ WT_LP1	    ;keep looping until GUESS address is 0
	MOVLW white_count
	ADDWF FSR0L,F,a
	MOVFF white_count,INDF0
	MOVLW 0F0H
	ANDWF FSR0L,F,a	    ;clear lower nibble of FSR0
	RETURN

;subroutine to get a guess from the user
GET_GUESS
	MOVLW 4
	MOVWF loop_var	;loop_var = 4 to get four guess digits
AD_LOOP			;loop to read ADRESL constantly (analog value on potentiometer)
	BSF ADCON0,GO	;start conversion
CONVERT
	BTFSC ADCON0,GO	;wait for conversion to finish
	BRA CONVERT
    
	MOVFF ADRESH,pot_val+1  ;read result 
	MOVFF ADRESL,pot_val
    
	CALL GET_NUM	    ;get a number (0-5) by dividing pot_val
	CALL UPDATE_NUM	    ;if the number has changed, display the new value
	
	MOVLW 0
	ADDLW 1		    ;set STATUS,Z to 0
	BTFSS PORTA,4,a	    ;only select the number if the button is pressed
	CALL SELECT_NUM
	BNZ AD_LOOP	    ;keep looping
	MOVLW 0F0H
	ANDWF FSR0L,F,a	    ;clear lower nibble of FSR0
	RETURN
	
SELECT_NUM
	MOVFF display_digit,INDF0
	INCF FSR0L,F,a
	;move LCD cursor over by one
RA4_WAIT
	BTFSS PORTA,4,a
	BRA RA4_WAIT
	DECF loop_var,F,a
	RETURN
	
;shorten analog value to 7 bits and divide by 22 to get a num between 0-5
GET_NUM
	CLRF display_digit,a
	RRNCF pot_val,F,a	    ;rotate to go from 10 bits to 7 bits
	RRNCF pot_val,F,a
	RRNCF pot_val,F,a
	MOVLW b'00011111'	    
	ANDWF pot_val,F,a	    ;clear bits 5-7
	BTFSC pot_val+1,0,a
	BSF pot_val,5,a	    ;move high byte bits 0-1 to pot_val bits 5-6
	BTFSC pot_val+1,1,a
	BSF pot_val,6,a
	;NOTE: we want bit 7 cleared in order to simplify division
GN_LOOP
	MOVLW D'22'
	SUBWF pot_val,F,a	    ;count how many times 22 goes into pot_val (division)
	BN EXIT_GN_LOOP
	INCF display_digit,F,a	    ;store result of division in 'display_digit'
	BRA GN_LOOP
EXIT_GN_LOOP
	RETURN

;only update the number and write it to output if it has changed
UPDATE_NUM
	MOVF display_digit,W,a
	CPFSEQ prev_dd,a
	BRA DISPLAY_NUM
EXIT_UPDATE_NUM
	NOP
	RETURN
DISPLAY_NUM	;write display_digit to PORTB (RB1-RB3), TODO: change to LCD display
	MOVWF prev_dd,a
	BCF PORTB,1,a
	BCF PORTB,2,a
	BCF PORTB,3,a
	BTFSC display_digit,0,a
	BSF PORTB,1,a
	BTFSC display_digit,1,a
	BSF PORTB,2,a
	BTFSC display_digit,2,a
	BSF PORTB,3,a
	BRA EXIT_UPDATE_NUM
    
;CLEAN_CODE subroutine clear marks off of the code
CLEAN_CODE
	LFSR 1,CODES+4
CLEAN_LOOP
	DECF FSR1L,F,a
	MOVLW 0FH
	ANDWF INDF1,F,a
	MOVF FSR1L
	BNZ CLEAN_LOOP
	RETURN
	
	
    END