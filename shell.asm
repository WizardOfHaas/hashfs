shell:
	mov si,prompt
        call print

        mov di,buffer
        call input

	cmp byte[buffer],0
	je .err

	mov di,buffer
	call commands
	cmp ax,'fl'
	jne .done

	mov si,buffer
	call parse
	call langcommand
	cmp ax,'er'
	jne .done	

	cmp byte[buffer],95
	jge .err

	mov si,buffer
	call runbf
	jmp .done
.err
	jmp .done
.done
ret

savecurs:
	pusha
	call getcurs
	mov byte[.x],dl
	mov byte[.y],dh
	popa
ret
	.x db 0,0
	.y db 0,0

loadcurs:
	pusha
	mov dl,byte[savecurs.x]
	mov dh,byte[savecurs.y]
	call movecurs
	popa
ret

getcurs:
	mov ah,03h
	mov bx,0
	int 10h
ret

movecurs:
	pusha
	mov ah,02h
	mov bx,0
	int 10h
	popa
ret

parse:
	push si

	mov ax, si			

	mov bx, 0
	mov cx, 0
	mov dx, 0

	push ax			

.loop1:
	lodsb				
	cmp al, 0			
	je .finish
	cmp al, ' '			
	jne .loop1
	dec si
	mov byte [si], 0		

	inc si				
	mov bx, si

.loop2:					
	lodsb
	cmp al, 0
	je .finish
	cmp al, ' '
	jne .loop2
	dec si
	mov byte [si], 0

	inc si
	mov cx, si

.loop3:
	lodsb
	cmp al, 0
	je .finish
	cmp al, ' '
	jne .loop3
	dec si
	mov byte [si], 0

	inc si
	mov dx, si

.finish:
	
	pop ax
	pop si
ret