.text
valid: .asciz "valid"
invalid: .asciz "invalid"
.include "basic.s"

.global main

# *******************************************************************************************
# Subroutine: check_validity                                                                *
# Description: checks the validity of a string of parentheses as defined in Assignment 6.   *
# Parameters:                                                                               *
#   first: the string that should be check_validity                                         *
#   return: the result of the check, either "valid" or "invalid"                            *
# *******************************************************************************************
check_validity:
#prolog
pushq %rbp
movq %rsp, %rbp

loop:
movq $0, %rsi
movb (%rdi), %sil ##we move the current byte(the byte towards which %rdi is pointing) into %rsi(1byte=1 character)
cmpb $0, %sil
je end_loop
addq $1, %rdi     ##we move to the next byte/character
cmpq %rsp, %rbp   ##check if the "stack" is empty
je empty_stack

jmp not_empty    

empty_stack:     ##if the current character is a closed bracket and the stack is empty then the case is invalid
cmpb $')', %sil
je not_good
cmpb $']', %sil
je not_good
cmpb $'}', %sil
je not_good
cmpb $'>', %sil
je not_good

pushq %rsi      ##otherwise the case is valid
pushq %rsi

jmp loop

not_empty:      ##if the current character is an open bracket, we can safly add it onto the stack
cmpb $'(', %sil
je add_stack
cmpb $'[', %sil
je add_stack
cmpb $'{', %sil
je add_stack
cmpb $'<', %sil
je add_stack
                ##if it's not an open bracket, we need to check the last bracken on the stack(the top of the stack)
cmpb $'(', (%rsp)
je first_case
cmpb $'[', (%rsp)
je second_case
cmpb $'{', (%rsp)
je third_case
cmpb $'<', (%rsp)
je forth_case
jne not_good

first_case:  ##the character on top of the stack is '('
cmpb $')', %sil
jne not_good
popq %rsi   ##int means that this set of parantheses is closed
popq %rsi
jmp loop

second_case: ##the character on top of the stack is '['
cmpb $']', %sil
jne not_good
popq %rsi
popq %rsi
jmp loop

third_case:  ##the character on top of the stack is '{'
cmpb $'}', %sil
jne not_good
popq %rsi
popq %rsi
jmp loop

forth_case: ##the character on top of the stack is '<'
cmpb $'>', %sil
jne not_good
popq %rsi
popq %rsi
jmp loop

add_stack:
pushq %rsi
pushq %rsi
jmp loop

not_good:
movq $0, %rax
jmp epilog

end_loop:
cmpq %rsp, %rbp
jne not_good
movq $1, %rax

epilog:
cmpq $0, %rax
je inva
movq $valid, %rax
jmp ending
inva:
movq $invalid, %rax
ending:
#epilog
movq %rbp, %rsp
popq %rbp
ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi		# first parameter: address of the message
	call	check_validity		# call check_validity
	movq 	%rax, %rdi
	call 	printf
	#epilog
	movq 	%rbp, %rsp
	popq 	%rbp
	call 	exit

