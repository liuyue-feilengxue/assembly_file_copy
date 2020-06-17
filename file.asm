DATAS SEGMENT
    ;此处输入数据段代码  
    pathname1 db 'abc.txt',0
    pathname2 db 'def.txt',0
    opnmsg db 'open error$'
    opnok db 'open finish',0dh,0ah,'$'
    wrtmsg db 'write error$'
    wrtok db 'write finish',0dh,0ah,'$'
    cpymsg db 'write error$'
    cpyok db 'copy finish',0dh,0ah,'$'
    clsok db 'close finish',0dh,0ah,'$'
    str1 db 'please input the content of abc.txt:$'
    errcde db 0   ;错误码
    handle dw ?   ;公用文件号
    handle1 dw ?  ;abc文件号
    handle2 dw ?  ;def文件号
    content db 100 dup(?),'$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
main proc far
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

    MOV AX,DATAS
    MOV DS,AX
    ;新建文件abc
    mov ax,0
    lea dx,pathname1
    call newfile
    cmp errcde,0
    jz contin1
    jmp exit
    
contin1:
	;新建完成提示
	mov dx,offset opnok
	mov ah,09h
	int 21h
	mov bx,handle
	mov handle1,bx
	mov bx,0
	;输入文件内容
	call proch
    cmp errcde,0
    jz contin2
    jmp exit
    
contin2:
	;输入完成提示
	mov dx,offset wrtok
	mov ah,09h
	int 21h
	;新建文件def
	lea dx,pathname2
    call newfile
    cmp errcde,0
    jz contin3
    jmp exit
contin3:
	;新建完成提示
	mov dx,offset opnok
	mov ah,09h
	int 21h
	mov bx,handle
	mov handle2,bx
	mov bx,0
	;复制文件
	call copy
	cmp errcde,0
    jz contin4
    jmp exit
contin4:
	;复制完成提示
	mov dx,offset cpyok
	mov ah,09h
	int 21h
	;关文件
	mov bx,handle1
	call clseh
	mov bx,handle2
	call clseh
	;关闭文件完成提示
	mov dx,offset clsok
	mov ah,09h
	int 21h
exit:
    MOV AH,4CH
    INT 21H
main endp


;creat file 
newfile proc near
	mov ah,3ch
	mov cx,0
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
	mov ah,09h
	mov dx,offset str1
	int 21h
	
	mov di,0
b1:
	;输入
	 mov ah,01
	 int 21h
	;判断回车
	 cmp al,0dh
	 je b2
	;存入inpuf
	 mov content[di],al
	 inc di
	 jmp b1
b2:
	;输入完成，写入文件
	mov ah,40h
	mov bx,handle1
	mov cx,di
	lea dx,content
	int 21h
	jc b3
	cmp ax,di
	jne b3
	ret
b3:
	mov dx,offset wrtmsg    ;error
	MOV AH,09H
    INT 21H
	call errm
	
	ret
proch endp

copy proc near
	mov ah,40h
	mov bx,handle2
	mov cx,10
	lea dx,content
	int 21h
	jc c1
	cmp ax,10
	jne c1
	ret
c1:
	mov dx,offset cpymsg    ;error
	MOV AH,09H
    INT 21H
	call errm
	
	ret
copy endp

clseh proc near
	mov ah,3eh
	int 21h
	ret
clseh endp

;error
errm proc near
	mov errcde,01
	ret
errm endp
    
CODES ENDS
    END main

