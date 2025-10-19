DATA SEGMENT
    helloworld DB 'Hello World!',0DH,0AH,24H
    inputName DB 'Please input your name>',0DH,0AH,24H
    inputID DB 'Please input your ID>',0DH,0AH,24H
    
    buffer DB 256 DUP('$')

DATA ENDS

SSEG SEGMENT PARA STACK
    DW 256 DUP(?)
SSEG ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:SSEG

putchar PROC NEAR
    PUSH   AX
    PUSH   DX
    
    MOV    AH, 02H
    MOV    DL, AL
    INT    21H
    
    POP    DX
    POP    AX
    RET
putchar ENDP

print PROC NEAR
    PUSH   AX
      
    MOV    AH,09H
    INT    21H
    
    POP    AX
    RET
print ENDP  

println PROC NEAR
    PUSH   AX
    
    CALL   print
    MOV    AL, 0DH
    CALL   putchar
    MOV    AL, 0AH
    CALL   putchar
    
    POP    AX
    RET
println ENDP 

BEGIN:
    MOV    AX, DATA
    MOV    DS, AX
    MOV    AX, SSEG
    MOV    SS, AX
    MOV    SP, 512
    
    LEA    DX, helloworld
    CALL   print
    
    LEA    DX, inputName
    CALL   print
    
    LEA    DX, inputID
    CALL   print

CODE ENDS
END BEGIN

    

