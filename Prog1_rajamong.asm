TITLE Prog1_rajamong     (Prog1_rajamong.asm)

; Author: Gretel Rajamoney
; Last Modified: 10/17/2020
; OSU email address: rajamong@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 1        Due Date: 10/18/2020
; Description: This project will start by displaying my name as well as
;			   the program title onto the output screen. Next, it will
;			   display instructions for the user to follow. After, it 
;			   will prompt the user to enter three number in decending
;			   order, names as A, B, C. Next, using these inputted values
;			   the program will calculate and display to the user the 
;			   sums and differences:(A+B, A-B, A+C, A-C, B+C, B-C, A+B+C).
;			   Lastly, the program will display a closing message and end.
;			   EC: handles negative results and computes B-A,C-A,C-B,C-B-A

INCLUDE Irvine32.inc


.data


header			BYTE		"          ELEMENTARY ARITHMETIC !!         BY: GRETEL RAJAMONEY",0
rules			BYTE		"Enter 3 numbers A > B > C, and I will display the sums and differences !!",0
firstNum		BYTE		"Please enter your First Number: ",0
secondNum		BYTE		"Please enter your Second Number: ",0
thirdNum		BYTE		"Please enter your Third Number: ",0
addition		BYTE		" + ",0
subtract		BYTE		" - ",0
equals			BYTE		" = ",0
finish			BYTE		"Thank you for Participating !! See you later !! :)",0
valueA			DWORD		?
valueB			DWORD		?
valueC			DWORD		?
AplusB			DWORD		?
AminusB			DWORD		?
AplusC			DWORD		?
AminusC			DWORD		?
BplusC			DWORD		?
BminusC			DWORD		?
ABCtotal		DWORD		?
extracredit		BYTE		"**EC: Program handles negative results and computes B-A, C-A, C-B, C-B-A !!",0
BminusA			DWORD		?
CminusA			DWORD		?
CminusB			DWORD		?
ABCtotalEC		DWORD		?


.code
main PROC

; the following code prints the program heading, extra credit, and instructions to the user
_Introduction:

	; prints heading
	mov		edx,	OFFSET		header
	call	WriteString
	call	CrLf

	; prints extra credit prompt
	mov		edx,	OFFSET		extracredit
	call	WriteString
	call	CrLf
	call	CrLf

	; prints instructions
	mov		edx,	OFFSET		rules
	call	WriteString
	call	CrLf


; the following code collects the values for A, B, and C, from the user and 
; stores the inputted values into their designated variables
_GetData:

	; collects and stores variable A
	call	CrLf
	mov		edx,	OFFSET		firstNum
	call	WriteString
	call	ReadInt
	mov		valueA,		eax
	
	; collects and stores variable B
	mov		edx,	OFFSET		secondNum
	call	WriteString
	call	ReadInt
	mov		valueB,		eax

	; collects and stores variable C
	mov		edx,	OFFSET		thirdNum
	call	WriteString
	call	ReadInt
	mov		valueC,		eax
	call	CrLf


; the following code calculates the necessary elementary arithmetic
; A+B, A-B, A+C, A-C, B+C, B-C, A+B+C
; EC: B-A, C-A, C-B, C-B-A	
_Calculations:

	; calculates A+B
	mov		eax,		valueA
	mov		ebx,		valueB
	add		eax,		ebx
	mov		AplusB,		eax

	; calculates A-B
	mov		eax,		valueA
	mov		ebx,		valueB
	sub		eax,		ebx
	mov		AminusB,	eax

	; calculates A+C
	mov		eax,		valueA
	mov		ebx,		valueC
	add		eax,		ebx
	mov		AplusC,		eax

	; calculates A-C
	mov		eax,		valueA
	mov		ebx,		valueC
	sub		eax,		ebx
	mov		AminusC,	eax

	; calculates B+C
	mov		eax,		valueB
	mov		ebx,		valueC
	add		eax,		ebx
	mov		BplusC,		eax

	; calculates B-C
	mov		eax,		valueB
	mov		ebx,		valueC
	sub		eax,		ebx
	mov		BminusC,	eax

	; calculates A+B+C
	mov		eax,		AplusB
	mov		ebx,		valueC
	add		eax,		ebx
	mov		ABCtotal,	eax

	; EC calculates B-A
	mov		eax,		valueB
	mov		ebx,		valueA
	sub		eax,		ebx
	mov		BminusA,	eax

	; EC calculates C-A
	mov		eax,		valueC
	mov		ebx,		valueA
	sub		eax,		ebx
	mov		CminusA,	eax

	; EC calculates C-B
	mov		eax,		valueC
	mov		ebx,		valueB
	sub		eax,		ebx
	mov		CminusB,	eax

	; EC calculates C-B-A
	mov		eax,		CminusB
	mov		ebx,		valueA
	sub		eax,		ebx
	mov		ABCtotalEC,	eax


; the following code prints out necessary calculations to the user
; A+B, A-B, A+C, A-C, B+C, B-C, A+B+C
; EC: B-A, C-A, C-B, C-B-A	
_DisplayResults:

	; prints A+B
	mov		eax,	valueA
	call	WriteDec
	mov		edx,	OFFSET	addition
	call	WriteString
	mov		eax,	valueB
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	AplusB
	call	WriteDec
	call	CrLf

	; prints A-B
	mov		eax,	valueA
	call	WriteDec
	mov		edx,	OFFSET	subtract
	call	WriteString
	mov		eax,	valueB
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	AminusB
	call	WriteDec
	call	CrLf

	; prints A+C
	mov		eax,	valueA
	call	WriteDec
	mov		edx,	OFFSET	addition
	call	WriteString
	mov		eax,	valueC
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	AplusC
	call	WriteDec
	call	CrLf

	; prints A-C
	mov		eax,	valueA
	call	WriteDec
	mov		edx,	OFFSET	subtract
	call	WriteString
	mov		eax,	valueC
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	AminusC
	call	WriteDec
	call	CrLf

	; prints B+C
	mov		eax,	valueB
	call	WriteDec
	mov		edx,	OFFSET	addition
	call	WriteString
	mov		eax,	valueC
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	BplusC
	call	WriteDec
	call	CrLf

	; prints B-C
	mov		eax,	valueB
	call	WriteDec
	mov		edx,	OFFSET	subtract
	call	WriteString
	mov		eax,	valueC
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	BminusC
	call	WriteDec
	call	CrLf

	; prints A+B+C
	mov		eax,	valueA
	call	WriteDec
	mov		edx,	OFFSET	addition
	call	WriteString
	mov		eax,	valueB
	call	WriteDec
	mov		edx,	OFFSET	addition
	call	WriteString
	mov		eax,	valueC
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	ABCtotal
	call	WriteDec
	call	CrLf

	; EC: prints B-A
	mov		eax,	valueB
	call	WriteDec
	mov		edx,	OFFSET	subtract
	call	WriteString
	mov		eax,	valueA
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	BminusA
	call	WriteInt
	call	CrLf
	
	; EC: prints C-A
	mov		eax,	valueC
	call	WriteDec
	mov		edx,	OFFSET	subtract
	call	WriteString
	mov		eax,	valueA
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	CminusA
	call	WriteInt
	call	CrLf

	; EC: prints C-B
	mov		eax,	valueC
	call	WriteDec
	mov		edx,	OFFSET	subtract
	call	WriteString
	mov		eax,	valueB
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	CminusB
	call	WriteInt
	call	CrLf

	; EC: prints C-B-A
	mov		eax,	valueC
	call	WriteDec
	mov		edx,	OFFSET	subtract
	call	WriteString
	mov		eax,	valueB
	call	WriteDec
	mov		edx,	OFFSET	subtract
	call	WriteString
	mov		eax,	valueA
	call	WriteDec
	mov		edx,	OFFSET	equals
	call	WriteString
	mov		eax,	ABCtotalEC
	call	WriteInt
	call	CrLf


; the following code prints the ending message to the user
_Goodbye:

	; prints final message
	call	CrLf
	mov		edx,	OFFSET		finish
	call	WriteString
	call	CrLf


	Invoke ExitProcess,0	; exit to operating system
main ENDP


END main
