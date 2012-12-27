getrnd:				;Returns psudo-random number in ax
	push bx	
	call getpit
	in al,40h
	pop bx
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
	mov di,0
.loop
	cmp di,2880
	jge .done
	mov si,void
	call genrndsect
	mov bx,void
	mov ax,di
	call putsect
	call printdot
	add di,1
	jmp .loop
.done
ret

printdot:
	pusha
	mov si,.dot
	call print
	popa
ret
	.dot db '.',0

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
	call getrnd
	mov [si],ax
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
	cmp di,6
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
	xchg al,ah
	mov ah,0
	call tostring
	mov si,ax
	call print
.done
	popa
ret
	.errmsg db 'Write error!',13,10,0