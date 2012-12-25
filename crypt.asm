getrnd:				;Returns psudo-random number in ax
	xor ax,ax
	in al,40h
	mov ah,al
	in al,40h
	xor al,ah
	call gethash
	xchg al,ah
	in al,40h
	xor ah,al
ret

cryptcmd:
	mov si,.prmpt
	mov di,buffer
	call getinput

	mov di,buffer
	mov si,.init
	call compare
	jc .initcmd
	jmp .done
.initcmd
	mov si,.msg
	call print
	call waitkey
	call initdisk
.done
ret
	.msg db 'Warning! All data on disk will be erased! Insert work disk!',13,10,'Press any key to continue...',13,10,0
	.prmpt db 'crypt>',0
	.init db 'init',0

initdisk:
	call resetfloppy
	xor dx,dx
.loop
	cmp dx,2880
	jge .done
	call getregs
	push dx
	mov si,void
	call genrndsect
	mov bx,void
	pop dx
	mov ax,dx
	call putsect
	add dx,1
	jmp .loop
.done
ret

genrndsect:
	pusha
	mov bx,si
	mov ax,si
	add ax,512
	call zeroram
	popa
	mov si,void
	xor bx,bx
.loop
	cmp bx,512
	jg .done
	push bx
	call getrnd
	mov [si],ax
	pop bx
	add si,1
	add bx,1
	jmp .loop
.done
ret

putsect:
	pusha
	push bx
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
	mov si,.errmsg
	call print
.done
	popa
ret
	.errmsg db 'Write error!',13,10,0