%macro macro_import 2
import %1 %2
extern %1
%endmacro
;; Import the Win32 API functions.
macro_import GetModuleHandleA, kernel32.dll
macro_import GetCommandLineA, kernel32.dll
macro_import ExitProcess, kernel32.dll
macro_import MessageBoxA, user32.dll
macro_import LoadIconA, user32.dll
macro_import LoadCursorA, user32.dll
macro_import RegisterClassExA, user32.dll
macro_import CreateWindowExA, user32.dll
macro_import ShowWindow, user32.dll
macro_import UpdateWindow, user32.dll
macro_import GetMessageA, user32.dll
macro_import TranslateMessage, user32.dll
macro_import DispatchMessageA, user32.dll
macro_import PostQuitMessage, user32.dll
macro_import DefWindowProcA, user32.dll
macro_import SetFocus, user32.dll
macro_import GetWindowTextA, user32.dll
macro_import SetWindowTextA, user32.dll
macro_import SendMessageA, user32.dll
macro_import BeginPaint, user32.dll
macro_import DrawTextA, user32.dll
macro_import EndPaint, user32.dll
%macro GetModuleHandle 0
push dword 0
call [GetModuleHandleA]mov dword [hInstance], eax
%endmacro
%macro GetCommandLine 0
call [GetCommandLineA]
mov dword [CommandLine], eax
%endmacro
%macro RegisterClass 0
lea ebx, [ebp-48]
mov dword [ebx+00], 48
mov dword [ebx+04], 3
mov dword [ebx+08], WindowProcedure
mov dword [ebx+12], 0
mov dword [ebx+16], 0
mov eax, dword [ebp+8]
mov dword [ebx+20], eax
mov dword [ebx+32], 5
mov dword [ebx+36], 0
mov dword [ebx+40], ClassName
push dword 32512
push dword 0
call [LoadIconA]
mov dword [ebx+24], eax
mov dword [ebx+44], eax
push dword 32512
push dword 0
call [LoadCursorA]
mov dword [ebx+28], eax
push ebx
call [RegisterClassExA]
%endmacro
%macro CreateWindow 6
push dword 0
push dword [ebp+8]push dword 0
push dword 0
push dword %6
push dword %5
push dword %4
push dword %3
push dword 0x00 | 0xC00000 | 0x80000 | 0x20000 | 0x10000 | 0x40000
push dword %2
push dword %1
push dword 0000200h
call [CreateWindowExA]
mov dword [ebp-76], eax
mov dword [hWind], eax
sub eax, 0
push dword [ebp+20]
push dword [ebp-76]
call [ShowWindow]
push dword [ebp-76]
call [UpdateWindow]
%endmacro
%macro CreateLabel 6
push dword 0
push dword [hInstance]
push dword 0
push dword [ebp-76]
push dword %6
push dword %5
push dword %4
push dword %3
push dword 0x40000000 | 0x10000000 | 0x0000000B
push dword %2
push dword LblClassName
push dword 00000200h
call [CreateWindowExA]mov [%1],eax
%endmacro
%macro CreateEditBox 7
push dword 0
push dword [hInstance]
push dword %7
push dword [ebp-76]
push dword %6
push dword %5
push dword %4
push dword %3
push dword 0x40000000 | 0x10000000
push dword %2
push dword EditClassName
push dword 00000200h
call [CreateWindowExA]
mov [%1],eax
%endmacro
%macro CreateButton 7
push dword 0
push dword [hInstance]
push dword %7
push dword [ebp-76]
push dword %6
push dword %5
push dword %4
push dword %3
push dword 0x40000000 | 0x10000000 | 0x1
push dword %2
push dword ButtonClassName
push dword 0
call [CreateWindowExA]
mov [%1],eax
%endmacro
%macro GetMessage 0
push dword 0
push dword 0push dword 0
lea ebx, [ebp-72]
push ebx
call [GetMessageA]
%endmacro
%macro TranslateMsg 0
lea ebx, [ebp-72]
push ebx
call [TranslateMessage]
%endmacro
%macro DispatchMsg 0
lea ebx, [ebp-72]
push ebx
call [DispatchMessageA]
%endmacro
;int GetWindowTextA(
; HWND hWnd,
; LPSTR lpString,
; int nMaxCount
;)
%macro GetTextEditBox 4
push word %3
push dword %2
push dword %1
Call [GetWindowTextA]
mov [%4], eax
%endmacro
;BOOL SetWindowTextA(
; HWND hWnd,
; LPCSTR lpString
;);
%macro SetTextEditBox 2
push dword %2
push dword %1
Call [SetWindowTextA]
%endmacro%macro str2int 1
push ebx ;
push esi ;
push edi ;
mov ebx, 0
mov ecx, 0
xor eax,eax
mov ebx,0000000Ah
mov esi, %1
%%ConvertLoop:
movzx ecx,byte [esi]
test ecx,ecx
jz short %%ExitConvertLoop
inc esi
sub cl,30h ;0-9...
mul ebx ;Ergebnis * 10
add eax,ecx ;+ nächste Ziffer
jmp short %%ConvertLoop
%%ExitConvertLoop:
pop edi
pop esi
pop ebx
%endmacro
%macro int2str 2
push ebx ;
push esi ;
push edi ;
%%start:
mov eax, %1
xor ecx, ecx
mov ebx, 000Ah
%%DecConvert:
xor edx, edx
div ebx
add edx, 0030h
push edx
inc ecx
or eax, eax
jnz short %%DecConvert
mov edi, %2%%SortDec:
pop eax
stosb
loop %%SortDec
mov eax, 0h
stosb
pop edi
pop esi
pop ebx
%endmacro
;LRESULT SendMessageA(
; HWND hWnd,
; UINT Msg,
; WPARAM wParam,
; LPARAM lParam
;);
