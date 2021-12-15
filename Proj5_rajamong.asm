TITLE Proj5_rajamong     (Proj5_rajamong.asm)

; Author: Gretel Rajamoney
; Last Modified: 11/22/2020
; OSU email address: rajamong@oregonstate.edu
; Course number/section: CS 271   CS271 Section 400
; Project Number: 5            Due Date: 11/22/2020
; Description: The program will start by first displaying a header to the
;			   user, then it will print out the program instructions, next
;			   it will generate a randomized array filled with 200 numbers
;			   between the range of [10,29]. The unsorted array will be 
;			   printed out to the user with 20 numbers per line and 1 space
;			   between each number. Next the unsorted array will be sorted 
;			   into ascending order. The median of the array will be first
;			   calculated and then printed to the user following the round
;			   half up methodology stated on canvas. Next, the sorted array
;			   will be printed out to the user with 20 numbers per line and
;			   1 space between each number. After, the counts of each of the
;			   numbers between [10,29] will be calculated, stored into an 
;			   array and then printed out to the user with 20 numbers per
;			   line and 1 space between each number. Lastly, the program 
;			   will print out a goodbye message to the user and exit out. 

INCLUDE Irvine32.inc

; my programs constants
LOWERLIMIT		=		10				
UPPERLIMIT		=		29
ARRAYSIZE		=		200
COUNTSIZE		=		20
LINELIMIT		=		20
ZERO			=		0
ONE				=		1

.data

; my programs variables
heading			BYTE		"Sorting & Counting with Generated Random Numbers !!     BY: Gretel Rajamoney",0
rules1			BYTE		"First I will generate 200 random numbers between the range of [10,29] & display",0
rules2			BYTE		"the unsorted list, the median of the list, the sorted list in ascending order,",0
rules3			BYTE		"and then the number of times each number occurs within the list. That's all !!",0
list			DWORD		ARRAYSIZE	DUP(?) 
counting		DWORD		COUNTSIZE	DUP(?)
listType	    DWORD       TYPE list
lineCount		DWORD		0
space			BYTE		" ",0
unsorted		BYTE		"here is the unsorted list: ",0
sorted			BYTE		"here is the sorted list: ",0
median			BYTE		"here is the median of the list: ",0
counts			BYTE		"here are the counts of the list: ",0
goodbye			BYTE		"I hope you had fun !! :)",0


.code


; -------------------------------------------------------
; name: main
;
;   this procedure calls all necessary procedures 
;   and then exits once it has completed them all
;
;   pre-conditions: none
;	post-conditions: none
;	receives: none
;	returns: none
; -------------------------------------------------------
main PROC

;---------- sayHello PROC stack ------------
	push	OFFSET		heading		; 20
	push	OFFSET		rules1		; 16
	push	OFFSET		rules2		; 12
	push	OFFSET		rules3		; 8
	call	sayHello				; 4

;---------- fillList PROC stack ------------
	call	Randomize				; 28
	push	listType				; 24
	push	LOWERLIMIT				; 20
	push	UPPERLIMIT				; 16
	push	ARRAYSIZE				; 12
	push	OFFSET		list		; 8
	call	fillList				; 4	

;-------- displayList #1 PROC stack ---------
	push	OFFSET		list		; 36
	push	ONE						; 32
	push	listType				; 28
	push	lineCount				; 24	
	push	LINELIMIT				; 20
	push	OFFSET		space		; 16
	push	OFFSET		unsorted	; 12
	push	ARRAYSIZE				; 8
	call	displayList				; 4

;----------- sortList PROC stack ------------
	push	listType				; 16
	push	OFFSET		list		; 12
	push	ARRAYSIZE				; 8
	call	sortList				; 4

;-------- displayList #2 PROC stack ---------
	push	ZERO					; 32
	push	listType				; 28
	push	lineCount				; 24	
	push	LINELIMIT				; 20
	push	OFFSET		space		; 16
	push	OFFSET		sorted	    ; 12
	push	ARRAYSIZE				; 8
	call	displayList				; 4

;--------- displayMedian PROC stack ----------
	push	ARRAYSIZE				; 20
	push	OFFSET		median		; 16	
	push	OFFSET		list		; 12
	push	listType				; 8
	call	displayMedian			; 4

;----------- countList PROC stack ------------
	push	ZERO					; 32
	push	OFFSET		list		; 28
	push	OFFSET		counting	; 24
	push	ARRAYSIZE				; 20
	push	LOWERLIMIT				; 16	
	push	UPPERLIMIT				; 12
	push	listType				; 8
	call	countList				; 4

;-------- displayList #3 PROC stack ---------
	push	OFFSET		counting	; 36
	push	ONE						; 32
	push	listType				; 28
	push	lineCount				; 24	
	push	LINELIMIT				; 20
	push	OFFSET		space		; 16
	push	OFFSET		counts		; 12
	push	COUNTSIZE				; 8
	call	displayList				; 4

;---------- sayGoodbye PROC stack -----------
	push	OFFSET		goodbye		; 8
	call	sayGoodbye				; 4

	Invoke ExitProcess, 0	        ; exit 

main ENDP


; -------------------------------------------------------
; name: sayHello
;
;   prints out the program heading and rules to the user 
;
;   pre-conditions: none
;	post-conditions: edx is changed
;	receives: offset of heading, rules1, rules2, rules3
;	returns: none
; -------------------------------------------------------
sayHello PROC

	push	ebp
	mov		ebp,		esp
	
	mov		edx,		[ebp + 20]
	call	WriteString						; prints out the program header
	call	CrLf
	call	CrLf

	mov		edx,		[ebp + 16]
	call	WriteString						; prints out the program instructions pt.1
	call	CrLf
	mov		edx,		[ebp + 12]
	call	WriteString						; prints out the program instructions pt.2
	call	CrLf
	mov		edx,		[ebp + 8]
	call	WriteString						; prints out the program instructions pt.3
	call	CrLf

	pop	ebp
	ret 16
sayHello ENDP

; -------------------------------------------------------
; name: fillList
;
;   fills out a 200 element array called 'list' with 
;   randomly generated number using irvine's procedures
;
;   pre-conditions: none
;	post-conditions: eax, ecx, edi, ebp are changed
;	receives: offset of list array, values of listType
;			  variable, LOWERLIMIT, UPPERLIMIT, ARRAYSIZE
;	returns: list array filled with random numbers
; -------------------------------------------------------
fillList PROC

	push	ebp
	mov		ebp,		esp
	
	mov		ecx,		[ebp + 12]		  ; sets loop count to array size (200)
	mov		edi,		[ebp + 8]		  ; moves offset address of the array into edi

	_generateRandoms:
		mov		eax,	[ebp + 16]		  ; moves the constant carrying 29 into eax
		sub		eax,	[ebp + 20]		  ; subtract eax by constant carrying 10
		inc		eax						  	
		call	RandomRange               ; calls irvine proc to generate random numbers
		add		eax,	[ebp + 20]	      ; adds each generated number by 10
		mov		[edi],	eax               ; moves generated random number into array
		add		edi,	[ebp + 24]        ; moves to the next element of the array
		loop	_generateRandoms

	call	CrLf

	pop ebp
	ret 28
fillList ENDP

; -------------------------------------------------------
; name: displayList
;
;   prints out the title for the list being printed as
;	well as the array requested to the user   
;
;   pre-conditions: none
;	post-conditions: eax, ebx, ecx, edx, esi, ebp are changed
;	receives: offset of the array, title, spaces, values of
;			  the listType, lineCount, LINELIMIT, ARRAYSIZE,
;	returns: none
; -------------------------------------------------------
displayList PROC

	push	ebp
	mov		ebp,	esp

	; prints out list title
	mov		edx,	[ebp + 12]				  
	call	WriteString
	call	CrLf

	mov		ecx,		[ebp + 8]				; sets loop counter to array size
	mov		ebx,		[ebp + 24]				; moves line limit constant (20)

	mov		eax,		[ebp + 32]	
	cmp		eax,		1
	je		_test
	jmp		_printNumber

	_test:
		mov		esi,		[ebp + 36]			; moves offset address of the array into esi 

		_printNumber:
			mov		eax,	[esi]				; moves value of element in array into eax
			call	WriteDec                    ; prints stored number
			mov		edx,	[ebp + 16]
			call	WriteString					; prints spacing 
			add		esi,	[ebp + 28]			; moves address of esi to next element
			mov		eax,	[ebp + 20]          
			add		ebx,	1
			cmp		eax,	ebx                 ; checks whether new line needs to be printed
			je		_newLine
			jmp		_endLoop

			_newLine:							; prints new line if program jumps here
				mov		ebx,		0			; resets line count before looping
				call	CrLf
				jmp		_endLoop
				
			_endLoop:

		loop _printNumber

	call CrLf
	pop	ebp
	ret 32
displayList ENDP

; -------------------------------------------------------
; name: sortList
;
;   sorts the randomized array into ascending order
;   
;   pre-conditions: none
;	post-conditions: eax, ebx, ecx, edx, esi, ebp are changed
;	receives: offset of the list array, value of listType,
;			  value of constant called ARRAYSIZE
;	returns: the list array sorted in ascending order
; -------------------------------------------------------
sortList PROC

	push	ebp
	mov		ebp,		esp
	mov		ecx,		[ebp + 8]					;  sets loop count to array size (200)

	_sortNums:
		mov		esi,	[ebp + 12]					; moves offset address of the array into esi
		mov		edx,	ecx
		jmp		_checkNums

		_checkNums:
			mov		eax,	[esi]					; moves value at the address into eax
			mov		ebx,	[ebp + 16]		
			mov		ebx,	[esi + ebx]				; moves value of next element into ebx
			cmp		eax,	ebx						
			jle		_nextNum						
			jg		_switchNums						; if eax > ebx jump to switch values

			_switchNums:                            ; switches values at eax & ebx 
				mov		[esi],		ebx
				mov		ebx,	[ebp + 16]
				mov		[esi + ebx],	eax
				jmp		_nextNum

			_nextNum:
				add		esi,	[ebp + 16]			; moves address to next element of array
				loop	_checkNums
				mov		ecx,	edx					
				loop	_sortNums

	pop ebp
	ret 12
sortList ENDP

; -------------------------------------------------------
; name: displayMedian
;
;   calculates the median of the sorted array and then
;	prints it out to the user with a title, the median
;	is calculated using the rounded up method
;   
;   pre-conditions: none
;	post-conditions: eax, ebx, edx, esi, ebp are changed
;	receives: offset of the list array, median title, 
;			  value of listType, value of ARRAYSIZE
;	returns: none
; -------------------------------------------------------
displayMedian PROC

	push	ebp
	mov		ebp,		esp

	mov		edx,	[ebp + 16]				
	call	WriteString						; prints out median title

	mov		esi,	[ebp + 12]
	jmp		_calculateMedian

	_calculateMedian:
		mov		edx,	0
		mov		eax,	[ebp + 20]				; moves 200 into eax
		mov		ebx,	2		
		div		ebx								; 100 in eax after dividing
		mov		ebx,	[ebp + 8]
		mul		ebx							    ; 400 in eax after multiplying
		add		esi,	eax
		mov		eax,	[esi]					; moves value of 100th element into eax
		add		esi,	[ebp + 8]
		add		eax,	[esi]					; adds value of 101th element into eax
		mov		edx,	0
		mov		ebx,	2
		div		ebx
		cmp		edx,	1						; checks for remainder after dividing
		jl		_noRounding						; if no remainder, no rounding necessary
		jge		_roundUp						; if remainder, jump to round median up

		_noRounding:							
			call	WriteDec					; print out median
			call	CrLf
			jmp		_donePrinting

		_roundUp:
			inc		eax
			call	WriteDec					; print out median after rounding up
			call	CrLf
			jmp		_donePrinting

		_donePrinting:

	pop ebp
	ret 16
displayMedian ENDP

; -------------------------------------------------------
; name: countList
;
;   counts the instances of each number between the range of
;	[10,29] from the sorted list array and then stores them 
;   into the array of 20 elements called counting
;
;   pre-conditions: none
;	post-conditions: eax, ebx, ecx, edx, esi, edi, ebp are changed
;	receives: offset of list and counting array, values of ZERO,
;			  ARRAYSIZE, LOWERLIMIT, UPPERLIMIT, and listType
;	returns: count array filled with counts
; -------------------------------------------------------
countList PROC
	push	ebp
	mov		ebp,		esp

	call	CrLf
	mov		esi,		[ebp + 28]	   ; moves offset address of the array into esi
	add		esi,		[ebp + 8]	   
	mov		edi,		[ebp + 24]	   ; moves offset address of the count array into edi
	mov		ecx,		[ebp + 32]	   ; sets counter 0
	mov		ebx,		[ebp + 16]     ; sets ebx to 10
	jmp		_counter

		_counter:
			mov		eax,    [esi]       ; mov value stored at the address of esi into eax
			cmp		eax,	ebx			
			je		_addCount			; if equal jump to add count
			jmp		_changeArray		; if not equal jump to reset and increment

			_addCount:
				inc		ecx						
				mov		[edi],	ecx				; move count value into edi
				add		esi,	[ebp + 8]		; move address to next element of esi 
				jmp     _counter				

			_changeArray:
				add		edi,	[ebp + 8]		; move address to next element of count array 
				inc		ebx											
				mov		ecx,	[ebp + 32]		; reset count back to zero
				cmp		ebx,	[ebp + 12]		
				ja		_doneCounting			; if ebx is greater than 29, done counting
				jmp		_counter				; if ebx is under or equal to 29 continue counting
		
			_doneCounting:			
				mov		edi,		[ebp + 24]       ; moves offset address of the count array into edi
				add		edi,		76                  
				mov		eax,		[edi]               
				inc		eax                            
				mov		[edi],		eax              ; store incremented count into 20th element

	pop ebp
	ret 28
countList ENDP

; -------------------------------------------------------
; name: sayGoodbye
;
;   prints out a goodbye message to the user
;   
;   pre-conditions: none
;	post-conditions: edx is changed
;	receives: offset of goodbye message
;	returns: none
; -------------------------------------------------------
sayGoodbye	PROC
	push	ebp
	mov		ebp,	esp

	mov		edx,	[ebp + 8]
	call	WriteString               ; print out offsetted goodbye message
	call	CrLf
	call	CrLf

	pop ebp
	ret 4
sayGoodbye	ENDP

END main
