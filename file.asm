DATAS SEGMENT
    ;�˴��������ݶδ���  
    
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
main proc far
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    call newfile
    
    MOV AH,4CH
    INT 21H
main endp
    
newfile proc near
	
	ret
newfile endp
    
CODES ENDS
    END main

