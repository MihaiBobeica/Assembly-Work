.text
form_string: .string "Can you handle 32 args?? --> %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d"
name: .string "hi there"
.global main
print_string:     ##for %s
#prolog
pushq %rbp
movq %rsp, %rbp

movq %rdi, %rsi   ##moving the string into %rsi
movq $1, %rdi     ##where we want the output
movq $1, %rdx     ##how many bytes we want to print
movq $1, %rax     ##the code for writing the output

print_string_loop:
movb (%rsi), %cl  ##move the current character to %rcx
cmpb $0, %cl      ##check if we are at the end of the string
je end_string_loop
syscall       
addq $1, %rsi     ##go to the address of the next character
jmp print_string_loop
end_string_loop:

#epilog 
movq %rbp, %rsp
popq %rbp
ret 

print_unsigned:    ##for %u

pushq %r12
pushq %r12
pushq %r13
pushq %r13
#prolog
pushq %rbp
movq %rsp, %rbp

movq %rdi, %r12   ##move the number in %r12
cif_loop:         ##we break down the number into digits and store them onto the stack as characteres
movq $0, %rdx
movq $0, %rax
cmpq $0, %r12     ##if the number is 0(there are no more digits) we exit the loop
je end_cif_loop
movq %r12, %rax   ##we store the number in %rax to divide it by 10; the quotion will be in %rax and the remainder in %rdx
movq $10, %r13
divq %r13         ##we find the remainder
movq %rdx, %r12   ##we move it in %r12
addq $'0', %r12   ##we find the ascii value of that digit
pushq %r12        ##we push it onto the stack
pushq %r12
movq %rax, %r12   ##we move the new number into r12
jmp cif_loop
end_cif_loop:
print_unsigned_loop:
cmpq %rsp, %rbp
je end_usigned_loop
movq %rsp, %rsi   ##moving the address from the top of the stack into %rsi
movq $1, %rdi     ##where we want the output
movq $1, %rdx     ##how many bytes we want to print
movq $1, %rax     ##the code for writing the output
syscall
popq %r12
popq %r12
jmp print_unsigned_loop
end_usigned_loop:
 
#epilog 
movq %rbp, %rsp
popq %rbp
popq %r13
popq %r13
popq %r12
popq %r12
ret 

print_signed:    ##for %d

pushq %r12
pushq %r12
pushq %r13
pushq %r13
pushq %r14
pushq %r14
#prolog
pushq %rbp
movq %rsp, %rbp
movq %rdi, %r14 
cmpq $0, %rdi   ##we check to see if the number is positive or negative
jg cnt

subq $1, %rdi   ##the numbers are stored in memory in 2's complement; that is 1'sC+1
##we do nor(%rdi, 0) to find the absolute value of the number
or $0, %rdi     
not %rdi
cnt:
movq %rdi, %r12   ##move the number in %r12
cifs_loop:
movq $0, %rdx
movq $0, %rax
cmpq $0, %r12
je end_cifs_loop
movq %r12, %rax
movq $10, %r13
divq %r13      ##we find the remainder
movq %rdx, %r12  ##we move it in %r12
addq $'0', %r12    ##we find the ascii value of that digit
pushq %r12         ##we push it onto the stack
pushq %r12
movq %rax, %r12    ##we move the new number into r12
jmp cifs_loop
end_cifs_loop:
cmpq $0, %r14
jg print_signed_loop

movq $'-', %r12   ##we add a minus character in the stack
pushq %r12
pushq %r12
print_signed_loop:
cmpq %rsp, %rbp
je end_signed_loop
movq %rsp, %rsi   ##moving the address from the top of the stack into %rsi
movq $1, %rdi     ##where we want the output
movq $1, %rdx     ##how many bytes we want to print
movq $1, %rax     ##the code for writing the output
syscall
popq %r12
popq %r12
jmp print_signed_loop
end_signed_loop:

ending:
#epilog 
movq %rbp, %rsp
popq %rbp
popq %r14
popq %r14
popq %r13
popq %r13
popq %r12
popq %r12
ret 


my_printf:
#we push all the arguments onto the stack. We push them in reverse order to match the extra parameters(if there are any). 
pushq %r9
pushq %r9
pushq %r8
pushq %rcx
pushq %rdx
pushq %rsi
#prolog
pushq %rbp
movq %rsp, %rbp
pushq %rbx
pushq %rbx
movq %rbp, %rbx   ##we use %rbx to get to our arguments
addq $8, %rbx

movq %rdi, %rsi   ##moving the prompt into %rsi
movq $1, %rdi     ##where we want the output
movq $1, %rdx     ##how many bytes we want to print
movq $1, %rax     ##the code for writing the output

print_loop:
##check if we have more than 6 arguments
pushq %rbx
pushq %rbx
subq %rbp, %rbx
cmpq $48, %rbx 
jne no
popq %rbx
popq %rbx
addq $16, %rbx   ##we jump over the return address
jmp yes
no:
popq %rbx
popq %rbx
yes:
movq $0, %rcx
movzbq (%rsi), %rcx  ##move the current character to %rcx
cmpb $0, %cl      ##check if we are at the end of the string
je endloop
cmpb $'%', %cl    ##we check to see if we need to print anything specific
jne cont
addq $1, %rsi     ##we check what we have to print
movzbq (%rsi), %rcx
cmpb $'%', %cl    ##if we have to print %, we just print it
je cont
cmpb $'d', %cl    ##the case for a signed integer
je signed_case
cmpb $'u', %cl    ##the case for unsigned numbers
je unsigned_case    
cmpb $'s', %cl    ##string case
je string_case

jmp not_parameter

unsigned_case:
##we push the registers onto the stack to remember them after the sub call
pushq %rdi
pushq %rsi
pushq %rcx
pushq %rdx
pushq %rax
pushq %rax
movq $0, %rdi
movq (%rbx), %rdi ##we move the number into %rdi to be passed as an argument for the sub
call print_unsigned
##we restore the registers
popq %rax
popq %rax
popq %rdx
popq %rcx
popq %rsi
popq %rdi
addq $8, %rbx
jmp after_cont

signed_case:
##we push the registers onto the stack to remember them after the sub call
pushq %rdi
pushq %rsi
pushq %rcx
pushq %rdx
pushq %rax
pushq %rax
movq $0, %rdi
movq (%rbx), %rdi ##we move the number into %rdi to be passed as an argument for the sub
call print_signed
##we restore the registers
popq %rax
popq %rax
popq %rdx
popq %rcx
popq %rsi
popq %rdi
addq $8, %rbx
jmp after_cont

string_case:
##we push the registers onto the stack to remember them after the sub call
pushq %rdi
pushq %rsi
pushq %rcx
pushq %rdx
pushq %rax
pushq %rax
movq (%rbx), %rdi ##we move the address of the first element from the string in %rdi
call print_string
##we restore the registers
popq %rax
popq %rax
popq %rdx
popq %rcx
popq %rsi
popq %rdi
addq $8, %rbx
jmp after_cont

not_parameter:
subq $1, %rsi  ##in case we get things like %r or %t
cont:   ##in case of a normal character from the prompt, we just print it
pushq %rdi
pushq %rsi
pushq %rcx 
pushq %rax
syscall
popq %rax
popq %rcx
popq %rsi
popq %rdi
after_cont:      
addq $1, %rsi     ##jump to the address of the next character
jmp print_loop
endloop:

#epilog 
popq %rbx
popq %rbx
movq %rbp, %rsp
popq %rbp
popq %rsi
popq %rdx
popq %rcx
popq %r8
popq %r9
popq %r9
ret 

main:
#prolog
//subq $8, %rsp
pushq %rbp
movq %rsp, %rbp
movq $form_string, %rdi
/*movq $1337, %rsi
movq $1337, %rdx
movq $1337, %rcx
movq $1337, %r8
movq $1337, %r9
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337
pushq $1337*/
call my_printf
#epilog
movq %rbp, %rsp
popq %rbp
//addq $8, %rsp

movq $60, %rax #system call 1 is syswrite
movq $0, %rdi #first argument is where to write ; stdoutis 1
syscall