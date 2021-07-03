@echo off
setlocal enabledelayedexpansion
::inputs
set a=23:07
set b=17:15:12
::separate data
set s1=%a:~-2,9999%
set m1=%a:~-5,-3%
set h1=%a:~-8,-6%
set s2=%b:~-2,9999%
set m2=%b:~-5,-3%
set h2=%b:~-8,-6%
::make sure is defined
IF NOT DEFINED h1 set h1=0
IF NOT DEFINED h2 set h2=0
IF NOT DEFINED m1 set m1=0
IF NOT DEFINED m2 set m2=0
IF NOT DEFINED s1 set s1=0
IF NOT DEFINED s2 set s2=0
::diference
set /a s3=%s2%-%s1%
set /a m3=%m2%-%m1%
set /a h3=%h2%-%h1%
::convert negatives to time
if 0 gtr !s3!  (
	set /a s3=60+!s3!
	set /a m3-=1
)
if 10 gtr !m3!  (
	set /a m3=60+!m3!
	set /a h3-=1
)
::pad w zeroes
if 10 gtr !s3!  (
	set s3=0!s3!
)
if 10 gtr !m3!  (
	set m3=0!m3!
)
if 10 gtr !h3!  (
	set h3=0!h3!
)
::construct time code
set c=!h3!:!m3!:!s3!
echo !c!
endlocal
pause