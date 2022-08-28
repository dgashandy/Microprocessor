;Deklarasi File Eksternal
%INCLUDE 'Console.API'%INCLUDE 'Console.MAC'
;Deklarasi variabel dg data awal tertentu
SEGMENT .DATA USE32
Judul db "TUGAS 4 MIKROPROSESOR KOM-B",0
Msg1 db 13,10,"Tulis Kalimat : "
Msg1_len dd $-Msg1
Msg2 db 13,10,"Tunggu 10 detik..........",13,10,0
Msg2_len dd $-Msg2
Msg3 db 13,10,"Anda menulis : "
Msg3_len dd $-Msg3
Msg4 db 13,10,"Panjang String Kalimat Anda: ",
Msg4_len dd $-Msg4,
Msg5 db 13,10,"Jumlah Kata Kalimat Anda: "
Msg5_len dd $-Msg5
Buff times 255 db 13
Buff_len dd $-Buff
KATA times 255 db 13
KATA_len dd $-KATA
;Lanjutan contoh program
;Deklarasi variabel tanpa data awal
SEGMENT .BSS USE32
hStdOut resd 1
hStdIn resd 1
nBytes resd 1
iBytes resd 1
;Bagian instruksi
SEGMENT .CODE USE32
..start:
BuatConsole Judul, hStdIn, hStdOut
TampilkanTeks hStdOut, Msg1, Msg1_len, nBytes
BacaTeks hStdIn, Buff, Buff_len, iBytes
TampilkanTeks hStdOut, Msg3, Msg3_len, nBytesTampilkanTeks hStdOut, Buff, iBytes, nBytes
TampilkanTeks hStdOut, Msg4, Msg4_len, nBytes
JumlahLen Buff, KATA
TampilkanTeks hStdOut, KATA, KATA_len, nBytes
TampilkanTeks hStdOut, Msg5, Msg5_len, nBytes
JumlahKata Buff, KATA
TampilkanTeks hStdOut, KATA, KATA_len, nBytes
TampilkanTeks hStdOut, Msg2, Msg2_len, nBytes
TutupConsole 10
ret
