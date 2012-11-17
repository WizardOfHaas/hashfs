textedit:
	.start
	mov si,.name
	call print
	mov di,.filename
	call input

	mov si,.filename
	call isfileempty
	jc .type
	
	mov ax,1
	call maloc
	add ax,1
	mov [.filestart],ax

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
	mov [.filend],ax
	push ax
	mov si,buffer
	call load2mem
	pop bx
	mov byte[bx],13
	mov byte[bx + 1],10
	jmp .loop
.type
	mov si,void + 4096
	call print
	jmp .end
.done
	mov ax,1
	call maloc
	mov byte[bx],0
	mov si,.filename
	mov bx,[.filestart]
	call puthashfile
.end
	call printret
ret
	.filestart db 0,0
	.filend db 0,0
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