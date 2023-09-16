#rbp = base pointer of the stack
#rsp = current pointer of the stack / bottom of the stack
#the stack direction is from up to bottom

# bottom            <-rbp
# stack content
# top               <-rsp


#priorities of register:
# 1 - rdi
# 2 - rsi
# 3 - rdx
# 4 - rcx
# 5 - r8
# 6 - r9

#rax is used for return values

.text #Declaratory side of input/output
input: .asciz "%ld"     # asciz is a string with final character 0 read as a integer (long decimal)
output: .asciz "%ld\n"    #same as above, but for output

.global main #declare main, it behaves as .text but for main function
main:

    pushq %rbp       #pushing the base pointer
                     #q is used for 16bytes alignation
    movq %rsp, %rbp  #moves the value of rsp in rbp
                     #we use this to not override other values of the stack
    movq $0, %rax    #the $sign is used for numbers, while % sign is used for register content


    subq $16, %rsp      #creating place in the 16-bytes alligned stack
    movq $input, %rdi   #registerd can remember data or instructions
                        #we tell the rdi that its going to receive the input, specifically a long decimal
    leaq -16(%rbp), %rsi#leaq transfers the adress from the memory into rsi
    #in rdi we memorize the data type which we are going to store and in rsi where to store it
    call scanf          #reading the proper input into rdi

    subq $16, %rsp
    movq $input, %rdi
    leaq -32(%rbp), %rsi
    call scanf

    movq -16(%rbp), %rdi
    movq -32(%rbp), %rsi

    addq %rdi, %rsi     # is equivlane tot rsi <- rsi + rdi

    movq $output, %rdi
    call printf         #prints the content of rdi

end:
    movq %rbp, %rsp
    popq %rbp           #ends program


