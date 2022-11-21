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
pack_iH EQU 0x11
pack_o EQU 0x12
unpack_i EQU 0x13
unpack_oL EQU 0x14
unpack_oH EQU 0x15
CNST5 EQU 0x16
 
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
 
;init variables and call subroutines
	LFSR 0,GUESS
INIT_GUESSES
	MOVLW GUESS_P	;FSR0 starts at 0x110 so add GUESS_P (4) to access the high byte of the packed guess
	ADDWF FSR0L,F,a	
	MOVLW 33H	;TEMPORARY GUESS will be 3322 (for all 12)
	MOVWF INDF0,a
	INCF FSR0L,F,a
	MOVLW 22H
	MOVWF INDF0,a
	BCF FSR0L,0,a	;clear the lower hex digit of FSR0L (0xXX -> 0xX0)
	BCF FSR0L,2,a
	CALL UNPACK_GUESS   ;this subroutine unpacks both bytes of a packed guess
	MOVLW 10H
	ADDWF FSR0L,F,a	;increment FSR0 by 10H to access next guess (move down by one row of file registers)
	MOVF FSR0L,W,a
	SUBLW 0D0H
	BNZ INIT_GUESSES
	
	MOVLW 5
	MOVWF CNST5	;set CNST5 to 5
	
	MOVLW 0FFH
	MOVWF TRISA,a
	
;start counter loop for random code, loop ends when button is pressed
	LFSR 0,CODES ; each loop in the nest increments one CODE digit (starts at CODE1)
LOOP1
	INCF FSR0L,F,a	    ;increment FSR0 to access CODE2
LOOP2
	    INCF FSR0L,F,a	;increment FSR0 to access CODE3
LOOP3
		    INCF FSR0L,F,a	;increment FSR0 to access CODE4
LOOP4
		    MOVF PORTA,W,a	;check if the button has been pressed
		    ANDLW b'00010000'
		    BNZ PRESSED		;if its pressed, exit the loop
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
	MOVF PORTA,W,a	    ;wait for button release to start the game
	ANDLW b'00010000'
	BNZ PRESSED
	
;main game loop:
	LFSR 0,GUESS	
MAIN_LOOP
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

;subroutine unpacks the guess in the current FSR line
UNPACK_GUESS
	MOVLW GUESS_P
	ADDWF FSR0L,F,a
	MOVFF INDF0,unpack_i
	CALL UNPACK
	MOVLW -4H
	ADDWF FSR0L,F,a
	MOVFF unpack_oH,INDF0
	INCF FSR0L,F,a	
	MOVFF unpack_oL,INDF0
	MOVLW 4H
	ADDWF FSR0L,F,a
	MOVFF INDF0,unpack_i
	CALL UNPACK
	MOVLW -3H
	ADDWF FSR0L,F,a
	MOVFF unpack_oH,INDF0
	INCF FSR0L,F,a	
	MOVFF unpack_oL,INDF0
	BCF FSR0L,0,a
	BCF FSR0L,1,a
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
	ANDWF FSR0L,F,a
	RETURN
	
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