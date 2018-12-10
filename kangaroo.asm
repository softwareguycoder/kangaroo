; Executable name : KANGAROO
; Version	  : 1.0
; Created date	  : 10 Dec 2018
; Last update	  : 10 Dec 2018
; Author     	  : Brian Hart
; Description	  : A simple assembly app for Linux, using NASM,
;		    demonstrating the use of Linux INT 80H syscalls
; 		    to display text AND the use of JMP, INC, and DEC
;		    to convert an ASCII string from UPPERCASE to 
;	            lowercase.  This should print 'kangaroo' on the screen.
;		    NOTE: This program makes an assumption that all the chars
;	            in the input string are UPPERCASE to begin with; this may not
;		    be a correct assumption, in general.
;
; Build using these commands:
;	nasm -f elf64 -g -F stabs kangaroo.asm
;	ld -o kangaroo kangaroo.o
;

SECTION .data			; Section containing initialized data

Snippet:	db 	"KANGAROO"
SnippetLen:	equ	$-Snippet

CrLf:		db	13,10
CrLfLen:	equ	$-CrLf

SECTION .bss			; Section containing uninitialized data

SECTION .text			; Section containing code


global	_start			; Linker needs this to find the entry point!

_start:
	nop			; This no-op keep gdb happy

	mov ebx,Snippet		; Put the address of the first char of the Snippet string in EBX
	mov eax,SnippetLen	; Length of the Snippet in EAX

DoMore:	
	add BYTE [ebx],32	; Convert ASCII uppercase to lowercase by adding 32 (decimal)
	inc ebx			; move the character pointer in EBX to the next char
	dec eax			; decrement EAX by one value
	jnz DoMore		; Jump back to the beginning of the loop so long as Zero Flag was not set

	mov eax,4		; Specify sys_write syscall
	mov ebx,1		; Specify File Descriptor 1: Standard Output
	mov ecx,Snippet		; Pass offset of the message
	mov edx,SnippetLen	; Pass the length of the message
	int 80H			; Make syscall to output text to stdout

	mov eax,4		; Specify sys_write syscall
	mov ebx,1		; Specify File Descriptor 1: Standard Output
	mov ecx,CrLf		; Pass offset of the CR-LF message
	mov edx,CrLfLen		; Pass the length of the CR-LF message
	int 80H			; Make syscall to output text to stdout

	mov eax,1		; Specify Exit syscall
	mov ebx,0		; Return a code of zero
	int 80H			; Make syscall to terminate the program
