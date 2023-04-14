;Reading a maximum of 8 bit number as input

section .data
msg db "Enter an integer: ",10
msg_len equ $-msg

section .bss
input resb 4

section .text
global _start
_start:
    mov rax,1
    mov rdi,1
    mov rsi,msg
    mov rdx,msg_len
    syscall

    mov rax, 0 ; set rax register to 0 (SYS_READ system call)
    mov rdi, 0 ; set rdi register to 0 (stdin file descriptor)
    mov rsi, input ; set rsi register to address of input buffer
    mov rdx, 8 ; number of bytes to read (8 bytes for a 64-bit integer)
    syscall

    ; print integer to stdout
    mov rax, 1 ; system call for writing output
    mov rdi, 1 ; file descriptor for stdout
    mov rsi, input ; address of input buffer
    mov rdx, 8 ; number of bytes to write (8 bytes for a 64-bit integer)
    syscall

    ; exit program
    mov rax, 60 ; system call for exiting program
    mov rdi, 0 ; exit code 0
    syscall