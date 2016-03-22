@echo off
copy ..\LICENSE .
copy ..\README.md .
zip -r ChordApp.zip *
zip -d ChordApp.zip *.agc *.agk *.bat Source/
del /Q ..\builds\ChordApp.zip
move ChordApp.zip ..\builds