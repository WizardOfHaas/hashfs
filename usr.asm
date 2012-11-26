newuser:	;Makes new user SI - name DI - passwd AX - priv level (0-root)
	pusha
	mov bx,void
	mov si,.user
	call gethashfile
	mov si,void
	call getfilesize
	add ax,void + 2
	mov [.end],ax
	mov si,[.end]
	cmp byte[si -1],0
	je .ok
	add byte[.end],1
	.ok
	popa

	call useraddstub
	push ax
	;mov si,di
	;call gethash
	;call tostring
	;mov si,ax
	call useraddstub
	pop ax
	mov si,[.end]
	mov [si],ax
	mov byte[si + 1],0

	mov bx,void
	mov si,.user
	call puthashfile
ret
	.user db 'user',0
	.end db 0,0

useraddstub:
	pusha
	mov di,[newuser.end]
	call copystring
	mov ax,si
	call length
	add di,ax
	mov byte[di],' '
	add di,1
	mov [newuser.end],di
	popa
ret

getuserdata:		;DI - User Name out SI - hash AX - #
	pusha
	mov si,newuser.user
	mov bx,void
	call gethashfile
	popa
	mov si,void + 2
.loop
	pusha
	mov ax,si
	call length
	add ax,1
	mov [.tmp],ax
	popa

	push si
	push di
	call parse
	mov si,ax
	call compare
	jc .done
	cmp ax,0
	je .done
	pop di
	pop si
	add si,[.tmp]
	jmp .loop
.done
	pop di
	pop si
	mov si,bx
	mov ax,cx
ret
	.tmp db 0,0

login:
	mov si,.usr
	call print
	mov di,buffer
	call input
	mov di,buffer
	call getuserdata
	push si

	mov si,.pass
	call print
	mov di,buffer
	call input
	;mov si,buffer
	;call gethash
	;call tostring
	;mov si,ax
	;call print
	;mov di,ax
	mov di,buffer
	pop si
	call compare
	jc .done
	call err
	jmp login
.done
ret
	.usr db 'UserName>',0
	.pass db 'Password>',0

usertest:
	mov ax,'0'
	mov di,.root
	mov si,.root
	call newuser
ret
	.root db 'root',0