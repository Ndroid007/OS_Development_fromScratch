[BITS 16]
[ORG 0x7c00]

start:
    xor ax,ax   
    mov ds,ax
    mov es,ax  
    mov ss,ax
    mov sp,0x7c00

TestDiskExtension:
    mov [DriveId],dl
    mov ah,0x41
    mov bx,0x55aa
    int 0x13
    jc NotSupport
    cmp bx,0xaa55
    jne NotSupport

LoadLoader:
    mov si,ReadPacket                   ; Si Points to DAP(Disk Address Packet- consists of following data set)
                                        ; OFFSET    SIZE    Description
    mov word[si],0x10                   ; 0         Word    Size of This packet [either 0x10h or 0x18h](here it is 16 bytes [0x10h bytes])
    mov word[si+2],5                    ; 2         Word    Number of Logical blocks to transfer
    mov dword[si+4],0x7e00              ; 4         Doub    Transfer Buffer address
    
    mov dword[si+8],1                   ; 8         Quad    Starting absolute block number
    mov dword[si+12],0      ; qword isn't supported so 2 dwords
    ; Extensible packet 0x18h then,
    ; mov qword[si+16],[64-bit address of buffer address]
    mov dl, [DriveId]
    mov ah, 0x42
    int 0x13
    jc ReadError

    mov dl,[DriveId]
    jmp 0x7e00

ReadError:
NotSupport:
    mov ah,0x13
    mov al,1
    mov bx,0xa
    xor dx,dx
    mov bp,Message
    mov cx,MessageLen 
    int 0x10

End:
    hlt    
    jmp End
    
DriveId:    db 0
Message:    db "We have an error in boot process"
MessageLen: equ $-Message
ReadPacket: times 16 db 0

times (0x1be-($-$$)) db 0

    db 80h
    db 0,2,0
    db 0f0h
    db 0ffh,0ffh,0ffh
    dd 1
    dd (20*16*63-1)
	
    times (16*3) db 0

    db 0x55
    db 0xaa

	
