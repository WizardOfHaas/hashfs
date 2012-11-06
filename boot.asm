cli
mov ax,0x7C0
mov ds,ax
mov es,ax
sti

mov si,loading
call print

mov ax,1
call l2hts
mov bx,100h

load:
	mov ah,2
	mov al,63
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

jmp 100h

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

times 510-($-$$) db 0
dw 0AA55h