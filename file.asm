DATAS SEGMENT
    ;此处输入数据段代码  
    
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
    call newfile
    
    MOV AH,4CH
    INT 21H
main endp
    
newfile proc near
	
	ret
newfile endp
    
CODES ENDS
    END main

