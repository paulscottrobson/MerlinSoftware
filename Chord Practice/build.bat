@echo off
copy ..\LICENSE .
copy ..\README.md .
zip -r ChordApp.zip *
zip -d ChordApp.zip *.agc *.agk *.bat Source/
mkdir \temp\builds
del /Q \temp\builds\ChordApp.zip
move ChordApp.zip \temp\builds