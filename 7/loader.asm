[BITS 16]
[ORG 0x7e00]

start:
    mov [DriveId],dl

    mov eax,0x80000000
    cpuid
    cmp eax,0x80000001
    jb NotSupport           

    mov eax,0x80000001
    cpuid
    test edx,(1<<29)
    jz NotSupport
    test edx,(1<<26)
    jz NotSupport

LoadKernel:
    mov si,ReadPacket
    mov word[si],0x10
    mov word[si+2],100
    mov word[si+4],0
    mov word[si+6],0x1000         ; Loading Kernel at location 0x10000, see the memory map
    mov dword[si+8],6
    mov dword[si+0xc],0
    mov dl,[DriveId]
    mov ah,0x42
    int 0x13
    jc ReadError

GetMemInfoStart:
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    mov edi,0x9000
    xor ebx,ebx
    int 0x15
    jc NotSupport

GetMemInfo:
    add edi,20
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20

    int 0x15
    jc GetMemDone       

    test ebx,ebx
    jnz GetMemInfo

GetMemDone:

TestA20:
    mov ax,0xffff
    mov es,ax
    mov word[ds:0x7c00],0xa200      ; initially ds=0 => 0:0x7c00 = 0x7c00
    cmp word[es:0x7c10],0xa200      ; 0xffff:0x7c10 = 0xffff x 16 + 0x7c00 = 0x107c00
    jne SetA20LineDone              
    ; if system is old(20 bits addressing) will truncate the line 20(21st bit)
    ; a:20                                    a:0
    ;  ^                                       ^
    ;  |                                       |
    ;  _ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
    ; 
    ; so 0x107c00 = 0x07c00 
    ; thats why recheck is needed
    
    ; Recheck
    mov word[0x7c00],0xb200
    cmp word[es:0x7c10],0xb200
    je End

SetA20LineDone:
    xor ax,ax
    mov es,ax                       ; resetting es register, for later use
    
    mov ah,0x13
    mov al,1
    mov bx,0xa
    xor dx,dx
    mov bp,Message
    mov cx,MessageLen 
    int 0x10
    jmp End

ReadError:
NotSupport:
End:
    hlt
    jmp End

DriveId: db 0
Message:    db "a20 line is ON"
MessageLen: equ $-Message
ReadPacket: times 16 db 0