section .data   ;initialised data section
                ;db means 'define bytes' (There are dw, dd, dq; w = word = 2 bytes; d = double word; q = quad word)
                ;db,dw,dd,dq are pseudo-instructions which associates the address of the given data with the label
welcome:        db      "Input a number between 1 and 999; Input q to quit"
                ;equ evaluates its operand '$ - welcome' once and associates its value with the label (no addresses involved)
w_len:          equ     $ - welcome ;Reads: 'dollar minus welcome'
                                    ;'$' evaluates to the assembled position at the beginning of that line.
                                    ;'welcome' is the address of the first byte of that string
in_msg:         db      0xa, "Enter n: "        ;0xa = hexadecimal equivalent of 10 = the ascii code of line-break
im_len:         equ     $ - in_msg
out_msg:        db      "Sum: "
om_len:         equ     $ - out_msg

section .bss    ;uninitialised data section
                ;resb means 'reserve bytes' (There are also resw, resd, resq like before)
n_str:          resb    4       ;reserves 4 bytes and associates the address of the first byte with n_str
sum_str:        resb    7

section .text
                        ;we must export the entry point to the ELF linker (ld). [Executable and Linkable Format]
        global _start   ;'ld' conventionally recognize _start as their entry point.
                        ;Use `ld -e entry_point` to override the default.

                        ;RgsA =:means:= Registers Afftected

print:                  ;In:    ecx=address of the string
                        ;       edx=length of string
                        ;RgsA:  none
        push    ebx     ;push the value of ebx into the stack (Stack Pointer, esp = esp-4)
        push    eax
        mov     eax,4   ;4 is the syscall code for write
        mov     ebx,1   ;std output (terminal)
        int     0x80    ;syscall (kernel interrupt)
        pop     eax     ;loads the (last pushed) value from the stack into eax (esp = esp+4)
        pop     ebx
        ret             ;ret and call are explained later...

scan:                   ;In:    ecx=address where the input gets stored
                        ;       edx=max length of input string
                        ;RgsA:  none
        push    ebx
        push    eax
        mov     eax,3   ;syscall code for read
        mov     ebx,0   ;std input (terminal)
        int     0x80
        pop     eax
        pop     ebx
        ret

xTen:                   ;Result: eax=eax*10
                        ;RgsA: eax
        push    ebx
        mov     ebx,eax ;ebx=eax
        shl     eax,2   ;shift left by 2 places
        add     eax,ebx ;eax=eax+ebx
        shl     eax,1
        pop     ebx
        ret

byTen:                  ;Result: eax=eax/10, ebx=eax%10
                        ;RgsA:   eax, ebx
        push    edx
        push    ecx
        mov     edx,0
        mov     ecx,10
        div     ecx
        mov     ebx,edx
        pop     ecx
        pop     edx
        ret

toInt:                  ;Out:   eax=toInt(string at ecx)
                        ;In:    ecx=address of string
                        ;       edx=max length of string
                        ;RgsA:  eax
        push    ebx
        mov     eax,0
        mov     ebx,0
    .loopStr:           ;'.label' means local label. It is associated with the previous non-local label
        call    xTen    ;So this '.loopStr' can be globally accessed as 'toInt.loopStr' (rarely needed)
        push    edx     ;store edx
        mov     edx,0
        mov     dl,byte[ecx+ebx]        ;[..] means dereferencing, 'byte' tells the size of dereferenced data
                                        ; there are also word, dword and qword
        sub     dl,0x30 ;ascii code of '0'
        add     eax,edx
        pop     edx     ;restore edx
        inc     ebx     ;increment ebx by 1
        cmp     byte[ecx+ebx],0xa
        jle     .return
        cmp     ebx,edx
        jge     .return
        jmp     .loopStr
    .return:
        pop     ebx
        ret

toStr:                  ;Out:   ecx=toStr(eax)
                        ;In:    eax=integer to convert
                        ;       ecx=address where string should be stored
                        ;       edx=max length of string
                        ;RgsA:  none
        push    ebx
        push    eax
        mov     ebx,0
        push    0
    .loopDiv:                   ;repeatedly divide eax by 10 and stack up the remainders (ascii) till eax=0
        call    byTen
        add     ebx,0x30
        push    ebx
        cmp     eax,0
        jg      .loopDiv
        mov     ebx,0
    .loopStr:                   ;pop the remainders into [ecx+n] (this will be in reverse order to stacking)
        pop     eax
        cmp     eax,0
        je      .loopFill
        cmp     ebx,edx
        je      .loopStr        ;pop the remaining items from the stack if the number cannot fit into the string
        mov     byte[ecx+ebx],al        ;Note that the value of eax, ax and al are the same until
                                        ; they are overflowed (ie. eax=256 [2^8] then al=0, ah=1, ax=2^8)
        inc     ebx
        jmp     .loopStr
    .loopFill:                  ;fill the remaining space in [ecx+..] with zeroes (null values)
        cmp     ebx,edx
        je      .return
        mov     byte[ecx+ebx],0
        inc     ebx
        jmp     .loopFill
    .return:
        pop     eax
        pop     ebx
        ret

sumN:                   ;eax=1+2+3+...+ebx; RgsA: eax
        mov     eax,0
        push    ebx
    .loopN:
        add     eax,ebx
        dec     ebx
        jnz     .loopN
        pop     ebx
        ret

_start:
        mov     ecx,welcome             ;the address of the string is copied to ecx
        mov     edx,w_len               ;the length of the string is copied to edx
        call    print                   ;the current instruction pointer (IP) is pushed into the stack
                                        ; and jumps to the address (instruction) associated with 'print'.
                                        ;Note: IP stores the address of next instruction to be executed.
                                        ;'ret' pops into the IP jumping to the next instruction here.
                                        ;So before 'ret' is executed, all items we pushed after the call
                                        ; statement must be popped so that the current IP itself is popped back.
    .main_loop:
        mov     ecx,in_msg
        mov     edx,im_len
        call    print

        mov     ecx,n_str
        mov     edx,4
        call    scan

        cmp     byte[n_str],0x71        ;ascii code of 'q'
        je      .quit

        call    toInt

        mov     ebx,eax
        call    sumN

        mov     ecx,out_msg
        mov     edx,om_len
        call    print

        mov     ecx,sum_str
        mov     edx,7
        call    toStr

        call    print
        jmp     .main_loop

    .quit:
        mov     ebx,0
        mov     eax,1
        int     0x80

;Compiling and executing:
;    nasm -f elf sum.asm
;    ld -s -o outfile sum.o
;        ;If you are using a 64-bit linux distribution, run instead
;        ;    ld -m elf_i386 -s -o outfile sum.o
;    ./outfile