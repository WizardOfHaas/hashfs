textedit:
	.start
	mov si,.name
	call print
	mov di,buffer
	call input

	mov si,buffer
	mov di,.filename
	call copystring

	mov dx,void + 20
	mov si,void + 1024
	call memclear
.loop
	mov di,buffer
	call input
	
	mov di,buffer
	mov si,quit
	call compare
	jc .done
	
	mov ax,buffer
	call length
	call maloc
	push ax
	mov si,buffer
	call load2mem
	pop bx
	add byte [.lines],1
	jmp .loop
.done
	mov si,.filename
	mov bx,void + 20
	call puthashfile
.end
	call printret
ret
	.filestart db 0
	.filend db 0
	.lines db 0
	.filename times 16 db 0
	.name db 'NAME>',0
	.line db 'LINE>',0
	.list db 'list',0
	.outchar db '>'

printfile:
	add ax,12
	mov [.filend],bx
	mov si,ax
.typeloop
	call print
	mov ax,si
	call length
	add si,ax
	cmp si,[.filend]
	jge .done
	add si,1
	call printret
	cmp byte[si],'*'
	je .done
	jmp .typeloop
.done
ret
	.filend db 0,0

tagprintfile:
	mov [.nextfile],di

	call findfile
	cmp ax,0
	je .done
	call printfile
	mov di,[.nextfile]
.loop
	call findtag
	cmp ax,0
	je .done
	mov di,[.nextfile]
	
	call readtag
	mov di,si
	mov [.nextfile],di
	call findfile
	cmp ax,0
	je .done
	call printfile
	mov di,[.nextfile]
	jmp .loop
.done
	call printret
ret
	.nextfile db 0,0