start:
        cld

        int     12h             ; get conventional memory size (in KBs)
        shl     ax, 6           ; and convert it to paragraphs

        sub     ax, 512 / 16    ; reserve 512 bytes for the boot sector code
        mov     es, ax          ; es:0 -> top - 512

        sub     ax, 2048 / 16   ; reserve 2048 bytes for the stack
        mov     ss, ax          ; ss:0 -> top - 512 - 2048
        mov     sp, 2048        ; 2048 bytes for the stack

        mov     cx, 256
        mov     si, 7C00h
        xor     di, di
        mov     ds, di

        rep     movsw
        push    es
        push    word main
        retf

main:
        push    cs
        pop     ds
mov si,loading
call print

mov ax,0
mov es,ax
mov bx,100h

mov ah,02h
mov al,63
xor cx,cx
mov cl,02h
xor dx,dx
int 13h

mov si,jumping
call print

cli
mov ax,50h
mov es,ax
sub ax,10h
mov ds,ax
sti

xchg bx,bx

jmp 0x0000:0x0100

resetfloppy:
	pusha
	mov ax, 0
	mov dl, 0
	stc
	int 13h
	popa	
ret

print:			;Print string
	pusha
	mov ah,0Eh	;IN - si, string to print
	mov bl,2
.repeat
        lodsb
        cmp al,0
        je .done
        int 10h
        jmp .repeat
.done
	popa
ret

loading db 'Booting off HashFS...',0
jumping db 13,10,'Jumping to kernel...',0
stods db 0,0,0,0
stoes db 0,0,0,0

times 510-($-$$) db 0
dw 0AA55h