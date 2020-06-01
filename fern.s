section .text
global fern

    ;xmm0 - current x
    ;xmm1 - current y
    ;xmm2 - next x
    ;xmm3 - next y

fern:
    push rbp
    mov rbp, rsp

    ; *pixels |  Height  |   Width  |  Param1  |  Param2  |  Param3  |   iter
    ;   rdi   |    rsi   |    rdx   |   rcx    |    r8    |    r9    | 
    ;         | [rbp-40] | [rbp-32] | [rbp-24] | [rbp-16] | [rbp-8]  | [rbp+16] 

    sub rsp, 40
    mov [rbp-8], r9
    mov [rbp-16], r8
    mov [rbp-24], rcx
    mov [rbp-32], rdx
    mov [rbp-40], rsi
    mov r11, [rbp+16]           ; licznik
    movsd xmm0, [rel zero_f]
    movsd xmm1, [rel zero_f]
    movsd xmm2, [rel zero_f]
    movsd xmm3, [rel zero_f]

loop1:

    rdrand eax
    and eax, 1000
    
    cmp eax, [rbp-24]
    jb fun1 

    cmp eax, [rbp-16]
    jb fun2

    cmp eax, [rbp-8]
    jb fun3

fun4:                           ; f(x,y) = (0; 0.16y)

    movsd xmm2, [rel zero_f]    ; x = 0

    movsd xmm4, [rel val12]
    mulsd xmm4, xmm1
    movsd xmm3, xmm4            ; 0.16y

    jmp scale

fun1:           ; f(x,y) = (0.85x + 0.04y; -0.04x + 0.85y + 1.6)

    movsd xmm4, [rel val1]
    movsd xmm5, [rel val2]

    mulsd xmm4, xmm0            ;0.85*x
    mulsd xmm5, xmm1            ;0.04*y

    addsd xmm4, xmm5

    movsd xmm2, xmm4            ;next x

    movsd xmm4, [rel val1]
    movsd xmm5, [rel val2]

    mulsd xmm4, xmm1            ;0.85*y
    mulsd xmm5, xmm0            ;0.04*x
    subsd xmm4, xmm5            ;0.85y-0.04x
    addsd xmm4, [rel val3]      ; +1,6
    movsd xmm3, xmm4            ;next y

    jmp scale

fun2:           ; f(x,y) = (-0.15x + 0.28y; 0.26x + 0.24y + 0.44)

    movsd xmm4, [rel val4]
    movsd xmm5, [rel val5]

    mulsd xmm4, xmm0            ;0.15*x
    mulsd xmm5, xmm1            ;0.28*y
    subsd xmm5, xmm4            ;0.28y-0.15x

    movsd xmm2, xmm5            ;next x

    movsd xmm4, [rel val6] 
    movsd xmm5, [rel val7]

    mulsd xmm4, xmm0            ;0.26*x
    mulsd xmm5, xmm1            ;0.24*y
    addsd xmm4, xmm5            ;0.26x+0.24y
    addsd xmm4, [rel val8]      ;+0,44

    movsd xmm3, xmm4            ;next y

    jmp scale
                
fun3:           ; f(x,y) = (0.2x - 0.26y; 0.23x + 0.22y + 1.6)

    movsd xmm4, [rel val9]
    movsd xmm5, [rel val6]

    mulsd xmm4, xmm0            ;0,2*x
    mulsd xmm5, xmm1            ;0,26*y
    subsd xmm4, xmm5            ;0,2x-0,26y

    movsd xmm2, xmm4            ;next x

    movsd xmm4, [rel val10]
    movsd xmm5, [rel val11]

    mulsd xmm4, xmm0            ;0,23*x
    mulsd xmm5, xmm1            ;0,22*y
    addsd xmm4, xmm5            ;0,23x+0,22y
    addsd xmm4, [rel val3]      ;+1,6

    movsd xmm3, xmm4            ;next y

scale:
    ;xrys = szer*(x+3)/6
    ;yrys = wys - wys*(y+2)/10

    movsd xmm4, xmm2
    cvtsi2sd xmm5, [rbp-32]

    addsd xmm4, [rel three]
    divsd xmm4, [rel six]
    mulsd xmm4, xmm5
    cvtsd2si r8, xmm4           ;xrys jako liczba calkowita

    movsd xmm4, xmm3
    cvtsi2sd xmm5, [rbp-40]

    addsd xmm4, [rel two]
    divsd xmm4, [rel ten]
    mulsd xmm4, xmm5
    subsd xmm5, xmm4
    cvtsd2si r9, xmm5           ;yrys jako liczba calkowita

colour:     
    ;pixel do pokolorowania: 4*(yrys*szer+xrys)

    mov r12, 4

    imul r9, [rbp-32]           ;y*szer
    add r9, r8                  ;+x
    imul r9, r12        
    add r9, rdi

    mov r12, 0
    mov r13, 255 

    mov [r9], r12               ;czerwony

    add r9, 1
    mov [r9], r13               ;zielony

    add r9, 1
    mov [r9], r12               ;niebieski

    add r9, 1
    mov byte[r9], 255

next:
    movsd xmm0, xmm2
    movsd xmm1, xmm3

    sub r11, 1
    cmp r11, 0
    jg loop1

end:
    mov rsp, rbp
    pop rbp
    ret

section .data
    val1: dq 0.85
    val2: dq 0.04
    val3: dq 1.6
    val4: dq 0.15
    val5: dq 0.28
    val6: dq 0.26
    val7: dq 0.24
    val8: dq 0.44
    val9: dq 0.2
    val10: dq 0.23
    val11: dq 0.22
    val12: dq 0.16
    zero_f: dq 0.0
    two: dq 2.0
    three: dq 3.0
    six: dq 6.0
    ten: dq 10.0