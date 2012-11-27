newuser:	;Makes new user SI - name DI - passwd AX - priv level (0-root)
	pusha
	mov bx,void
	mov si,.user
	call gethashfile
	mov si,void
	call getfilesize
	add ax,void + 2
	mov [.end],ax
	.test
	mov si,[.end]
	cmp byte[si -1],0
	je .ok
	add byte[.end],1
	jmp .test
	.ok
	popa

	call useraddstub
	push ax
	mov si,di
	call gethash
	call tostring
	mov si,ax
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
	mov bx,cx
	mov ax,[bx]
ret
	.tmp db 0,0

login:
	mov byte[locked],1
	mov si,.usr
	call print
	mov di,buffer
	call input
	mov di,buffer
	call getuserdata
	push ax
	push si

	mov si,.pass
	call print
	mov di,buffer
	call input
	mov si,buffer
	call gethash
	call tostring
	mov di,ax
	pop si
	call compare
	pop ax
	jc .done
	call err
	jmp login
.done
	mov [user],ax
	mov byte[locked],0
	mov si,void
	mov dx,void + 512
	call memclear
ret
	.usr db 'UserName>',0
	.pass db 'Password>',0

usercmd:
	mov si,.prmpt
	call print
	mov di,buffer
	call input
	
	mov di,buffer
	mov si,.add
	call compare
	jc .addcmd

	mov si,.init
	call compare
	jc .initcmd

	mov si,list
	call compare
	jc .listcmd
	jmp .done
.addcmd
	mov si,login.usr
	call print
	mov di,buffer
	call input
	
	mov si,login.pass
	call print
	mov di,void + 4096
	call input

	mov ax,'1'
	mov si,buffer
	mov di,void + 4096
	call newuser
	jmp .done
.initcmd
	mov ax,'0'
	mov si,.root
	mov di,.root
	call newuser
	jmp .done
.listcmd
	mov si,userchar
	mov bx,void
	mov di,void + 2
	call printfilell
.done
ret
	.prmpt db 'USER>',0
	.add db 'add',0
	.init db 'init',0
	.root db 'root',0