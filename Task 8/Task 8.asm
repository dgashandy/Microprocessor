%Include "Calculator.inc"
WM_CREATE equ 1h
WM_DESTROY equ 2h
WM_COMMAND equ 0111h
BN_CLICKED equ 0h
EditID1 equ 1111
EditID2 equ 1112
EditID3 equ 1113
EditID4 equ 1114
ButtonID0 equ 2220
ButtonID1 equ 2221
ButtonID2 equ 2222
ButtonID3 equ 2223
ButtonID4 equ 2224
section .data
ClassName db "Calculator", 0
TitleBar db "simple_calculator", 0
TitlemBox db "result", 0TitleExit db "finish", 0
ExitBox db "Exit", 0
EditClassName db "Edit", 0
EditText db "", 0
LblClassName db "Static", 0
LabelText1 db "1st Number : ", 0
LabelText2 db "2nd Number : ", 0
LabelText3 db "Result : ", 0
LabelText4 db "Remainder : ", 0
ButtonClassName db "Button", 0
ButtonText0 db "+", 0
ButtonText1 db "-", 0
ButtonText2 db "*", 0
ButtonText3 db "/", 0
ButtonText4 db "EXIT", 0
DefaultValue db "0", 0
err_msg db "Fail create Window. ", 0
buff1 times 128 db 0
buff2 times 128 db 0
blen1 resw 1
blen2 resw 1
bufferA times 1024 db 0
shaSIl1 resb 512
shaSIl2 resb 512
strminus db "-"
strcopy resb 512
section .bss
hInstance resd 1
CommandLine resd 1
hWind resd 1
hwndButton0 resd 1
hwndButton1 resd 1
hwndButton2 resd 1
hwndButton3 resd 1hwndButton4 resd 1
hwndEdit1 resd 1
hwndEdit2 resd 1
hwndEdit3 resd 1
hwndEdit4 resd 1
hwndLbl1 resd 1
hwndLbl2 resd 1
hwndLbl3 resd 1
hwndLbl4 resd 1
nhaSIl1 dd 0
nhaSIl2 dd 0
;=====================================================================
=====================================
section .text use32
..start:
GetModuleHandle
GetCommandLine
PUSH dword 10
PUSH dword [CommandLine]
PUSH dword 0
PUSH dword [hInstance]
CALL WindowMain
PUSH EAX
CALL [ExitProcess]
;=====================================================================
==================================================
WindowMain:
ENTER 76, 0
RegisterClass
CreateWindow ClassName, TitleBar, 500, 150, 500, 400
CreateLabel hwndLbl1, LabelText1, 20, 35, 110, 25
CreateLabel hwndLbl2, LabelText2, 20, 65, 110, 25
CreateLabel hwndLbl3, LabelText3, 20, 95, 110, 25
CreateLabel hwndLbl4, LabelText4, 20, 125, 110, 25
CreateEditBox hwndEdit1, EditText, 135, 35, 270, 25, EditID1CreateEditBox hwndEdit2, EditText, 135, 65, 270, 25, EditID2
CreateEditBox hwndEdit3, EditText, 135, 95, 270, 25, EditID3
CreateEditBox hwndEdit4, EditText, 135, 125, 270, 25, EditID4
CreateButton hwndButton0, ButtonText0, 135, 170, 25, 25, ButtonID0
CreateButton hwndButton1, ButtonText1, 165, 170, 25, 25, ButtonID1
CreateButton hwndButton2, ButtonText2, 195, 170, 25, 25, ButtonID2
CreateButton hwndButton3, ButtonText3, 225, 170, 25, 25, ButtonID3
CreateButton hwndButton4, ButtonText4, 255, 170, 50, 25, ButtonID4
PUSH dword [hwndEdit1]
CALL [SetFocus]
.MessageLoop:
GetMessage
CMP EAX, 0
JZ .MessageLoopExit
TranslateMsg
DispatchMsg
JMP .MessageLoop
.MessageLoopExit:
JMP .finish
.new_window_failed:
PUSH dword 0
PUSH dword 0
PUSH dword err_msg
PUSH dword 0
CALL [MessageBoxA]
MOV EAX, 1
LEAVE
RET 16
.finish:lea EBX, [EBP-72]
MOV EAX, dword [EBX+08]
LEAVE
RET 16
WindowProcedure:
ENTER 0, 0
MOV EAX, dword [EBP+12]
CMP EAX, WM_DESTROY
JZ .window_destroy
CMP EAX, WM_COMMAND
JNZ .window_default
MOV EAX, dword [EBP+16]
.CheckButton4:
CMP EAX, ButtonID4
JNZ .CheckButton0
CALL mBoxKonfirmaSI
SHR EAX, 16
CMP EAX, BN_CLICKED
JZ .window_destroy
JMP .window_default
.CheckButton0:
CMP EAX, ButtonID0
JNZ .CheckButton1
SHR EAX, 16
CMP EAX, BN_CLICKED
JNZ .window_default
GetTextEditBox [hwndEdit1], buff1, 128, blen1
GetTextEditBox [hwndEdit2], buff2, 128, blen2
str2int buff1
MOV [buff1],EAX
str2int buff2
MOV [buff2],EAXMOV EAX, [buff1]
MOV EBX, [buff2]
ADD EAX,EBX
MOV [nhaSIl1], EAX
int2str [nhaSIl1], shaSIl1
SetTextEditBox [hwndEdit3], shaSIl1
SetTextEditBox [hwndEdit4], DefaultValue
.CheckButton1:
CMP EAX, ButtonID1
JNZ .CheckButton2
SHR EAX, 16
CMP EAX, BN_CLICKED
JNZ .window_default
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
MOV [nhaSIl2],EAX
int2str [nhaSIl2], shaSIl2
SetTextEditBox [hwndEdit3], shaSIl2
SetTextEditBox [hwndEdit4], DefaultValue
.CheckButton2:
CMP EAX, ButtonID2
JNZ .CheckButton3
SHR EAX, 16
CMP EAX, BN_CLICKEDJNZ .window_default
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
MOV [nhaSIl1], EAX
int2str [nhaSIl1], shaSIl1
SetTextEditBox [hwndEdit3], shaSIl1
SetTextEditBox [hwndEdit4], DefaultValue
.CheckButton3:
CMP EAX, ButtonID3
JNZ .window_default
SHR EAX, 16
CMP EAX, BN_CLICKED
JNZ .window_default
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
MOV [nhaSIl2], EAX
MOV [nhaSIl1], EDX
int2str [nhaSIl2], shaSIl2SetTextEditBox [hwndEdit3], shaSIl2
int2str [nhaSIl1],shaSIl1
SetTextEditBox [hwndEdit4], shaSIl1
JMP .window_default
.window_destroy:
PUSH dword 0
CALL [PostQuitMessage]
JMP finish
.window_default:
PUSH dword [EBP+20]
PUSH dword [EBP+16]
PUSH dword [EBP+12]
PUSH dword [EBP+08]
CALL [DefWindowProcA]
LEAVE
RET 16
.balik:
SUB EBX,EAX
MOV [nhaSIl2],EBX
int2str [nhaSIl2],strcopy
SetTextEditBox [hwndEdit3], strminus
RET
mBoxKonfirmaSI:
PUSH dword 20H
PUSH dword TitleExit
PUSH dword ExitBox
PUSH dword [hWind]
CALL [MessageBoxA]
RET
finish:
XOR EAX, EAX
LEAVE
RET 16
