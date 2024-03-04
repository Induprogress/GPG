@echo off

IF %1.==. GOTO BadParam
IF %2.==. GOTO BadParam

echo Script name: %~nx0
echo Użytkownik : %1
echo KeyID      : %2
echo.

IF        "%3%"=="" (
  call :KeyExport %1 %2
  call :GitIntegrate %1 %2
) ELSE IF "%3%"=="export" (
  call :KeyExport %1 %2

) ELSE IF "%3%"=="git" (
  call :GitIntegrate %1 %2

) ELSE (
	echo Niewłasciwy parametr %3
    GOTO BadParam
)


GOTO End1

rem 
:KeyExport
  echo export kluczy
  gpg --armor --export-secret-key -o %1_privateKey.asc %2
  gpg --armor --export -o %1_publicKey.asc %2 
  echo W notatniku otwarto plik którego treść należy wkleić w 
  echo https://github.com/settings/gpg/new
  start notepad %1_publicKey.asc
  exit /B
rem
:GitIntegrate
  echo Ustawianie konfiguracji git (user.signingkey %2)
  git config --global user.signingkey %2
  git config --global commit.gpgsign true
  git config --global tag.gpgsign true
  exit /B

:BadParam
  ECHO skrypt integrujący z gitem 
  ECHO Użycie  : %~nx0 nazwaUżytkownika KeyID
  ECHO Przykład: %~nx0 jkowalski ABCDEFGHIJKLMNOP
  ECHO  Możliwy dodatkowy parametr
  ECHO   export - tylko exportuje klucze do plików
  ECHO   git    - jedynie ustawia automatyczne podpisywanie commitów i tagów wybranym kluczem
  ECHO. 
  ECHO Skrypt exportuje pliki kluczy: prywatny oraz publiczny do plików
  ECHO Konfiguruje git aby domyślnie podpisywał wszystkie commity i tagi podanym kluczem GPG
  ECHO.
  ECHO W przypadku braku któregokolwiek parametru wyświetla listę dostępnych kluczy.
  ECHO. 
  ECHO Lista dostępnych kluczy:
  gpg --list-secret-keys --keyid-format=long %1
GOTO End1

:End1