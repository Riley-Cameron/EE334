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
CODES EQU 0x00 ;store in banks 0-3, 0x00
GUESS EQU 0x01 ;store in banks 0-3, 0x01
pack_iL EQU 0x10
pack_iH EQU 0x11
pack_o EQU 0x12
unpack_i EQU 0x13
unpack_oL EQU 0x14
unpack_oH EQU 0x15
CODE_P EQU 0x16 ;2 bytes 0x16-0x17
guess_p EQU 0x20 ;2 bytes 0x20-0x21
black_count EQU 0x22
white_count EQU 0x23
mod6 EQU 0x24
loop_var EQU 0x25 
 
;SFRs
TMR0H EQU 0xFD7 ;timer0 high byte
TMR0L EQU 0xFD6 ;timer0 low byte
T0CON EQU 0xFD5 ;timer0 control
PORTA EQU 0xF80 ;SW2 button (RA4 = PORTA[4})
BSR   EQU 0xFE0 ;bank select register
WREG  EQU 0xFE8 ;working register
 
;define constants
unpack_mask EQU 0FH
rand_mask EQU b'01111111'
a EQU 0 ;use access bank
F EQU 1 ;File is destination
b EQU 1 ;use BSR
 
;init variables and call subroutines
	CLRF BSR,a
	MOVLW 03H	;TEMPORARY GUESS will be 3333
	MOVWF GUESS 
	INCF BSR,F,a	;increment banks to get each value in array
	MOVWF GUESS,b	;BSR = 1
	INCF BSR,F,a
	MOVWF GUESS,b	;BSR = 2
	INCF BSR,F,a
	MOVWF GUESS,b	;BSR = 3
	CLRF BSR,a	;BSR = 0
	
	;init Timer 0
	MOVLW 00H	; load timer with 0000H
	MOVWF TMR0H,a
	MOVWF TMR0L,a
	MOVLW b'10001000';timer control: ON,16bit,internal CLK,no prescaler
	MOVWF T0CON,a
	
;wait for button
WAIT	MOVF PORTA,W,a	    ;move porta to wreg
	ANDLW b'00010000'   ;filter out button bit
	NOP		    ;avoid all even #s on timer0
	BZ WAIT
	MOVF TMR0L,W,a	    ;store timer0 low byte in CODES[0]
	MOVWF CODES
	MOVF TMR0H,W,a	    ;store in CODES[1]
	INCF BSR,F,a
	MOVWF CODES,b
PB_DOWN	MOVF PORTA,W,a	    ;wait for button release to get 2 more code #s
	ANDLW b'00010000'
	NOP
	BNZ PB_DOWN
	MOVF TMR0L,W,a	    ;store in CODES[2]
	INCF BSR,F,a
	MOVWF CODES,b
	MOVF TMR0H,W,a	    ;store in CODES[3]
	INCF BSR,F,a
	MOVWF CODES,b
	CLRF BSR,a
	CALL RAND	    ;convert code digits from 0-255 into 0-5 range
		
	CALL BLK_CNT	    ;count exact matches
	CALL WT_CNT
	GOTO $

;Random code generator subroutine
RAND	MOVLW 03H
	MOVWF BSR,a	    ;start at bank 3
RAND_L	MOVF CODES,W,b
	;ANDLW rand_mask	    ;filter out negative values (range is now 0-127)
	CALL MOD6	    ;perform a %6 on the code value
	MOVWF CODES,b	    ;update the code value
	DECF BSR,F,a 
	BNN RAND_L	    ;if BSR value is negative break the loop
	CLRF BSR,a
	RETURN
	
;PACK subroutine
PACK	MOVFF pack_iL,pack_o ;put the low byte into pack_output (O = 0x0L)
	SWAPF pack_iH	    ;swap nibbles of high byte (H = 0xH0)
	MOVF pack_iH,W
	ADDWF pack_o,F	    ;add high byte to output (O = 0xHL)
	RETURN
	
;UNPACK subroutine
UNPACK	MOVF unpack_i,W	    ;move input into WREG (I = 0xHL)
	ANDLW unpack_mask   ;mask gets only lower nibble
	MOVWF unpack_oL	    ;store value in output low register (0x0L)
	SWAPF unpack_i,W    ;swap nibbles in input (I = 0xLH)
	ANDLW unpack_mask   
	MOVWF unpack_oH	    ;store in output high register (0x0H)
	RETURN
	
;BLK_CNT subroutine
BLK_CNT	MOVLW 00H
	MOVWF black_count   ;start black count at 0
	MOVLW 03H
	MOVWF BSR,a	    ;set bank to 3: loop throug array of codes in reverse order
BC_LOOP	MOVF CODES,W,b	    ;read code at index of  BSR
	CPFSEQ GUESS,b	    ;compare code and guess
	BRA DEC_BSR	    ;if they aren't equal, skip next 3 instructions
	INCF black_count    ;if equal:	add one to black count
	MOVLW 0F0H			;change matched guess to FX so 
	ADDWF GUESS,F,b			;it wont be matched in WT_CNT
DEC_BSR	DECF BSR,F,a	    ;decrement BSR to loop through each index
	BNN BC_LOOP	    ;if BSR is negative, break the loop
	CLRF BSR,a
	RETURN

;WT_CNT subroutine
WT_CNT	MOVLW 00H
	MOVWF white_count   ;start black count at 0
	MOVLW 03H
	MOVWF loop_var	    ;set bank to 3: loop throug array of codes in reverse order
WT_LP1 MOVF CODES,W,b
WT_LP2             ;read code at index of  BSR
	CPFSEQ GUESS,b	    ;compare code and guess
	BRA DEC_BSR	    ;if they aren't equal, skip next 3 instructions
	INCF black_count    ;if equal:	add one to black count
	MOVLW 0F0H			;change matched guess to FX so 
	ADDWF GUESS,F,b			;it wont be matched in WT_CNT
DEC_BSR	DECF BSR,F,a	    ;decrement BSR to loop through each index
	BNN WT_LOOP	    ;if BSR is negative, break the loop
	CLRF BSR,a
	RETURN
	
	RETURN
	
	
;MOD6 subroutine that calculates %6 of the value in WREG
MOD6	MOVF WREG,W,a
	BNN MOD6_L2
MOD6_L1 MOVWF mod6	;L1 is used if the number starts as negative
	ADDLW -6H	
	BN MOD6_L1	
MOD6_L2	MOVWF mod6	;store previous value
	ADDLW -6H	;subtract 6 from current value
	BNN MOD6_L2	;if its negative, return prev value; else, keep looping
	MOVF mod6,W	;move prev value to wreg and return
	RETURN
	
    END