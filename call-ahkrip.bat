ECHO OFF
REM For this batch to work, Ahk2exe must be in your %PATH%.

SET CURRDIR=%CD%
SET CURRDRIVE=%cd:~0,2%

REM REBUILD TARGETS
ECHO OFF
FOR %%A IN (%CURRDIR%\*.ahk) DO (
ahkrip.bat %%~nA
%CURRDRIVE%
CD %CURRDIR%
)