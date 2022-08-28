%include "tugas9.Inc"
WWM_CREATE equ 1h
WM_DESTROY equ 2h
WM_COMMAND equ 0111h
BN_CLICKED equ 0h
EditID1 equ 1111
EditID2 equ 1112
EditID3 equ 1113
EditID4 equ 1114
IDM_TAMBAH equ 1
IDM_KURANG equ 2
IDM_KALI equ 3
IDM_BAGI equ 4
IDM_KELUAR equ 5
[SEGMENT .DATA USE32]
ClassName db "MenuClass",0
TitleBar db "Kalkulator Sederhana", 0
MenuName db "WMenu9",0
;TitlemBox db "Data Tersimpan",0
TitleExit db "SELESAI",0
ExitBox db "Keluar?",0
EditClassName db "Edit",0 ;
EditText db "",0
LblClassName db "Static", 0 ;
LabelText1 db "Bil 1 : ", 0LabelText2 db "Bil 2 : ", 0
LabelText3 db "Hasil : ", 0
LabelText4 db "Sisa : ", 0
DefaultValue db "0", 0
err_msg db "Fail create Window. ", 0
buff1 times 128 db 0
buff2 times 128 db 0
blen1 resw 1
blen2 resw 1
bufferA times 1024 db 0
strhasil1 resb 512
strhasil2 resb 512
strminus db "-"
strcopy resb 512
[SEGMENT .BSS USE32]
hInstance resd 1
CmdLine resd 1
hWind resd 1
hwndEdit1 resd 1
hwndEdit2 resd 1
hwndEdit3 resd 1
hwndEdit4 resd 1
hwndLbl1 resd 1
hwndLbl2 resd 1
hwndLbl3 resd 1
hwndLbl4 resd 1
varhasil1 dd 0
varhasil2 dd 0
;================================================================
==========================================
[SEGMENT .CODE USE32]
..start:
GetModuleHandle hInstance
GetCommandLine CmdLine
;
push dword 10 ;
push dword [CmdLine] ;push dword 0 ;
push dword [hInstance] ;
call WindowMain ;
push eax ;
call [ExitProcess] ;
;================================================================
==========================================
;WindowMain() function.
WindowMain:
enter 76, 0
RegisterClass ClassName, MenuName, hInstance, WMenuProc
CreateWindow ClassName, TitleBar, 300, 150, 500, 270, hInstance,
hWind
CreateLabel hwndLbl1, LabelText1, 20, 40, 110, 25
CreateLabel hwndLbl2, LabelText2, 20, 70, 110, 25
CreateLabel hwndLbl3, LabelText3, 20, 100, 110, 25
CreateLabel hwndLbl4, LabelText4, 20, 130, 110, 25
CreateEditBox hwndEdit1, EditText, 135, 40, 270, 25, EditID1
CreateEditBox hwndEdit2, EditText, 135, 70, 270, 25, EditID2
CreateEditBox hwndEdit3, EditText, 135, 100, 270, 25, EditID3
CreateEditBox hwndEdit4, EditText, 135, 130, 270, 25, EditID4
push dword [hwndEdit1]
call [SetFocus]
.MessageLoop:
GetMessage
cmp eax, 0 ;
jz .MessageLoopExit
TranslateMsg
DispatchMsg
jmp .MessageLoop ;
.MessageLoopExit:
jmp .finish ;.new_window_failed:
push dword 0 ;
push dword 0
push dword err_msg
push dword 0
call [MessageBoxA]
mov eax, 1 ;
leave
ret 16
.finish:
lea ebx, [ebp-72] ;
mov eax, dword [ebx+08]
;
leave
ret 16
WMenuProc:
enter 0, 0 ;
mov eax, dword [ebp+12] ;
cmp eax, WM_DESTROY ;
jz .window_destroy ;
cmp eax, WM_COMMAND ;
jnz .window_default
mov eax, dword [ebp+16] ;
cmp eax, IDM_TAMBAH
jz .tambah_data
cmp eax, IDM_KURANG
jz .kurang_data
cmp eax, IDM_KALI
jz .kali_data
cmp eax, IDM_BAGI
jz .bagi_data
cmp eax, IDM_KELUAR ;
jne .window_default ;
call mBoxKonfirmasijmp .window_destroy
.tambah_data:
GetTextEditBox [hwndEdit1], buff1, 128, blen1
GetTextEditBox [hwndEdit2], buff2, 128, blen2
str2int buff1
MOV [buff1],EAX
str2int buff2
MOV [buff2],EAX
MOV EAX, [buff1]
MOV EBX, [buff2]
ADD EAX,EBX
MOV [varhasil1], EAX
int2str [varhasil1], strhasil1
SetTextEditBox [hwndEdit3], strhasil1
SetTextEditBox [hwndEdit4], DefaultValue
leave
ret 16
.kurang_data:
GetTextEditBox [hwndEdit1], buff1, 128, blen1
GetTextEditBox [hwndEdit2], buff2, 128, blen2
str2int buff1
MOV [buff1], EAX
str2int buff2
MOV [buff2], EAX
MOV EAX, [buff1]
MOV EBX, [buff2]
CMP EAX,EBX
JL .balik
SUB EAX,EBX
MOV [varhasil2],EAX
int2str [varhasil2], strhasil2
SetTextEditBox [hwndEdit3], strhasil2
SetTextEditBox [hwndEdit4], DefaultValue
leave
ret 16.kali_data:
GetTextEditBox [hwndEdit1], buff1, 128, blen1
GetTextEditBox [hwndEdit2], buff2, 128, blen2
str2int buff1
MOV [buff1], EAX
str2int buff2
MOV [buff2], EAX
MOV EAX, [buff1]
MOV ESI, [buff2]
XOR EDX, EDX
MUL SI
MOV [varhasil1], EAX
int2str [varhasil1], strhasil1
SetTextEditBox [hwndEdit3], strhasil1
SetTextEditBox [hwndEdit4], DefaultValue
leave
ret 16
.bagi_data:
GetTextEditBox [hwndEdit1], buff1, 128, blen1
GetTextEditBox [hwndEdit2], buff2, 128, blen2
str2int buff1
MOV [buff1], EAX
str2int buff2
MOV [buff2], EAX
MOV EAX, [buff1]
MOV ESI, [buff2]
XOR EDX, EDX
DIV SI
MOV [varhasil2], EAX
MOV [varhasil1], EDX
int2str [varhasil2], strhasil2
SetTextEditBox [hwndEdit3], strhasil2
int2str [varhasil1],strhasil1
SetTextEditBox [hwndEdit4], strhasil1
leave
ret 16.window_destroy:
push dword 0
call [PostQuitMessage]
jmp .window_finish
.window_default:
push dword [ebp+20]
push dword [ebp+16]
push dword [ebp+12]
push dword [ebp+08]
call [DefWindowProcA]
leave ;
ret 16 ;
.window_finish:
xor eax, eax
leave
ret 16
.balik:
SUB EBX,EAX
MOV [varhasil2],EBX
int2str [varhasil2],strcopy
SetTextEditBox [hwndEdit3], strminus
RET
mBoxKonfirmasi:
push dword 20H ;
push dword TitleExit ;
push dword ExitBox ;
push dword [hWind] ;
call [MessageBoxA]
ret
; -- end of file
