@echo off
if "%1" == "" goto :usage

rem set "JAVA_HOME=C:\Program Files\Java\jdk1.7.0_45"
rem set "JAVA_HOME=C:\Program Files\Java\jdk1.7.0_10"
rem set "JAVA_HOME=C:\Program Files\Java\jdk1.8.0_25"
rem set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 7.0"
rem set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 8.0"
if "%1" == "x86" goto :w32 
if "%2" == "12" goto :v12
if "%2" == "10" goto :v10

call "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" %1
goto :compile

:v10
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" %1
goto :compile

:v12
call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" %1
goto :compile

:w32
call "C:\Program Files\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" %1
goto :compile

:compile
cl /I"%JAVA_HOME%\include" /I"%JAVA_HOME%\include\win32" /O2 /Oi /GL /DWIN32 /DNDEBUG /D_WINDOWS /D_USRDLL /DBRACMATDLL_EXPORTS /D_WINDLL /MT /Gy /Gd bracmatdll.cpp bracmatso.c dk_cst_bracmat.c json.c xml.c /link /OUT:"bracmat.dll" /DLL /OPT:REF /OPT:ICF /MACHINE:%1

cd java
javac ./dk/cst/*.java
jar cfv bracmat.jar dk/cst/bracmat.class
javac -classpath bracmat.jar ./bracmattest.java
java -D"java.library.path=../" -classpath bracmat.jar;. bracmattest
copy bracmat.jar "%CATALINA_HOME%\lib\bracmat.jar"
cd ..

move bracmat.dll "%CATALINA_HOME%\bin\bracmat.dll"
goto :eof

:usage
echo Options required: x86 or x64 and 9, 10 or 12
goto :eof