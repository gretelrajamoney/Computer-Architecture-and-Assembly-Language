TITLE Proj4_rajamong    (Proj4_rajamong.asm)

; Author: Gretel Rajamoney
; Last Modified: 11/9/2020
; OSU email address: rajamong@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 4        Due Date: 11/15/2020
;--------------------------------------------------------------------------------------
; Description: The program will begin by printing out the title as well as my name to
; the user, next the program will print the instructions out to the user. Next the 
; program will prompt the user to input a number within the range [1,200]. The program
; will next check whether the number is within the range, if the number is not within
; the range it will print an error message and then reprompt the user. If it is within
; the range, the program will print that many prime numbers out to the user. The numbers
; will be printed 10 per row with a minimum of 3 spaces between each number. Lastly the
; program will print out a goodbye message to the user and then exit.
;--------------------------------------------------------------------------------------


INCLUDE Irvine32.inc

; my programs constants

MINIMUMRANGE		=		1
MAXIMUMRANGE		=		200
LINELIMIT			=		10

.data

; my programs variables

header			BYTE		"PRIME NUMBER PRINTER !!		   BY: GRETEL RAJAMONEY",0
rules1			BYTE		"RULES: enter the number of prime number you would like",0
rules2			BYTE		"to see, the number must be between the range [1,200]!!",0
askNum			BYTE		"pls enter the number of primes you would like to see: ",0
error			BYTE		"the number that you entered is out of range !! :(",0
goodbye			BYTE		"thank you for participating, see you again !! :)",0
space			BYTE		"    ",0
lineNum			DWORD		0
num				DWORD		?
remainder		DWORD		?
quotient		DWORD		?
prime			DWORD		2
divNum			DWORD		2
		

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

	call	sayHello
	call	getNumbers
	call	showPrimes
	call	sayBye
	Invoke	ExitProcess,0	; exit to operating system

main ENDP

; -------------------------------------------------------
; name: sayHello
;
;	this procedure prints out the program heading
;	as well as the rules to the user and then
;	prints out new lines before returning
;
;   pre-conditions: edx register initialized
;	post-conditions: edx is changed
;	receives: header = reference to hello message
;			  rules1 = reference to first rules message
;			  rules2 = reference to second rules message
;	returns: none
; -------------------------------------------------------
sayHello PROC

	; prints out the programs title & my name
	mov		edx,	OFFSET		header
	call	WriteString
	call	CrLf
	call	CrLf

	; prints out the programs rules
	mov		edx,	OFFSET		rules1
	call	WriteString
	call	CrLf
	mov		edx,	OFFSET		rules2
	call	WriteString
	call	CrLf
	call	CrLf

	ret
sayHello ENDP

; -------------------------------------------------------
; name: getNumbers 
;
;	this procedure prompts the user to enter a
;	number and then stores the number into a
;   variable, next it checks whether the number
;   is within the necessary ranges... if the 
;   number is not within the range [1,200] then 
;   the program prints out an error message and
;   then reprompts the user for a number... the
;   procedure repeats until a valid number is
;   entered before returning out
;
;   pre-conditions: edx register initialized,
;					num is within range [1,200]
;	post-conditions: edx and eax are changed
;	receives: num = reference to global variable 
;	returns: num variable containing users valid number
; -------------------------------------------------------
getNumbers PROC

	; prompts the user to input a number and then stores it
	_getUserData:
		mov		edx,	OFFSET		askNum
		call	WriteString
		call	ReadDec
		mov		num,	eax
		jmp		_validate

	; checks whether the users number is between the range [1,200]
	_validate:
		cmp		num,	MINIMUMRANGE
		jl		_notInRange
		cmp		num,	MAXIMUMRANGE
		jg		_notInRange
		jmp		_numberValid

	; prints out an error message and then jmps to reprompt user
	_notInRange:
		mov		edx,	OFFSET		error
		call	WriteString
		call	CrLf
		jmp		_getUserData

	; if number is valid, then the procedure jmps here and finishes
	_numberValid:
		call	CrLf

	ret
getNumbers ENDP

; -------------------------------------------------------
; name: isPrime
;
;	this procedure first checks whether a number 
;	is prime by repeatedly dividing the number, 
;	if the number is divisible by anything other
;	than itself then it is not a prime, but if it
;   isn't, then it will return from the procedure
;
;   pre-conditions: num is within [1,200]
;	post-conditions: eax, ebx, and edx are changed
;	receives: prime = reference to starting prime
;			  divNum = reference to starting divisor
;			  quotient = reference to global variable 
;		      remainder = reference to global variable 
;	returns: generated prime stored in variable called prime 		 
; -------------------------------------------------------
isPrime PROC

	; checks whether a number can be divided with a remainder of 0
	_firstCheck:
		mov		edx,		0			 ; sets remainder register to 0
		mov		eax,		prime
		mov		ebx,		divNum
		div		ebx
		mov		quotient,	eax
		mov		remainder,	edx
		cmp		remainder,	0
		je		_secondCheck			 ; jmps to _secondCheck if remainder is 0	
		mov		ebx,		divNum
		add		ebx,		1            ; increments divisor
		mov		divNum,		ebx
		jmp		_firstCheck				 ; repeats until remainder is 0
	
		; checks whether the quotient of the prior subprocedure is 1
		_secondCheck:
			mov		eax,		quotient
			cmp		eax,		1
			je		_doneChecking			; jmps to _doneChecking if quotient is 1 
			mov		eax,		2
			mov		divNum,		eax			; resets the divisor back to 2
			add		prime,		1           ; increments to the next number
			jmp		_firstCheck				; jmps back to _firstCheck to check the next number

			_doneChecking:		; procedure jmps here every time a prime is generated
	ret
isPrime ENDP

; ---------------------------------------------------------
; name: showPrimes
;
;	this procedure first sets the ECX loop 
;	counting register to the number inputted by
;   the user, next it calls the isPrime procedure
;	in order to generate a prime number, next it
;	prints out the number as well as spacing, once
;	ten prime numbers have been printed a new line
;	is printed out, once the procedure has printed
;	out the requested amount of primes and the 
;	loop completes, then the procedure returns
;
;   pre-conditions: recieves prime from the isPrime PROC
;					ecx register is not zero
;	post-conditions: eax, ecx, and edx are changed
;	receives: num = reference to user inputted number
;			  prime = reference to generated prime
;			  lineNum = reference to global variable
;  			  space = reference to spacing variable
;	returns: none
; ---------------------------------------------------------
showPrimes PROC
	mov		ecx,	num			; sets loop counting register to the requested number of primes

		; generates prime number by calling the isPrime procedure
		_startLoop:
			call isPrime

			; prints out prime number as well as spacing accordingly
			_printNum:
				mov		eax,		prime
				call	WriteDec
				add		lineNum,	1
				add		eax,		1
				mov		prime,		eax				; increments to next number
				mov		divNum,		2				; resets divisor back to 2
				cmp		lineNum,	LINELIMIT
				je		_newLine				    ; if 10 numbers have been printed jmp to _newLine 
				mov		edx,	OFFSET		space   
				call	WriteString
				jmp		_printedOut					; jmps to end procedure

				; prints out a new line and jmps to end procedure
				_newLine:
					mov		lineNum,	0
					call	CrLf
					jmp		_printedOut

				_printedOut:			     ; procedure jmps here once finished printing

	loop _startLoop				; loops until the requested number of primes have been printed
	ret
showPrimes ENDP

; -------------------------------------------------------
; name: sayBye 
;
;	this procedure prints out a goodbye message 
;   to the user and then returns out
;
;	pre-conditions: edx register initialized
;	post-conditions: edx is changed
;	receives: goodbye = reference to goodbye message
;	returns: none
; -------------------------------------------------------
sayBye PROC

	; prints out a goodbye message before returning
	call	CrLf
	call	CrLf
	mov		edx,	OFFSET		goodbye
	call	WriteString
	call	CrLf

	ret
sayBye ENDP	


END main
