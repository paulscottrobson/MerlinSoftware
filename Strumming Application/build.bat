@echo off
zip -r StrummingApp.zip *
zip -d StrummingApp.zip *.agc *.agk *.bat Source/
del /Q ..\builds\StrummingApp.zip
move StrummingApp.zip ..\builds