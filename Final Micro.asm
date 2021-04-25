#include<P18F4550.inc>
		
loop_cnt1	set	0x00
loop_cnt2	set	0x01
			org	0x00
			goto start
			org	0x08
			retfie
			org	0x18
			retfie

dup_nop		macro	kk
			variable	i

i=0
			while i	<	kk
			nop
i+=1
			endw
			endm

;**************************************************************************************
								;Main Program
;**************************************************************************************

start		CLRF	TRISD,A ;CONFIGURE TRISD AS AN OUTPUT FOR 7 SEGMENT DISPLAY
			SETF	TRISB,A ;CONFIGURE TRISB AS AN INPUT FOR PUSH BUTTON
			CLRF	PORTD,A ;INTITIALIZE 7 SEGMENT IS OFF
			BCF		TRISC,2,A ;BUZZER AS OUTPUT
			BCF		PORTC,2,A ;INTITIALIZE BUZZER OFF

CHECK		BTFSS	PORTB,0	;CHECK SW1 CONDITION
			BRA		EMERGENCY ;IF SW1 is Pressed
			BRA		CHECK1
			CLRF	PORTD,A

CHECK1		BTFSS	PORTB,1 ;CHECK SW2 CONDITION
			BRA		SIREN ;IF SW2 IS PRESSED
			BRA		CHECK2
			CLRF	PORTD,A

CHECK2		BTFSS	PORTB,2 ;CHECK SW3 CONDITION
			BRA		OFF
			BRA		CHECK
			CLRF	PORTD,A	
			
	
	

;**************************************************************************************
	 			;Subroutine WHEN SW1 IS PRESSED 
;**************************************************************************************

EMERGENCY		CALL	DIAL_911 ;The outcome if PB1 is pressed.
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	OFFLED	
				BRA 	CHECK
				RETURN

;**************************************************************************************
	 			;Subroutine WHEN SW2 IS PRESSED 
;**************************************************************************************

SIREN			CALL	OFFLED
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				CALL	BUZZER
				BRA		CHECK1
				RETURN

;****************************************************************************************
				;Subroutine WHEN SW3 IS PRESSED
;****************************************************************************************

OFF				CALL	DISABLE
				BRA		CHECK2
				RETURN

;****************************************************************************************
				;Subroutine to show "CALL 911" on 7 Segment Display
;****************************************************************************************

DIAL_911		CALL	SHOW_C ;Subroutine to call 911
				CALL	DELAY ;DELAY FOR 1 SEC
				CALL	SHOW_A
				CALL	DELAY
				CALL	SHOW_L
				CALL	DELAY
				CALL	SHOW_L
				CALL	DELAY
				CALL	SHOW_9
				CALL	DELAY
				CALL	SHOW_1
				CALL 	DELAY
				CALL	OFFLED
				CALL	DELAY
				CALL	SHOW_1
				CALL	DELAY
				RETURN

;****************************************************************************************
				;Subroutine to show "DISABLE" on 7 Segment Display
;****************************************************************************************

DISABLE			CALL	SHOW_D
				CALL	DELAY
				CALL	SHOW_I
				CALL	DELAY
				CALL	SHOW_S
				CALL	DELAY
				CALL	SHOW_A
				CALL	DELAY
				CALL	SHOW_B
				CALL	DELAY
				CALL	SHOW_L
				CALL	DELAY
				CALL	SHOW_E
				CALL	DELAY	
				CALL	OFFLED
				RETURN


;****************************************************************************************
							;Subroutine to call Buzzer 
;****************************************************************************************


BUZZER			BSF		PORTC,2,A ;Buzzzer ON 			
				CALL	DELAY ;DELAY FOR 1 SEC  	;Subroutine to call Buzzer
				BCF		PORTC,2,A ;Buzzer OFF
				CALL	DELAY
				RETURN	

			
;****************************************************************************************
				;Subroutine of 'CALL 911' & 'DISABLE' on 7 Segment Display
;****************************************************************************************

SHOW_C		SETF	PORTD,A
			BCF		PORTD,1,A
			BCF		PORTD,2,A
			BCF		PORTD,6,A	
			RETURN

SHOW_A		SETF	PORTD,A
			BCF		PORTD,3,A
			RETURN

SHOW_L		CLRF	PORTD,A
			BSF		PORTD,3,A
			BSF		PORTD,4,A
			BSF		PORTD,5,A
			RETURN

SHOW_9		SETF	PORTD,A
			BCF		PORTD,4,A
			RETURN

SHOW_1		CLRF	PORTD,A
			BSF		PORTD,1,A
			BSF		PORTD,2,A
			RETURN

OFFLED		CLRF	PORTD,A
			RETURN


SHOW_D		SETF	PORTD,A
			BCF		PORTD,6,A
			RETURN

SHOW_I		CLRF	PORTD,A
			BSF		PORTD,1,A
			BSF		PORTD,2,A
			RETURN

SHOW_S		SETF	PORTD,A
			BCF		PORTD,1,A
			BCF		PORTD,4,A
			RETURN

SHOW_B		SETF	PORTD,A
			RETURN


SHOW_E		SETF	PORTD,A
			BCF		PORTD,1,A
			BCF		PORTD,2,A
			RETURN	





;*******************************************************************************
			;Subroutine 1 Second Delay with a 20MHz Crystal Frequency
;*******************************************************************************

DELAY		MOVLW	D'80'
			MOVWF	loop_cnt2,A
AGAIN1		MOVLW	D'250'
			MOVWF	loop_cnt1,A
AGAIN2		dup_nop	D'247'
			DECFSZ	loop_cnt1,F,A
			BRA		AGAIN2
			DECFSZ	loop_cnt2,F,A
			BRA		AGAIN1
			NOP
			RETURN
			
			END