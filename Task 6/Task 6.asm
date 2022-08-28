%INCLUDE 'Console.API'
%INCLUDE 'Console.MAC'
SEGMENT .DATA USE32
Title db "Membaca String",0
title1 db "Message Box",0
Msg1 db "Tulis kalimat",13,10,13,10,0
Msg1_len dd $-Msg1
Buff times 255 db 13
Buff_len dd $-Buff
PJ db 'Banyak huruf: '
strhasil db ' ',13,10
db 'Banyak kata: '
strhasil2 db ' ',13,10
db 13,10,0
SEGMENT .BSS USE32
hStdOut resd 1hStdIn resd 1
nBytes resd 1
iBytes resd 1
SEGMENT .CODE USE32
..start:
BuatConsole Title, hStdIn, hStdOut
TampilkanTeks hStdOut, Msg1, Msg1_len, nBytes
BacaTeks hStdIn, Buff, Buff_len, iBytes
mov EDI,Buff
mov CL,48
mov CH,48
awal:
mov AL,[EDI]
cmp AL,13
je finish
Cmp AL, ' '
Je lup
inc CL
cmp CL,58
je next
Jmp lup
lup:
inc EDI
jmp awal
next:
sub CL,10
inc CH
inc EDI
jmp awal
finish:
mov EDI,strhasil
mov [EDI],CH
inc EDI
mov [EDI],CL
MOV EDI, Buff
DEC EDI
MOV CL, 49MOV CH, 48
loop:
INC EDI
MOV AL,[EDI]
CMP AL,13
JE break
CMP AL, 32
JNE loop
INC CL
CMP CL,59
JE lnjt
JMP loop
lnjt:
SUB CL, 10
INC CH
JMP loop
break:
MOV EDI, strhasil2
MOV [EDI], CH
INC EDI
MOV [EDI], CL
push dword 0
push dword title1
push dword PJ
push dword 0
call[MessageBoxA]
JE ulangi
TutupConsole 10
RET
