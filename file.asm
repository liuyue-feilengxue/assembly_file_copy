DATAS SEGMENT
    ;此处输入数据段代码  
    pathname1 db 'abc.txt',0
    pathname2 db 'def.txt',0
    opnmsg db 'open error$'
    errcde db 0
    handle dw ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
main proc far
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    mov ax,0
    call newfile
    cmp errcde,0
    jz contin1
    jmp exit
contin1:
	call proch
    
exit:
    MOV AH,4CH
    INT 21H
main endp


;creat file 
newfile proc near
	mov ah,3ch
	mov cx,0
	lea dx,pathname1
	int 21h
	jc a1
	mov handle ,ax
	ret
a1: mov dx,offset opnmsg    ;error
	MOV AH,09H
    INT 21H
	call errm
	ret
newfile endp

;input
proch proc near
	
	ret
proch endp

;error
errm proc near
	mov errcde,01
	ret
errm endp
    
CODES ENDS
    END main




