STSEG SEGMENT PARA STACK "STACK" ;опис сегмента стека
DB 64 DUP ( "STACK" )
STSEG ENDS

DSEG SEGMENT PARA PUBLIC "DATA" ;опис сегмента даних
outputx db "Enter x:", 10, "$"
outputy db "Enter y:", 10, "$"
Yourx db "Your x:", 0, "$"
Youry db "      Your y:", 0, "$"
outputres1 db "      For x=-5 y<0 => ", 0, "$"
outputres2 db "      For x>3 && y>0 => ", 0, "$"
outputres3 db "      For else => 1", 0, "$"
dot db "." ,0, "$"
dump db 4, ?, 4 dup('?'), "$" 
x dw 0
y dw 0
num1 dw 0
num2 dw 0
numres dw 1
signed db 0
DSEG ENDS

CSEG SEGMENT PARA PUBLIC "CODE" 

MAIN PROC FAR 
ASSUME CS: CSEG, DS: DSEG, SS: STSEG

; адреса повернення
PUSH DS
MOV AX, 0 
PUSH AX

; ініціалізація DS
MOV AX, DSEG
MOV DS, AX

;ВВЕДЕННЯ X
lea dx, outputx
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

mov x, dx

cmp signed, 0
je enty
mov AX, DX
sub DX, AX
sub DX, AX
mov x, dx



;ВВЕДЕННЯ Y
enty:
lea dx, outputy
mov ah,9 
int 21h 

lea dx, dump
mov ah, 10
int 21h

lea BX, dump+2 
mov DX, 0 
mov CL, dump + 1

CMP dump+2, "-"
JE  hasminusy
jmp ly1
hasminusy:
mov signed, 1
sub CL, 1
add BX, 1

ly1:
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
loop ly1 

mov y, dx

cmp signed, 0
je b1
mov AX, DX
sub DX, AX
sub DX, AX
mov y, dx

;X = -5 && Y<0
b1:
lea dx, Yourx 
mov ah,9
int 21h 
mov dx, x
mov numres, dx
call digit

lea dx, Youry 
mov ah,9 
int 21h
mov dx, y
mov numres, dx
call digit

cmp x,-5
JE a1
jmp b2
ret

a1:
cmp y,0
JL a2
jmp b2
ret

a2:
mov ax, x
mov dx, x
imul  dx
mov num1,ax ;num1 = x*x

mov ax, num1
mov dx, 8
imul  dx
mov num1,ax ;num1 = 8*(x*x)

mov ax, num1
mov bx, y
cwd
idiv bx
mov num1, ax ;ціле
mov num2, dx ;остача
mov dx, num1
mov numres, dx

lea dx, outputres1
mov ah,9
int 21h

call digit

lea dx, dot
mov ah,9 
int 21h 

mov dx, num2
mov numres, dx

call digit

RET

;X>3 && Y>0
b2:
cmp x,3
JG a3
jmp b3
ret

a3:
cmp y,0
JG a4
jmp b3
ret

a4:
mov ax, x
mov dx, 6
imul  dx
mov numres,ax 

lea dx, outputres2
mov ah,9
int 21h
call digit 
ret

;ішнші випадки
b3:
lea dx, outputres3
mov ah,9
int 21h
ret


MAIN ENDP 

digit proc 
mov bx, numres 
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
digit endp

CSEG ENDS
END MAIN