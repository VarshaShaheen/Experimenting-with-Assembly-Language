section .data
    command1 db " Enter a number from 1-9 " ,10
    command1_len equ $-command1

    command2 db " Congratulations you won " ,10
    command2_len equ $-command2

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

    print_won:
        mov rax,1
        mov rdi,1
        mov rsi,command2
        mov rdx,command2_len
        syscall
        call exit


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
        mov r9,0
        draw:
        mov r8,'_'
        mov [array+r9],r8
        add r9,8
        cmp r9,64
        jle draw

        mov r8, 'X'
        mov [player], r8
        mov r8, 'O'
        mov [player+8], r8

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
        mov r10,[input]
        sub r8,'1'
        mov rax,r8
        mov r8,8
        mul r8

        push rax
        mov rax,r14
        mov r15,2
        div r15
        mov rax, rdx
        mov r15, 8
        mul r15

        mov r15, rax
        pop rax

        mov r8, [player+r15]
        mov [array+rax], r8

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

        check:
            mov rax,r14
            mov r8,2
            div r8
            cmp rdx,0
            je check_for_X

            jmp check_for_O

        check_for_X:
            mov r8,[array+0]
            cmp r8,'X'
            je first_pos_check_X

            mov r8,[array+32]
            cmp r8,'X'
            je second_pos_check_X

            mov r8,[array+64]
            cmp r8,'X'
            je third_pos_check_X

            jmp check_exit

        first_pos_check_X:
            mov r8,[array+8]
            cmp r8,'X'
            je X_win_1

            mov r8,[array+32]
            cmp r8,'X'
            je X_win_2

            mov r8,[array+24]
            cmp r8,'X'
            je X_win_3

            jmp check_exit

        second_pos_check_X:
            mov r8,[array+8]
            cmp r8,'X'
            je X_win_4

            mov r8,[array+24]
            cmp r8, 'X'
            je X_win_5

            mov r8,[array+16]
            cmp r8, 'X'
            je X_win_3

            jmp check_exit

        third_pos_check_X:
            mov r8,[array+40]
            cmp r8, 'X'
            je X_win_6

            mov r8,[array+56]
            cmp r8,'X'
            je X_win_7

            jmp check_exit

        X_win_1:
            mov r8,[array+16]
            cmp r8,'X'
            je print_won

            jmp check_exit

        X_win_2:
            mov r8,[array+64]
            cmp r8, 'X'
            je print_won

            jmp check_exit

        X_win_3:
            mov r8,[array+48]
            cmp r8, 'X'
            je print_won

            jmp check_exit

         X_win_4:
            mov r8,[array+56]
            cmp r8, 'X'
            je print_won

            jmp check_exit

         X_win_5:
            mov r8,[array+40]
            cmp r8,'X'
            je print_won

            jmp check_exit

         X_win_6:
            mov r8,[array+16]
            cmp r8, 'X'
            je print_won

            jmp check_exit

         X_win_7:
            mov r8,[array+48]
            cmp r8, 'X'
            je print_won

            jmp check_exit

         check_for_O:
            mov r8,[array+0]
            cmp r8,'O'
            je first_pos_check_O

            mov r8,[array+32]
            cmp r8,'O'
            je second_pos_check_O

            mov r8,[array+64]
            cmp r8,'O'
            je third_pos_check_O

            jmp check_exit

         first_pos_check_O:
             mov r8,[array+8]
             cmp r8,'O'
             je O_win_1

             mov r8,[array+32]
             cmp r8,'O'
             je O_win_2

             mov r8,[array+24]
             cmp r8,'O'
             je O_win_3

             jmp check_exit

         second_pos_check_O:
             mov r8,[array+8]
             cmp r8,'O'
             je O_win_4

             mov r8,[array+24]
             cmp r8, 'O'
             je O_win_5

             mov r8,[array+16]
             cmp r8, 'O'
             je O_win_3

             jmp check_exit

         third_pos_check_O:
             mov r8,[array+40]
             cmp r8, 'O'
             je O_win_6

             mov r8,[array+56]
             cmp r8,'O'
             je O_win_7

             jmp check_exit

          O_win_1:
             mov r8,[array+16]
             cmp r8,'O'
             je print_won

            jmp check_exit

          O_win_2:
             mov r8,[array+64]
             cmp r8, 'O'
             je print_won

             jmp check_exit

          O_win_3:
              mov r8,[array+48]
              cmp r8, 'O'
              je print_won

              jmp check_exit

          O_win_4:
               mov r8,[array+56]
               cmp r8, 'O'
               je print_won

               jmp check_exit

           O_win_5:
               mov r8,[array+40]
               cmp r8,'O'
               je print_won

               jmp check_exit

           O_win_6:
               mov r8,[array+16]
               cmp r8, 'O'
               je print_won

               jmp check_exit

            O_win_7:
               mov r8,[array+48]
               cmp r8, 'O'
               je print_won

               jmp check_exit

    _start:
       mov r14,0
       call draw_grid

        play_game:

            call print_command1
            call read_input


            print:
                call print_grid
                call check

            check_exit:
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
        player resq 2


