.text
prompt: .asciz "Please enter 2 positive numbers "
input: .asciz "%ld"
output: .asciz "%ld\n"

.global main
main:
##prologue
pushq %rbp      ##push the base pointer
movq %rsp, %rbp ##copy the value from rsp into rbp

movq $0, %rax 
movq $prompt, %rdi
call printf
subq $16, %rsp ##make room for the first input
movq $input, %rdi ##kind of input
leaq -16(%rbp), %rsi ##copy the adress where you want the input
call scanf

subq $16, %rsp ##make room for the second input
movq $input, %rdi ##type of input
leaq -32(%rbp), %rsi ##copy the adress
call scanf

movq -16(%rbp), %rdi ##first parameter
movq -32(%rbp), %rsi ##second parameter
call pow
movq $output, %rdi  ##type of output
movq %rax, %rsi
call printf
##epilogue
movq %rbp, %rsp
popq %rbp
end:

call exit

pow:
##prologue
pushq %rbp  ##push the base pointer
movq %rsp, %rbp ##give the base pointer the value of the current pointer

movq %rdi, %rax      ##copying the base into rax    
movq $1, %rdx        ##remembering the number of steps
cmpq $0, %rsi        ##check if the exponent is 0
je ifcode            ##execute if the exponent is 0

loop:

cmpq %rsi, %rdx  ##comparing the base to the number of step
je endloop          ##exiting the loop
imulq %rdi, %rax     ##multiplying
addq $1, %rdx       ##incrememnting the steps
jmp loop            ##repeting the loop

ifcode:
movq $1, %rax
endloop:
##epilogue
movq %rbp, %rsp
popq %rbp

ret

