;*******************************************************************
; main.s
; Author: Quinn Kleinfelter
; Date Created: 09/24/2020
; Last Modified: 09/24/2020
; Section Number: 003
; Instructor: Suba Sah
; Lab number: 4
;   Brief description of the program
; The overall objective of this system is an interactive alarm
; Hardware connections
;   PF4 is switch input  (1 = switch not pressed, 0 = switch pressed)
;   PF3 is LED output    (1 activates green LED) 
; The specific operation of this system 
;   1) Make PF3 an output and make PF4 an input (enable PUR for PF4). 
;   2) The system starts with the LED OFF (make PF3 =0). 
;   3) Delay for about 100 ms
;   4) If the switch is pressed (PF4 is 0),
;      then toggle the LED once, else turn the LED OFF. 
;   5) Repeat steps 3 and 4 over and over
;*******************************************************************

GPIO_PORTF_DATA_R       EQU   0x400253FC
GPIO_PORTF_DIR_R        EQU   0x40025400
GPIO_PORTF_AFSEL_R      EQU   0x40025420
GPIO_PORTF_PUR_R        EQU   0x40025510
GPIO_PORTF_DEN_R        EQU   0x4002551C
GPIO_PORTF_AMSEL_R      EQU   0x40025528
GPIO_PORTF_PCTL_R       EQU   0x4002552C
SYSCTL_RCGCGPIO_R       EQU   0x400FE608
GPIO_PORTF_LOCK_R  	    EQU   0x40025520
GPIO_PORTF_CR_R         EQU   0x40025524

       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
       EXPORT  Start
Start
InitPortF
	; SYSCTL_RCGCGPIO_R = 0x20
	MOV R0, #0x20
	LDR R1, =SYSCTL_RCGCGPIO_R
	STR R0, [R1]
	
	LDR R0, [R1] ; Delay before we continue on
	
	; Before we write to the CR Register
	; we need to unlock the port F, using the
	; constant #0x4C4F434B, however we can't
	; write this constant directly to using MOV
	; so we use MOV and MOVT to add it into the register
	; in 2 parts, note: we must use the MOV command before
	; MOVT, otherwise the MOV command will overwrite the top
	; half of the register not unlocking the port
	; GPIO_PORT_F_LOCK_R = 0x4C4F434B
	MOV R0, #0x434B
	MOVT R0, #0x4C4F
	LDR R1, =GPIO_PORTF_LOCK_R
	STR R0, [R1]

	; GPIO_PORTF_CR_R = 0x18
	MOV R0, #0x18
	LDR R1, =GPIO_PORTF_CR_R
	STR R0, [R1]

	; GPIO_PORTF_AMSEL_R = 0x00
	MOV R0, #0x00
	LDR R1, =GPIO_PORTF_AMSEL_R
	STR R0, [R1]
	
	; GPIO_PORTF_PCTL_R = 0x00
	MOV R0, #0x00
	LDR R1, =GPIO_PORTF_PCTL_R
	STR R0, [R1]
	
	; GPIO_PORTF_DIR_R = 0x08
	MOV R0, #0x08
	LDR R1, =GPIO_PORTF_DIR_R
	STR R0, [R1]
	
	; GPIO_PORTF_AFSEL_R = 0x00
	MOV R0, #0x00
	LDR R1, =GPIO_PORT_AFSEL_DIR_R
	STR R0, [R1]
	
	; GPIO_PORTF_PUR_R = 0x10
	MOV R0, #0x10
	LDR R1, =GPIO_PORTF_PUR_R
	STR R0, [R1]
	
	; GPIO_PORTF_DEN_R = 0x18
	MOV R0, #0x18
	LDR R1, =GPIO_PORTF_DEN_R
	STR R0, [R1]
	

loop  

       B    loop


       ALIGN      ; make sure the end of this section is aligned
       END        ; end of file
       