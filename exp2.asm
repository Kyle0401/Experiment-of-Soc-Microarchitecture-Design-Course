DATA SEGMENT
    strin DB 'input number (less than 5 charactors): $'
    strout DB 'binary: $'
    strerrnull DB 'ERROR: No Any Input.$'
    strerrcha DB 'ERROR: Too Many Charactors.$'
    strerrnotnum DB 'ERROR: Not a Number.$'
    CRLF DB 0DH,0AH,'$'
DATA ENDS

MYSTACK SEGMENT PARA STACK
    DW  256 DUP(?)
MYSTACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    ;assign dataseg
    MOV AX,DATA
    MOV DS,AX

BEGIN:
    LEA  DX,strin
    MOV  AH,09H
    INT  21H
    CALL NEXTLINE   ;
    MOV  CX,0005H
    XOR  AX,AX
    MOV  BH,00H
    XOR  DX,DX

LINCHR:     ;ѭ����������ַ������д���

    CALL INCHR

    ;���س�
    CMP BL,00H
    JNE CTN
    ;��һ�����ǻس�������err
    CMP CX,0005H
    JE ERRNUL
    ;�����Ľ������룬��ʼ׼�����
    JMP OUTC

CTN:    ;���ǻس�����������
    ;����Ƿ�Ϊ����
    CMP BL,30H
    JB ERRNNUM
    CMP BL,39H
    JA ERRNNUM

    ;ת��ֵ
    SUB BL,30H

MULTEN:
    ;��һ��ѭ������Ҫ��ʮ
    CMP CX,0005H
    JE ADDAB

    PUSH BX

    ;��ʮ
    MOV BX,000AH
    MUL BX

    POP BX

ADDAB:
    ;���
    ADD AX,BX    

ADDNC:
    LOOP LINCHR

    ;�������ַ���Ҫ����س�,������ǻس�˵���������
    CALL INCHR

    CMP BL,00H
    JNE ERRCHR

OUTC:   ;���������

OUTAH:
    ;�ж��Ƿ���Ҫ���AH
    CMP AH,00H
    JE OUTAL
OUTAH1:

    MOV BL,AH
    CALL NEXTLINE
    CALL OUTBINY
    
    
OUTAL:
    MOV BL,AL
    CALL NEXTLINE
    CALL OUTBINY
    
    CALL NEXTLINE   ;������
    CALL NEXTLINE   ;������
    JMP BEGIN


;���������ص����
ERRNNUM:    ;�����ִ���
    CALL NEXTLINE

    LEA DX,strerrnotnum
    MOV AH,09H
	INT 21H

    CALL NEXTLINE

    JMP BEGIN

ERRCHR:     ;����̫���ַ�
    CALL NEXTLINE

    LEA DX,strerrcha
    MOV AH,09H
	INT 21H

    CALL NEXTLINE

    JMP BEGIN

ERRNUL:     ;���������루ֻ�����˻س���
    ; CALL NEXTLINE     ;�Ѿ��лس���

    LEA DX,strerrnull
    MOV AH,09H
	INT 21H

    CALL NEXTLINE

    JMP BEGIN


;functions

;��ȡһ���ַ�������BL
INCHR:
    PUSH AX
    MOV AL,00H
    MOV AH,01H
    INT 21H

    ;��q��Q�Ƚϣ���ͬ���˳�
    CMP AL,'Q'
    JE EXIT
    CMP AL,'q'
    JE EXIT

    MOV BL,AL

    POP AX
    RET

;���BL�Ķ�����
OUTBINY:
    PUSH AX
    PUSH CX

    MOV CX,8
PTBIT:
    ROL BL,1    ;CF=the highest bit
    JC IS1     
    MOV DL,'0'  ;CF=0
    JMP DISP
IS1:
    MOV DL,'1' ;CF=1
DISP:
    MOV AH, 02H
    INT 21H
    LOOP PTBIT

    POP CX
    POP AX

    RET 
;end OUTBINY

;����
NEXTLINE:
    PUSH AX

    LEA DX,CRLF
	MOV AH,09H
	INT 21H

    POP AX

    RET
;end NEXTLINE



EXIT:
	MOV AH,4CH
	INT 21H
CODE ENDS
END START
END


