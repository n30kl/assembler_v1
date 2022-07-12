;опис сегмента стека
STSEG SEGMENT PARA STACK "STACK"
DB 64 DUP ( 'STACK' )
STSEG ENDS

;опис сегмента даних
DSEG SEGMENT PARA PUBLIC 'DATA'
SOURCE DB 10, 20, 30, 40
DEST DB 4 DUP ( '?' )
DSEG ENDS

;опис сегмента коду
CSEG SEGMENT PARA PUBLIC 'CODE'

;код основної ф-ції
MAIN PROC FAR
ASSUME CS: CSEG, DS: DSEG, SS: STSEG 

; адреса повернення
PUSH DS
MOV AX, 0
PUSH AX

; ініціалізація DS
MOV AX, DSEG
MOV DS, AX

; обнуляємо масив
MOV DEST, 0
MOV DEST+1, 0
MOV DEST+2, 0
MOV DEST+3, 0

; пересилання
MOV AL, SOURCE
MOV DEST+3, AL
MOV AL, SOURCE+1
MOV DEST+2, AL
MOV AL, SOURCE+2
MOV DEST+1, AL
MOV AL, SOURCE+3
MOV DEST, AL
RET
MAIN ENDP 
CSEG ENDS 
END MAIN 