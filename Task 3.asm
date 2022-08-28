;Deklarasi procedure eksternal
extern GetStdHandle
extern WriteFile
extern ReadFile
extern AllocConsole
extern FreeConsole
extern SetConsoleTitleA
extern Sleep
extern ExitProcess
;Import dari file DLL
import GetStdHandle kernel32.dll
import WriteFile kernel32.dll
import ReadFile kernel32.dll
import AllocConsole kernel32.dll
import FreeConsole kernel32.dll
import SetConsoleTitleA kernel32.dll
import Sleep kernel32.dll
import ExitProcess kernel32.dll
;Deklarasi variabel dg data awal tertentu
SEGMENT .DATA USE32
Title db "Tugas 3 Mikroprosessor", 0
Msg1 db "Tulis Kalimat : ",0
Msg1_len dd $-Msg1
Msg2 db 13,10,"Tunggu 10 detik .............", 13,10,0
Msg2_len dd $-Msg2
Buff times 255 db 13
Buff_len dd $-Buff
;Deklarasi variabel tanpa data awal
SEGMENT .BSS USE32
hStdOut resd 1
hStdIn resd 1
nBytes resd 1
iBytes resd 1SEGMENT .CODE USE32
..start:
CALL [AllocConsole]
PUSH dword Title
CALL [SetConsoleTitleA]
PUSH dword -11 ;; STD_OUTPUT_HANDLE = -11.
CALL [GetStdHandle]
MOV dword [hStdOut], EAX
PUSH dword -10 ;; STD_INPUT_HANDLE = -10
CALL [GetStdHandle]
MOV dword [hStdIn], EAX
;Lanjutan bagian instruksi
;Menampilkan Msg1 ke Console(Monitor) dg WriteFile
PUSH dword 0 ;; parm-5 dari WriteFile() adalah 0
PUSH dword nBytes ;; parm-4 jumlah byte yg tertuliskan
PUSH dword [Msg1_len] ;; parm-3 panjang string
PUSH dword Msg1 ;; parm-2 string yang akan ditampilkan
PUSH dword [hStdOut] ;; parm-1 handle stdout
CALL [WriteFile]
;Lanjutan bagian instruksi
;; Membaca string dari Console(keyboard) dg ReadFile
PUSH dword 0 ;; parameter ke 5 dari ReadFile() adalah 0
PUSH dword iBytes ;; parameter ke 4 jumlah byte terbaca
PUSH dword [Buff_len] ;; parameter ke 3 panjang buffer yg disediakan
PUSH dword Buff ;; parameter ke 2 buffer untuk menyimpan
PUSH dword [hStdIn] ;; parameter ke 1 handle stdin
CALL [ReadFile]
mov esi,Buff
mov edi,Buff
sub esi,1
jmp upper
repeat:
add esi,1
add edi,1
mov al,[esi]
cmp al,0
je continue
mov al,[edi]cmp al,0
je continue
mov al,[esi]
cmp al,' '
je upper
mov al,[edi]
cmp al,65
jl repeat
cmp al,90
jg repeat
or al,0x20
mov [edi],al
jmp repeat
upper:
mov al,[edi]
cmp al,97
jl repeat
cmp al,122
jg repeat
and al,0xdf
mov [edi],al
jmp repeat
continue:
;Lanjutan bagian instruksi
;Menampilkan Msg2 ke Console(Monitor) dg WriteFile
PUSH dword 0 ;; parm-5 dari WriteFile() adalah 0
PUSH dword nBytes ;; parm-4 jumlah byte yg tertuliskan
PUSH dword [Buff_len] ;; parm-3 panjang string
PUSH dword Buff ;; parm-2 string yang akan ditampilkan
PUSH dword [hStdOut] ;; parm-1 handle stdout
CALL [WriteFile]
;Lanjutan bagian instruksi
;Menampilkan Buff ke Console(Monitor) dg WriteFile
PUSH dword 0 ;; parm-5 dari WriteFile() adalah 0
PUSH dword iBytes ;; parm-4 jumlah byte yg tertuliskan
PUSH dword [Msg2_len] ;; parm-3 panjang string
PUSH dword Msg2 ;; parm-2 string yang akan ditampilkan
PUSH dword [hStdOut] ;; parm-1 handle stdoutCALL [WriteFile]
;Bagian akhir program
PUSH dword 10000 ;; Tunda tampilan 10 detik
CALL [Sleep]
CALL [FreeConsole] ;; Tutup console
XOR EAX, EAX
PUSH EAX
CALL [ExitProcess] ;; Selesai program
RET
