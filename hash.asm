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

	mov di,.kill
	call compare
	jc .killcmd
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
.killcmd
	mov si,.name
	call print
	mov di,buffer
	call input
	mov si,buffer
	call killhashfile	
.done
ret
	.prmpt db 'hashfs>',0
	.name db 'name>',0
	.outchar db '>',0
	.get db 'get',0
	.put db 'put',0
	.kill db 'kill',0

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

isfileempty:
	pusha
	mov bx,void + 4096
	call gethashfile
	mov si,void + 4096
.loop
	cmp byte[si],0
	jne .stuff
	cmp si,void + 4096 + 512
	jge .empty
	add si,1
	jmp .loop
.empty
	clc
	jmp .done
.stuff
	stc
.done
	popa
ret

makefileempty:
	pusha
	mov si,void + 4096
.loop
	mov byte[si],0
	cmp si,void + 4096 + 512
	jg .done
	add si,1
	jmp .loop
.done
	popa	
ret

killhashfile:
	call makefileempty
	mov bx,void + 4096
	call puthashfile
ret

getindex:
.loop
	cmp ax,0
	je .done
	cmp byte[si],0
	je .test
	add si,1
	jmp .loop
.test
	add si,1
	sub ax,1
	jmp .loop
.done
ret