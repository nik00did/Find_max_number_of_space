;Раджабли Эльсевер ПЗ-17-1
;LAB4 Вариант 17 19.02
;Задана строка символов, в которой содержатся пробелы.
;Подсчитать наибольшее количество подряд стоящих пробелов. 
dseg segment

space db ' '
count_space dw 0

maxlen db 17
reallen db ?
textbuf db 17 dup('$')

greeting db 10,13,'Enter the string:', 10,13, '$'
result db 'The largest number of consecutive spaces:', 10,13 , '$'
emptyline db 'Empty line!', 10, 13, '$' 

dseg ends 
cseg segment 
	assume ds:dseg, es:dseg, cs:cseg
main proc far
	push ds
	sub ax, ax
	push ax
	mov ax, dseg 
	mov ds, ax
	mov es, ax
	
	mov ah, 09h
	lea dx, greeting
	int 21h

	mov ah, 10
	lea dx, maxlen
	int 21h
	
	cmp reallen, 0
	jne continue
	mov ah, 09h
	lea dx, emptyline
	int 21h
	mov ah, 1h
	int 21h   
	ret
	
	continue:
	lea si, textbuf
	mov cl, reallen
	mov ch, 0
	mov bx, 0

	cycl:   lodsb
		lea di, space
		scasb
		jne not_space
		inc bx
		jmp go_next
	not_space:
		cmp bx, 0
		je go_next
		cmp bx, count_space
		jg counts
		mov bx, 0
		jmp go_next
	counts:
		mov count_space, bx
		mov bx, 0
	go_next:
		loop cycl
	cmp bx, count_space
	jg counts
	
	mov ah, 2
	mov dl, 10
	int 21h
	mov dl, 13
	int 21h
	
	mov ah, 09h
	lea dx, result
	int 21h

	;Convert to string and output this string 
	mov ax, count_space
	mov cx, 5
	mov bx, 10
	convert1: 	
		mov dx, 0
	    	div bx
		add dx, 30h
		push dx
		loop convert1
	mov cx, 5
	convert2:
		pop dx
		mov ah, 2
		int 21h
		loop convert2
	mov ah, 1h
	int 21h    			 
    	ret
main endp
cseg ends
end main