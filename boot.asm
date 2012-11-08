
cli
mov ax,7C0h
mov ds,ax
mov es,ax
mov ax,5
mov ss,ax
mov sp,0FFFFh
sti

mov si,loading
call print

mov ax,1
call l2hts
mov bx,100h
push word 0
pop es

load:
	mov ah,2
	mov al,64
	xor di,di
	.retry
	inc di
	cmp di,3
	jge .err
	pusha
	stc
	int 13h
	jc .fail
	popa
	jmp .done
.fail
	jmp .retry
.err
	mov ax,'er'
.done

jmp 0:100h

l2hts:
	push bx
	push ax
	mov bx, ax			
	mov dx, 0			
	div word [.SecsPerTrack]	
	add dl, 01h			
	mov cl, dl			
	mov ax, bx
	mov dx, 0			
	div word [.SecsPerTrack]	
	mov dx, 0
	div word [.Sides]		
	mov dh, dl			
	mov ch, al			
	pop ax
	pop bx
	mov dl, byte 0	
ret
	.Sides dw 2
	.SecsPerTrack dw 18

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
stods db 0,0,0,0
stoes db 0,0,0,0

times 510-($-$$) db 0
dw 0AA55h