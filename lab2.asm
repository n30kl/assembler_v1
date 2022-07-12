STSEG SEGMENT PARA STACK "STACK" 
DB 64 DUP ( "STACK" )
STSEG ENDS

DSEG SEGMENT PARA PUBLIC "DATA" 
output db "Enter num:", 10, "$"
res db "x + 67 = ", 0, "$"
dump db 4, ?, 4 dup('?'), "$"
num dw 0
signed db 0
DSEG ENDS

CSEG SEGMENT PARA PUBLIC "CODE" 

MAIN PROC FAR ;код основної ф-ції
ASSUME CS: CSEG, DS: DSEG, SS: STSEG
PUSH DS
MOV AX, 0 
PUSH AX
MOV AX, DSEG
MOV DS, AX

lea dx, output 
mov ah,9 
int 21h 

lea dx, dump 
mov ah, 10 
int 21h 

lea BX, dump+2 
mov DX, 0
mov CL, dump + 1

CMP dump+2, "-" 
JE  hasminus
jmp l1
hasminus:
mov signed, 1
sub CL, 1
add BX, 1 

l1:
mov AX, DX
mov CH, 10 
mul CH 
mov DX, AX 
mov AH, 0
mov AL, [BX] 
sub AL, "0" 
add DX, AX 
inc BX 
mov CH, 0
loop l1

cmp signed, 0 
je add_f 
mov AX, DX
sub DX, AX
sub DX, AX

add_f:
add dx, 67
mov num, dx

MOV dl, 10 
MOV ah, 02h 
INT 21h 

call print

RET 
MAIN ENDP

print proc 

lea dx, res
mov ah,9 
int 21h 

mov bx, num 
or bx, bx
jns m1 
mov al, '-' 
int 29h
neg bx
m1:
mov ax, bx
xor cx, cx 
mov bx, 10
m2: 
xor dx, dx
div bx 
add dl, '0'
push dx
inc cx 
test ax, ax
jnz m2
m3: 
pop ax
int 29h
loop m3
ret 
print endp 

CSEG ENDS
END MAIN 
