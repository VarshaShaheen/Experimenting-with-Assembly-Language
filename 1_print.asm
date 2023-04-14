section .data
    msg: db "Hello, World!", 10
    msg_len equ $ - msg

section .text
 global _start
  _start:
    mov rax, 1  ; specify which system call to invoke, 1-write system call
    mov rdi, 1  ; specify the file descriptor, 1-stdout
    mov rsi, msg ; specify the address of the message
    mov rdx, msg_len   ; specify the length of the message
    syscall
    call exit

  exit:
    mov rax, 60 ; specify which system call to invoke, 60-exit system call
    mov rdi, 0  ; specify the exit code, 0-success
    syscall
