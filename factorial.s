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
subq $16, %rsp ##making space for the input
movq $input, %rdi ##specifying the type of input
leaq -16(%rsp), %rsi ##specifying the location where we want the input
call scanf
movq -16(%rsp), %rdi ##the parameter of the function
call factorial
movq $output, %rdi ##the type of output
movq %rax, %rsi    ##the output
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

factorial:
#prologue
pushq %rbp  ##pushing the base pointer
movq %rsp, %rbp  ##copying the value from rsp into rbp
movq %rdi, %rax
##movq %rax, %r12
##movq $output, %rdi
##movq %rax, %rsi
##movq $0, %rax
##call printf
##movq %r12, %rax
cmpq $0, %rax  ##checking the basecase
je basecase
subq $8, %rsp
pushq %rax  ##storing the upcoming number in the product
decq %rdi   ##decreasing the number

call factorial  ##recursive call
popq %rdi   ##poping the value from the stack
addq $8, %rsp
mulq %rdi
jmp afterbasecase

basecase:
movq $1, %rax ##0!=1
afterbasecase:
##epilogue
movq %rbp, %rsp
popq %rbp

ret