******************************************************************
* exp1c55.asm - An assembly program for C5000 CCS simulator
*
*     function: y = x0+x1+x2+x3
******************************************************************
* Section allocation
*
	.def	 x,y,init
x	.usect "vars",8		; reserve 8 locations for x
y	.usect "vars",1		; reserve 1 location for y

	.sect	 "table"
init	.int	 0,5792,8191,5792,0,-5792,-8191,-5792 ; value of x

	.text			; create code section
	.def	 start		; label of the beginning of code

* Processor initialization

start
	BCLR	C54CM		; set C55x native mode
	BCLR	AR0LC		; set AR0 in linear mode
	BCLR	AR6LC		; set AR6 in linear mode

* Copy data to vector x using indirect addressing mode

copy
	AMOV	#x,XAR0		; XAR0 pointing to x0
	AMOV	#init,XAR6	; XAR6 pointing to table of data
	RPT	#7          	; repeat next instruction 8 times
	MOV	*AR6+,*AR0+ 	; copy 8 data to x
	
* Add the first 4 data using direct addressing mode

add
	AMOV	#x,XDP		; XDP pointing to vector x0
	.dp	x		; notify assembler
	MOV	@x,AC0		; AC0 <- x0
	ADD	@(x+1),AC0	; add x1
	ADD	@(x+2),AC0	; add x2
	ADD	@(x+3),AC0	; add x3

* Write the result to memory location y

write
	MOV	AC0,*(#y)	; y <- AC0

end
	NOP
	B	end		; stop here

