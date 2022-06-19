section .data
    command1 db " Enter a number from 1-9 " ,10
    command1_len equ $-command1

    next_line db 10

section .text
  global _start

       push_x:
        pop r15

        push rax
        push rdx
        push rcx
        push rdi
        push rsi
        push r14

        push r15
        ret

    pop_x:
        pop r15

        pop r14
        pop rsi
        pop rdi
        pop rcx
        pop rdx
        pop rax

        push r15
        ret

    print_command1:
        mov rax,1
        mov rdi,1
        mov rsi,command1
        mov rdx,command1_len
        syscall
        ret

    add_O:
        mov r8,'X'
        mov [array+rax],r8
        jmp print


     print_enter:
        call push_x
        mov rax,1
        mov rdi,1
        mov rsi,next_line
        mov rdx,1
        syscall
        call pop_x
        jmp loop_exit

    draw_grid:
        mov r8,'_'
        mov [array+r9],r8
        add r9,8
        cmp r9,64
        jle draw_grid
        ret

    read_input:

        mov rax,0
        mov rdi,0
        mov rsi,input
        mov rdx,1
        syscall

        mov rax,0
        mov rdi,0
        mov rsi,delim
        mov rdx,1
        syscall

        mov r8,[input]
        sub r8,'1'
        mov rax,r8
        mov r8,8
        mul r8

        push rax
        mov rax,r14
        mov r15,2
        div r15
        pop rax
        cmp rdx,0
        je add_O


        mov r8,'O'
        mov [array+rax],r8
        ret

    print_grid:
        mov r8,array
        mov r9,0

        print_grid_loop:
            mov rax,1
            mov rdi,1
            mov rsi,r8
            mov rdx,1
            syscall


            mov rax,r9
            mov r13,3
            div r13
            cmp rdx,0
            je print_enter

        loop_exit:
            add r8,8
            add r9,1
            cmp r9,8
            jle print_grid_loop
            ret



    _start:
       mov r14,0
       call draw_grid

        play_game:
            call print_command1
            call read_input

            print:
            call print_grid

            add r14,1
            cmp r14,8

            jle play_game

    call exit


    exit:
        mov rax,60
        mov rdx,0
        syscall


    section .bss
        array resq 9
        input resq 1
        delim resq 1

