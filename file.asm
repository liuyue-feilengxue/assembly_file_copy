DATAS SEGMENT
    ;�˴��������ݶδ���  
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
    errcde db 0   ;������
    handle dw ?   ;�����ļ���
    handle1 dw ?  ;abc�ļ���
    handle2 dw ?  ;def�ļ���
    content db 100 dup(?),'$'
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
main proc far
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

    MOV AX,DATAS
    MOV DS,AX
    ;�½��ļ�abc
    mov ax,0
    lea dx,pathname1
    call newfile
    cmp errcde,0
    jz contin1
    jmp exit
    
contin1:
	;�½������ʾ
	mov dx,offset opnok
	mov ah,09h
	int 21h
	mov bx,handle
	mov handle1,bx
	mov bx,0
	;�����ļ�����
	call proch
    cmp errcde,0
    jz contin2
    jmp exit
    
contin2:
	;���������ʾ
	mov dx,offset wrtok
	mov ah,09h
	int 21h
	;�½��ļ�def
	lea dx,pathname2
    call newfile
    cmp errcde,0
    jz contin3
    jmp exit
contin3:
	;�½������ʾ
	mov dx,offset opnok
	mov ah,09h
	int 21h
	mov bx,handle
	mov handle2,bx
	mov bx,0
	;�����ļ�
	call copy
	cmp errcde,0
    jz contin4
    jmp exit
contin4:
	;���������ʾ
	mov dx,offset cpyok
	mov ah,09h
	int 21h
	;���ļ�
	mov bx,handle1
	call clseh
	mov bx,handle2
	call clseh
	;�ر��ļ������ʾ
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
	;����
	 mov ah,01
	 int 21h
	;�жϻس�
	 cmp al,0dh
	 je b2
	;����inpuf
	 mov content[di],al
	 inc di
	 jmp b1
b2:
	;������ɣ�д���ļ�
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

