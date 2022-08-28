extern GetStdHandle
extern WriteFile
extern ReadFile
extern AllocConsole
extern FreeConsole
extern SetConsoleTitleA
extern Sleep
extern ExitProcess
import GetStdHandle kernel32.dll
import WriteFile kernel32.dll
import ReadFile kernel32.dll
import AllocConsole kernel32.dll
import FreeConsole kernel32.dll
import SetConsoleTitleA kernel32.dll
import Sleep kernel32.dll
import ExitProcess kernel32.dll
%macro initconsole 3
CALL [AllocConsole]
PUSH dword %1
CALL [SetConsoleTitleA]
PUSH dword -10
CALL [GetStdHandle]
MOV dword [%2], EAX
PUSH dword -11
CALL [GetStdHandle]
MOV dword [%3], EAX
%endmacro
%macro quitconsole 0
CALL [FreeConsole]
XOR EAX,EAX
PUSH EAX
CAll [ExitProcess]
%endmacro%macro TampilkanTeks 4
push dword 0
push dword %4
push dword [%3]
push dword %2
push dword [%1]
call [WriteFile]
%endmacro
%macro BacaTeks 4
push dword 0
push dword %4
push dword [%3]
push dword %2
push dword [%1]
call [ReadFile]
%endmacro
