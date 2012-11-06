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

	mov di,.get
	call compare
	jc .getcmd
	jmp .done
.putcmd
	mov si,.name
	call print
	mov di,buffer
	call input
	mov si,.outchar
	call print
	mov di,void + 100
	call input

	mov si,buffer
	mov bx,void + 100
	call puthashfile
	jmp .done
.getcmd
	mov si,.name
	call print
	mov di,buffer
	call input
	
	mov si,buffer
	mov bx,void
	call gethashfile
	mov si,void
	call print
	call printret
	jmp .done
.done
ret
	.prmpt db 'hashfs>',0
	.name db 'name>',0
	.outchar db '>',0
	.get db 'get',0
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
	;call resetfloppy
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