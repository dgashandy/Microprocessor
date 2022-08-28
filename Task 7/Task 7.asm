%INCLUDE 'Console.API'
%INCLUDE 'Console.MAC'
SEGMENT .DATA USE32
Title db "Penjumlahan",0
title1 db "Total Data",0
Msg1 db "Tulis data-data, akhiri dengan 0",13,10,13,10,0
Msg1_len dd $-Msg1
Buff times 255 db 13
Buff_len dd $-Buff
PJ db 'Total data: '
totalhasil db ' ',13,10
db 'Lagi? '
db 13,10,0
SEGMENT .BSS USE32
hStdOut resd 1
hStdIn resd 1
nBytes resd 1
iBytes resd 1
jumlah resd 1
SEGMENT .CODE USE32
..start:BuatConsole Title, hStdIn, hStdOut
ulangi:
TampilkanTeks hStdOut, Msg1, Msg1_len, nBytes
BacaTeks hStdIn, Buff, Buff_len, iBytes
CALL str2num
mov [jumlah],eax
Inputloop:
BacaTeks hStdIn, Buff, Buff_len, iBytes
CALL str2num
add [jumlah],eax
cmp eax,0
jnz Inputloop
mov eax,[jumlah]
mov ebx, totalhasil
loop1:
cmp byte[ebx],13
je exit1
mov byte[ebx],' '
inc ebx
jmp loop1
exit1:
dec ebx
mov si,10
loop2:
sub edx, edx
div si
add dl, '0'
mov [ebx],dl
dec ebx
or eax,eax
jnz loop2
push dword (4+64)
push dword title1
push dword PJ
push dword 0
call[MessageBoxA]
CMP EAX, 6
JE ulangiTutupConsole 10
RET
str2num:
xor eax,eax
mov esi,10
mov ebx,Buff
mov ecx, [iBytes]
sub ecx, 2
xor edx,edx
loopbil:
mul esi
mov dl, byte[ebx]
sub dl,30h
add eax,edx
inc ebx
loop loopbil
RET
