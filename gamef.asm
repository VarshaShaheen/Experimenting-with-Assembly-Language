section .data
    command1 db " Enter a number from 1-9 " ,10
    command1_len equ $-command1

    command2 db " Congratulations you won " ,10
    command2_len equ $-command2

    next_line db 10

section .text
    global _start
