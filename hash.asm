gethash:
	xor ax,ax
	mov cx,2
.loop
	call getregs
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
	call getregs
	mov ax,dx
ret

userhash:
	mov si,.prmpt
	call print
	mov di,buffer
	call input
	mov si,buffer
	call gethash
ret
	.prmpt db '>',0