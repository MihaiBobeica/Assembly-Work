.data
BUFFER: .skip 2048

.global brainfuck
.text
input: .asciz "%c"
format_str: .asciz "We should be executing the following code:\n%s\n\n"

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
find_close:
	##prolog
	pushq %rbp
	movq %rsp, %rbp

	movq $1, %rdx ## number of open brackets

	loop_find:
	cmpq $0, %rdx ## the number of open brackets matches the one of closed brackets
	je match
	cmpb $'[', (%rdi)
	je plus
	cmpb $']', (%rdi)
	je minus
	addq $1, %rdi
	jmp loop_find

	plus:
	addq $1, %rdi ## we go to the next command
	addq $1, %rdx ## we increase the number of open brackets
	jmp loop_find

	minus:
	addq $1, %rdi ## we go to the next command
	subq $1, %rdx ## we decrese the number of open brackets
	jmp loop_find

	match:
	movq %rdi, %rax
	movq %rbp, %rsp
	popq %rbp
	ret

brainfuck:
	pushq %rbp
	movq %rsp, %rbp

	//movq %rdi, %rsi
	//movq $format_str, %rdi
	//call printf
	//movq $0, %rax
	## %rdi points to the current command from the code string
	## %rbx points to the current block from the buffer(i.e. the place in memory where we create our output)
	movq $BUFFER, %rbx
	loop:
	cmpb $0, (%rdi) ##the end of the string
	je end_loop
	cmpb $'[', (%rdi)
	je open_loop
	cmpb $'>', (%rdi)
	je move_right
	cmpb $'<', (%rdi)
	je move_left
	cmpb $',', (%rdi)
	je scan
	cmpb $'.', (%rdi)
	je print
	cmpb $'+', (%rdi)
	je incr
	cmpb $'-', (%rdi)
	je decr
	cmpb $']', (%rdi)
	je close_loop

	addq $1, %rdi
	jmp loop

	move_right:
	addq $1, %rdi ## we go to the next command in the code
	addq $1, %rbx ## we move the pointer to the next block in the buffer
	jmp loop

	move_left:
	addq $1, %rdi ## we go to the next command in the code
	subq $1, %rbx ## we move the pointer to the previous block in the buffer
	jmp loop

	scan:
	addq $1, %rdi
	pushq %rsi
	pushq %rdi
	movq %rbx, %rsi  ##we give the memory address where we want to put the element we read
	movq $input, %rdi  ##we specify that it's a character
	call scanf
	popq %rdi
	popq %rsi
	jmp loop

	print:
	addq $1, %rdi
	pushq %rdi
	pushq %rsi
	movq $input, %rdi
	movq (%rbx), %rsi
	call printf
	popq %rsi
	popq %rdi
	jmp loop

	incr:
	addq $1, %rdi ## jump to the next command
	addb $1, (%rbx) ## increment the current block from the buffer
	jmp loop

	decr:
	addq $1, %rdi ## jump to the next command
	subb $1, (%rbx) ## decrement the current block from the buffer
	jmp loop

	open_loop:
	pushq %rdi ## we remember the position of the start of the loop
	pushq %rdi
	cmpb $0, (%rbx) 
	jne cont
	addq $1, %rdi
	movq $0, %rax
	call find_close
	movq %rax, %rdi
	popq %rcx
	popq %rcx
	jmp loop
	cont:
	addq $1, %rdi
	jmp loop


	close_loop:
	popq %rdi
	popq %rdi
	jmp loop


	jmp loop
	end_loop:
	movq %rbp, %rsp
	popq %rbp
	ret
