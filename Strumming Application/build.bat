@echo off
copy ..\LICENSE .
copy ..\README.md .
zip -r StrummingApp.zip *
zip -d StrummingApp.zip *.agc *.agk *.bat Source/
mkdir \temp\builds
del /Q \temp\builds\StrummingApp.zip
move StrummingApp.zip \temp\builds