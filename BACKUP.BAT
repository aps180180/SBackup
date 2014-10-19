DEL *.GBK /Q
CD\ARQUIVOS DE PROGRAMAS\FIREBIRD\FIREBIRD_2_1\bin\
SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey
gbak -backup -v -y c:\backup.log localhost:D:\tolentino\iecf.fdb c:\backup\iecf.fbk
