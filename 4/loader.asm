[BITS 16]
[ORG 0x7e00]

start:
    mov [DriveId],dl

    ;   ;   ;   ;   ;   ;
    ; Getting CPU feature by passing params in eax and will 
    ; return values in ebx, ecx and edx

    ; check if the feature: 0x80000001 supports or not
    mov eax,0x80000000
    cpuid
    cmp eax,0x80000001      ; return support feature param in eax
    jb NotSupport           ; Jump if value is below

        ; Following will get Features
    mov eax,0x80000001
    cpuid
    ;   ;   ;   ;   ;   ;
    test edx,(1<<29)        ; This bit check is returned instruction of Long Bit mode support
    jz NotSupport
    test edx,(1<<26)        ; Check 1GB Page support
    jz NotSupport

    mov ah,0x13
    mov al,1
    mov bx,0xa
    xor dx,dx
    mov bp,Message
    mov cx,MessageLen 
    int 0x10
    jmp End

NotSupport:
End:
    hlt
    jmp End

DriveId: db 0
Message:    db "Long Mode is supported"
MessageLen: equ $-Message