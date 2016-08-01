; ******************************************************
; BASIC .ASM template file for AVR
; ******************************************************
;you will need to change this line depending on your installation
.include "C:\VMLAB\include\m32def.inc"

; Define here the variables
;
.def  temp  = r16
.def  smallest = r17
.def largest = r19

; Define here Reset and interrupt vectors, if any
; the only one at the moment is the reset vector
;that points to the start of the program (i.e., label: start)
reset:
   rjmp start
   reti      ; Addr $01
   reti      ; Addr $02
   reti      ; Addr $03
   reti      ; Addr $04
   reti      ; Addr $05
   reti      ; Addr $06        Use 'rjmp myVector'
   reti      ; Addr $07        to define a interrupt vector
   reti      ; Addr $08
   reti      ; Addr $09
   reti      ; Addr $0A
   reti      ; Addr $0B        This is just an example
   reti      ; Addr $0C        Not all MCUs have the same
   reti      ; Addr $0D        number of interrupt vectors
   reti      ; Addr $0E
   reti      ; Addr $0F
   reti      ; Addr $10

; Program starts here after Reset
.cseg
start:		; start here
; we're going to use the Z register as a pointer to the
; entries in the table so we need to load the location of
; the table into the high and low byte of Z. Note how we
; use the directives 'high' and 'low' to do this.
   clr ZH;
   clr ZL;
   clr R16;
   clr r18;
   clr r19;
   ldi R17,2000 ;     set smallest to a high number

	LDI ZH, high(Tble<<1); Initialize Z-pointer
	LDI ZL, low(Tble<<1) ; a byte at a time  (why <<1?) because the label takes up a space?
	
    ldi R18, (Tble+64<<1); store  location of the last bit + 1 in R16



for_each_table_element:
	LPM temp, Z ; Load constant from table in memory pointed to by Z (r31:r30)
	
   CP temp, smallest ; compare smallest value so far with current table value
   brlo less ; branch to less if temp is less than smaller

   CP largest, temp ; compare smallest value so far with current table value
   brlo large ; branch to less if temp is less than smaller

	INC ZL 		; increment array pointer
; note here that we only increment and compare the lower byte
; (very risky - why risky?).
   CPI ZL,low(Tble+64<<1) ;Tble+64 is one past the final entry
	BRne for_each_table_element  ;
	
	jmp forever;
	
less:
   mov smallest, temp ;  move temp to smaller
   jmp for_each_table_element + 5;  jump back to loop

large:
   mov largest, temp ;  move temp to smaller
   jmp for_each_table_element + 5;  jump back to loop
	
	



here:
   jmp here  ; why do we need this?
; this create 64 bytes in code memory
; The DC directive defines constants in (code) memory
; you will search this table for the desired entry.

forever:
  nop ;
  jmp  forever ;

Tble:
  .DB   33,  85, 134, 215, 211,  22,  74,  41
  .DB   28, 185, 167,  70, 243, 162, 185, 137
  .DB  133,  25, 213,  18,  47, 159,  72, 134
  .DB    5,  76,  38, 246,  52, 150, 213, 202
  .DB   49, 149, 167, 212,  35,  59,  45,  25
  .DB  163,  50, 193,  20, 238,   6, 253,  73
  .DB   64, 192,  16,   6, 250,   4, 127, 229
  .DB    3, 113,  32,  77, 174,  15,  72,  13


.exit  ;done, I'm outta here



