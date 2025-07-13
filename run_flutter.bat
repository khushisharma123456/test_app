@echo off
cd /d "C:\Users\SONUR\projects\test_app"
echo Current directory: %CD%
echo Checking for pubspec.yaml:
if exist "pubspec.yaml" (
    echo pubspec.yaml found!
    flutter run -d chrome
) else (
    echo pubspec.yaml NOT found!
    dir pubspec.*
)
pause
