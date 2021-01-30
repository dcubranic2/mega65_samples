..\..\..\kickass.jar  -vicesymbols -showmem  -bytedump mega65_vic4.asm -odir ..\..\bin
rem ..\..\..\..\xemu_future\xmega65.exe -besure -prgmode 65 -prg ..\..\bin\mega65_vic4.prg
"..\..\..\..\M65Connect\M65Connect Resources\m65.exe" -l COM4 -F -r ..\..\bin\mega65_vic4.prg