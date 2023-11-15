.global sha1_chunk

sha1_chunk:
    pushq %rbx
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    #prolog
    pushq %rbp
    movq %rsp, %rbp
    
    ## setting h0 - h4
    movq $0, %rcx
    movl (%rdi), %ecx
    pushq %rcx
    pushq %rcx
     movq $0, %rcx
    movl 4(%rdi), %ecx
    pushq %rcx
    pushq %rcx
     movq $0, %rcx
    movl 8(%rdi), %ecx
    pushq %rcx
    pushq %rcx
     movq $0, %rcx
    movl 12(%rdi), %ecx
    pushq %rcx
    pushq %rcx
     movq $0, %rcx
    movl 16(%rdi), %ecx
    pushq %rcx
    pushq %rcx
    pushq %rsi ## we remember the address of the first element in w[]
    pushq %rsi
    movq %rdi, %r8 ## h0 - h4 is in %r8
    addq $64, %rsi
    movq $16, %rax ## we use %rax to go through the array
    loop:
    cmpq $79, %rax ## 316=79*4
    jg endloop
    movl -12(%rsi), %ecx ## w[i-3] 
    movl -32(%rsi), %edx ## w[i-8]
    xorl %edx, %ecx       ## w[i-3] ^ w[i-8] in %rcx
    movq $0, %rdx
    movl -56(%rsi), %edx ## w[i-14]
    xorl %edx, %ecx       ## w[i-3] ^ w[i-8] ^ w[i-14] in %rcx
    movq $0, %rdx
    movl -64(%rsi), %edx ## w[i-16]
    xorl %edx, %ecx       ## w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16] in %rcx
    roll $1, %ecx
    movl %ecx, (%rsi)    
    addq $4, %rsi
    addq $1, %rax
    jmp loop

    endloop:
    popq %rsi
    popq %rsi
    movq $0, %rax

    ## a = -16(%rbp)
    ## b = -32(%rbp)
    ## c = -48(%rbp)
    ## d = -64(%rbp)
    ## e = -80(%rbp)

    main_loop:
    cmpq $79, %rax
    jg end_main_loop
    cmpq $19, %rax
    jle first_part
    cmpq $39, %rax
    jle second_part
    cmpq $59, %rax
    jle third_part
    cmpq $79, %rax
    jle forth_part

    first_part:
    movl -32(%rbp), %r12d ## b
    movl -48(%rbp), %r13d ## c
    andl %r12d, %r13d      ## b & c
    notl %r12d            ## not b
    movl -64(%rbp), %r14d ## d
    andl %r12d, %r14d      ## not b & d
    orl %r13d, %r14d       ## (b and c) or ((not b) and d)
    ## result in %r14d 
    movl $0x5A827999, %r15d ## k
    jmp cont

    second_part:
    movl -32(%rbp), %r12d   ## b
    movl -48(%rbp), %r13d   ## c
    movl -64(%rbp), %r14d   ## d
    xorl %r12d, %r13d      ## b ^ c
    xorl %r13d, %r14d      ## b ^ c ^ d
    ##result in %r14d
    movl $0x6ED9EBA1, %r15d ## k
    jmp cont

    third_part:
    movl -32(%rbp), %r12d   ## b
    movl -48(%rbp), %r13d   ## c
    movl -64(%rbp), %r14d   ## d
    movl %r13d, %ebx
    andl %r12d, %r13d      ## b & c
    andl %r14d, %r12d      ## d & b
    andl %ebx, %r14d       ## c & d
    orl %r12d, %r13d       ## (b & c) | (b & d)
    orl %r13d, %r14d       ## (b & c) | (b & d) | (c & d)
    ##result in %r14d
    movl $0x8F1BBCDC, %r15d ## k
    jmp cont

    forth_part:
    movl -32(%rbp), %r12d   ## b
    movl -48(%rbp), %r13d   ## c
    movl -64(%rbp), %r14d   ## d
    xorl %r12d, %r13d      ## b ^ c
    xorl %r13d, %r14d      ## b ^ c ^ d
    ##result in %r14d
    movl $0xCA62C1D6, %r15d ## k
    cont:
    movq $0, %rdi
    movl -16(%rbp), %edi ## a
    roll $5, %edi           ## a leftrotate 5
    addl %r14d, %edi    ## (a leftrotate 5) + f
    addl -80(%rbp), %edi ## (a leftrotate 5) + f + e
    addl %r15d, %edi    ## (a leftrotate 5) + f + e + k
    addl (%rsi), %edi   ## (a leftrotate 5) + f + e + k + w[i]
    movl -64(%rbp), %ecx
    movl %ecx, -80(%rbp) ## e = d
    movl -48(%rbp), %ecx
    movl %ecx, -64(%rbp) ## d = c
    movl -32(%rbp), %ecx
    roll $30, %ecx
    movl %ecx, -48(%rbp) ## c = b
    movl -16(%rbp), %ecx
    movl %ecx, -32(%rbp) ## b = a
    movl %edi, -16(%rbp)     ## a = temp
    addq $1, %rax
    addq $4, %rsi
    jmp main_loop
    end_main_loop:
    movq %r8, %rdi
    movq $0, %rcx
    movl -16(%rbp), %ecx
    addl %ecx, (%rdi)
    movl -32(%rbp), %ecx
    addl %ecx, 4(%rdi)
    movl -48(%rbp), %ecx
    addl %ecx, 8(%rdi)
    movl -64(%rbp), %ecx
    addl %ecx, 12(%rdi)
    movl -80(%rbp), %ecx
    addl %ecx, 16(%rdi)
    movq %rdi, %rax

    popq %rcx
    popq %rcx
    popq %rcx
    popq %rcx
    popq %rcx
    popq %rcx
    popq %rcx
    popq %rcx
    popq %rcx
    popq %rcx
    #epilog
    movq %rbp, %rsp
    popq %rbp
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    popq %rbx
    ret