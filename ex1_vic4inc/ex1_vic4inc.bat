..\..\..\kickass.jar  -vicesymbols -showmem  -bytedump ex1_vic4inc.asm -odir ..\..\bin
rem ..\..\..\xemu_future\xmega65.exe -besure -prgmode 65 -prg ..\..\bin\ex1_vic4inc.prg
"..\..\..\..\M65Connect\M65Connect Resources\m65.exe" -l COM4 -F -r -1 ..\..\bin\ex1_vic4inc.prg