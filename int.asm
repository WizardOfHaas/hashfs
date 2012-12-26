loadints:
	mov di,except
	mov bx,0
	call loadint
	
	mov di,except
	mov bx,6
	call loadint

	mov di,except
	mov bx,0xC
	call loadint

	mov di,int32h
	mov bx,32h
	call loadint
ret

loadint:
	cli
	shl bx,2
	xor ax,ax
	mov gs,ax
	mov [gs:bx],word di
	mov [gs:bx + 2],ds
	sti
ret

int32h:
	call yield
iret

except:
	pusha
	mov si,.err
	call print
	popa
	pop ax
	add ax,2
	push ax
iret
	.err db 'Exception!',13,10,0