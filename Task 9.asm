%macro importx 2
import %1 %2
extern %1
%endmacro
;; Import the Win32 API functions.
importx GetModuleHandleA, kernel32.dll
importx GetCommandLineA, kernel32.dll
importx ExitProcess, kernel32.dll
importx MessageBoxA, user32.dll
importx LoadIconA, user32.dll
importx LoadCursorA, user32.dll
importx RegisterClassExA, user32.dll
importx CreateWindowExA, user32.dll
importx GetWindowTextA, user32.dll
importx SetWindowTextA, user32.dll
importx SetFocus, user32.dll
importx ShowWindow, user32.dll
importx UpdateWindow, user32.dll
importx GetMessageA, user32.dll
importx SendMessageA, user32.dll
importx TranslateMessage, user32.dll
importx DispatchMessageA, user32.dll
importx PostQuitMessage, user32.dll
importx DefWindowProcA, user32.dll
importx BeginPaint, user32.dll
importx DrawTextA, user32.dll
importx EndPaint, user32.dll
%macro GetModuleHandle 1
push dword 0
call [GetModuleHandleA]mov dword [%1], eax
%endmacro
%macro GetCommandLine 1
call [GetCommandLineA]
mov dword [%1], eax
%endmacro
%macro RegisterClass 4
;
lea ebx, [ebp-48] ;
mov dword [ebx+00], 48 ;
mov dword [ebx+04], 3 ;
mov dword [ebx+08], %4 ;
mov dword [ebx+12], 0 ;
mov dword [ebx+16], 0 ;
mov eax, dword [%3] ;
mov dword [ebx+20], eax ;
mov dword [ebx+32], 5 ;
mov dword [ebx+36], %2 ;
mov dword [ebx+40], %1 ;
push dword 32512 ;
push dword 0
call [LoadIconA]
mov dword [ebx+24], eax
mov dword [ebx+44], eax
push dword 32512
push dword 0
call [LoadCursorA]
mov dword [ebx+28], eax
push ebx
call [RegisterClassExA]%endmacro
%macro CreateWindow 8
push dword 0
push dword [%7]
push dword 0
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
.
mov dword [ebp-76], eax
mov dword [%8], eax
sub eax, 0
jz .new_window_failed
push dword [ebp+20]
push dword [ebp-76]
call [ShowWindow]
push dword [ebp-76]
call [UpdateWindow]
%endmacro
%macro GetMessage 0
push dword 0
push dword 0
push dword 0
lea ebx, [ebp-72]
push ebxcall [GetMessageA]
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
call [CreateWindowExA]
mov [%1],eax
%endmacro
%macro CreateEditBox 7
push dword 0
push dword [hInstance]
push dword %7
push dword [ebp-76]
push dword %6
push dword %5
push dword %4
push dword %3push dword 0x40000000 | 0x10000000
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
%macro GetTextEditBox 4
push word %3
push dword %2
push dword %1
Call [GetWindowTextA]
mov [%4], eax
%endmacro
%macro SetTextEditBox 2
push dword %2
push dword %1
Call [SetWindowTextA]
%endmacro
%macro str2int 1push ebx ;
push esi ;
push edi ;
mov ebx, 0
mov ecx, 0
xor eax,eax
mov ebx,0000000Ah
mov esi, %1
%%ConvertLoop:
movzx ecx,byte [esi] ;Zeichen laden.
test ecx,ecx
jz short %%ExitConvertLoop ;0 => Exit
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
mov edi, %2
%%SortDec:
pop eaxstosb
loop %%SortDec
mov eax, 0h
stosb
pop edi
pop esi
pop ebx
%endmacro
