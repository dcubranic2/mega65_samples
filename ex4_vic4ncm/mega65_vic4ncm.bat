..\..\..\kickass.jar  -vicesymbols -showmem  -bytedump -log "logfile.txt" mega65_vic4ncm.asm -odir ..\..\bin
rem ..\..\..\..\xemu_future\xmega65.exe -besure -prgmode 65 -prg ..\..\bin\mega65_vic4ncm.prg
"..\..\..\..\M65Connect\M65Connect Resources\m65.exe" -l COM4 -F -r -1 ..\..\bin\mega65_vic4ncm.prg
del *.png
"..\..\..\..\M65Connect\M65Connect Resources\m65.exe" -l COM4 -S