gethash:
	xor ax,ax
	mov cx,2
.loop
	cmp byte[si],0
	je .done
	movzx bx,byte[si]
	sub bx,64	
	add ax,bx
	mul cx
	add si,1
	jmp .loop
.done
	mov bx,2880
	div bx
	mov ax,dx
ret

userhash:
	mov si,.prmpt
	call print
	mov di,buffer
	call input
	
	mov si,buffer
	mov di,.put
	call compare
	jc .putcmd
	jmp .done
.put
	mov si,.outchar
	call print
	mov di,void
	call input
	
.done
ret
	.prmpt db 'hashfs>',0
	.outchar db '>',0
	.put db 'put',0

gethashfile:
	push bx
	call resetfloppy
	call gethash
	call l2hts

	pop bx
	mov ah,2
	mov al,1
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
	call err
	mov ax,'er'
.done
ret

puthashfile:
	push bx
	call resetfloppy
	call gethash
	call l2hts

	pop bx
	mov ah,3
	mov al,1
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
	call err
	mov ax,'er'
.done
ret