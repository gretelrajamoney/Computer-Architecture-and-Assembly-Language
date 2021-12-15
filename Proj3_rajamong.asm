TITLE Proj3_rajamong    (Proj3_rajamong.asm)

; Author: Gretel Rajamoney
; Last Modified: 10/30/2020
; OSU email address: rajamong@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 3        Due Date: 11/1/2020
; Description: This program will first display the title as well as my name to
;			   the user. Next is will as the user for their name and greet them
;			   using their name. Next, the program will repeatedly ask the user 
;			   to input numbers. Prior to prompting the user for numbers, the 
;			   program will display the range in which the numbers must be in. 
;			   If the user inputs a number that is outside of the range, an error
;			   message will be displayed to the user. The program will continue 
;			   to count and accumulate all valid inputted numbers until a non-
;			   negative number is entered (detected using the sign flag). Then,
;			   the program will calculate the rounded average and store it into 
;			   a variable. Next, the program will display the sum of all valid
;			   numbers, the minimum and maximum values, the rounded average, and
;			   lastly a goodbye message before terminating.


INCLUDE Irvine32.inc

FIRSTLOWERLIMIT		=	  -200
FIRSTUPPERLIMIT		=	  -100
SECONDLOWERLIMIT	=	  -50
SECONDUPPERLIMIT	=	  -1

.data

header		BYTE		"INTEGER ACCUMULATOR     BY: GRETEL RAJAMONEY !!",0
getName		BYTE		"hello, what is your name?? ",0
greet		BYTE		"nice to meet you, ",0
nameSpot	BYTE		21 DUP(0)
userName	DWORD		?
rulespt1	BYTE		"please input numbers within the range [-200,-100] or [-50,-1]",0
rulespt2	BYTE		"enter a positive number when you want to see the results !!",0
getNums		BYTE		"please enter a number: ",0
num			SDWORD 		?
invalid		BYTE		"the number you entered is invalid :(",0
total   	BYTE		"the total number of valid numbers you entered is: ",0
totNum		DWORD		0
maximum		BYTE		"the maximum valid number you entered is: ",0
maxNum		SDWORD 		-201
minimum		BYTE		"the minimum valid number you entered is: ",0
minNum		SDWORD 		0
addition	BYTE		"the sum of all your valid numbers is: ",0
sumNum		SDWORD 		0
average		BYTE		"the rounded average of all your valid numbers is: ",0
aveNum		SDWORD 		0
specialcase BYTE		"none of the numbers you inputted were valid :(",0
thankyou	BYTE		"thank you for participating !!",0
goodbye		BYTE		"see you later, ",0


.code
main PROC

; the following section of code prints out the program header to the user
; then it prompts the user for their name and stores it, and then greets
; the user by their name, and next prints out the rules to the user
INTRODUCTION:
	mov		edx,	OFFSET		header
	call	WriteString
	call	CrLf
	mov		edx,	OFFSET		getName
	call	WriteString
	mov		edx,	OFFSET		userName
	call	WriteString
	mov		ecx,	30
	mov		edx,	OFFSET		nameSpot
	call	ReadString
	mov		edx,	OFFSET		greet
	call	WriteString
	mov		edx,	OFFSET		nameSpot
	call	WriteString
	call	CrLf
	mov		edx,	OFFSET		rulespt1
	call	WriteString
	call	CrLf
	mov		edx,	OFFSET		rulespt2
	call	WriteString
	call	CrLf

; the following section of code prompts the user to enter a number
; and then stores the number, the program jumps to CHECKIFVALID if the 
; sign flag is not zero, if the sign flag indicates that the number
; is positive, then the program jumps to the PRINTNUMBERS section
ENTERNUMBERS:
	mov		edx,	OFFSET		getNums
	call	WriteString
	call	ReadInt
	mov		num,	eax
	JNS		PRINTNUMBERS
	JMP		CHECKIFVALID

; the following section of code checks if the number that the user
; inputted is valid using the cmp function, if the number is within 
; the allotted ranges then the program jumps to the VALIDNUMBER 
; section, if the number is not within the allotted ranges then the 
; program jumps to the INVALIDNUMBER section 
CHECKIFVALID:
	cmp		num,	FIRSTLOWERLIMIT
	jl		INVALIDNUMBER
	cmp		num,	FIRSTUPPERLIMIT
	jle		VALIDNUMBER
	cmp		num,	SECONDLOWERLIMIT
	jge		VALIDNUMBER
	jmp		INVALIDNUMBER

; if the program jumps to this section, that means that the number that
; the user entered is not within the allotted ranges, this section will
; print out an error message to the user and then reprompt them to add
; more numbers by jumping back to the ENTERNUMBERS section
INVALIDNUMBER:
	mov		edx,	OFFSET		invalid
	call	WriteString
	call	CrLf
	jmp		ENTERNUMBERS

; if the program jumps to this section, that means that the number that
; the user entered is valid, the following section of code increases the
; total count of valid numbers variable by one, and then adds itself to 
; the total sum of all valid numbers variable, after it automatically
; jumps to the FINDMAX section 
VALIDNUMBER:
	mov		eax,		totNum
	inc		eax
	mov		totNum,		eax
	mov		eax,		num
	mov		ebx,		sumNum
	add		eax,		ebx
	mov		sumNum,		eax
	jmp		FINDMAX

; the following section of the program compares the user inputted number
; with the number stored in the maximum number variable, if the number is
; greater than the original maximum value, then it jumps to the CHANGEMAX
; section, if it is not greater, then it jumps to the FINDMIN section
FINDMAX:
	mov		eax,	num
	mov		ebx,	maxNum
	cmp		eax,	ebx
	jg		CHANGEMAX
	jmp		FINDMIN

; the following section of the program changes the original value stored 
; in the maximum number variable with the new user inputted number, after
; it changes the value, it automatically jumps to the FINDMIN section
CHANGEMAX:
	mov		eax,	maxNum
	mov		ebx,	num
	mov		eax,	ebx
	mov		maxNum,	eax
	jmp		FINDMIN

; the following section of the program compares the user inputted number
; with the number stored in the minimum number variable, if the number is
; smaller than the original maximum value, then it jumps to the CHANGEMIN
; section, if it is not greater, then it jumps to the ENTERNUMBERS section
FINDMIN:
	mov		eax,	num
	mov		ebx,	minNum
	cmp		eax,	ebx
	jl		CHANGEMIN
	jmp		ENTERNUMBERS

; the following section of the program changes the original value stored 
; in the minimum number variable with the new user inputted number, after
; it changes the value, it automatically jumps to the ENTERNUMBERS section
CHANGEMIN:
	mov		eax,	minNum
	mov		ebx,	num
	mov		eax,	ebx
	mov		minNum,	eax
	jmp		ENTERNUMBERS

; the following section of the program prints out the total count of valid
; numbers inputted by the user, the sum of all the valid numbers, the minimum
; valid number entered, the maximum valid number entered, and then calculates
; as well as prints the rounded average of all the number, after printing all
; of this, the program automatically jumps to the conclusion, if no valid 
; numbers were entered by the user, then the program automatically jumps to 
; a special error message as requested in the rubric on canvas
PRINTNUMBERS:
;prints total count of valid entered numbers and jumps if none
	mov		eax,	totNum
	mov		ebx,	0
	cmp		eax,	ebx
	je		SPECIALENDING
	mov		edx,	OFFSET		total
	call	WriteString
	mov		eax,	totNum
	call	WriteDec
	call	CrLf
;prints the maximum entered valid number
	mov		edx,	OFFSET		maximum
	call	WriteString
	mov		eax,	maxNum
	call	WriteInt
	call	CrLf
;prints the minimum entered valid number
	mov		edx,	OFFSET		minimum
	call	WriteString
	mov		eax,	minNum
	call	WriteInt
	call	CrLf
;prints the added sum of all valid numbers
	mov		edx,	OFFSET		addition
	call	WriteString
	mov		eax,	sumNum
	call	WriteInt
	call	CrLf
;prints and calculates the rounded average
	mov		edx,	OFFSET		average
	call	WriteString
	mov		eax,		sumNum
	cdq
	mov		ebx,		totNum
	idiv	ebx
	mov		aveNum,		eax
	mov		eax,		aveNum
	call	WriteInt
	call	CrLf
;jumps to ending
	jmp		CONCLUSION

; if the program jumps to this section, it is because the user 
; entered no valid numbers, the following prints a special error
; message to the user and then jumps to the CONCLUSION after
SPECIALENDING:
	mov		edx,	OFFSET		specialcase
	call	WriteString
	call	CrLf
	jmp		CONCLUSION

; the following section of code prints out a goodbye to the user
; while also properly bidding farewell with their name
CONCLUSION:
	mov		edx,	OFFSET		thankyou
	call	WriteString
	call	CrLf
	mov		edx,	OFFSET		goodbye
	call	WriteString
	mov		edx,	OFFSET		nameSpot
	call	WriteString
	call	CrLf


	Invoke ExitProcess,0	; exit to operating system
main ENDP


END main
