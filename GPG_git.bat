@echo off

IF %1.==. GOTO BadParam
IF %2.==. GOTO BadParam

echo Script name: %0
echo Użytkownik : %1
echo KeyID      : %2
echo.
echo export kluczy
gpg --armor --export -o %1_publicKey.asc %2 
gpg --armor --export-secret-key -o %1_privateKey.asc %2
echo Ustawianie konfiguracji git (user.signingkey %2)
git config --global user.signingkey %2
git config --global commit.gpgsign true
git config --global tag.gpgsign true
echo W notatniku otwarto plik którego treść należy wkleić w 
echo https://github.com/settings/gpg/new
notepad %1_publicKey.asc

GOTO End1

:BadParam
  ECHO skrypt integrujący z gitem 
  ECHO Użycie  : %0 nazwaUżytkownika KeyID
  ECHO Przykład: %0 jkowalski ABCDEFGHIJKLMNOP
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