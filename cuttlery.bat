@echo off
setlocal enabledelayedexpansion

::read cuts.txt
::FORMAT:

::"filename"                      < in quotes
::(cut1 start),(cut1 lenth)
::(cut2 start),(cut2 lenth)
::...
set itt=0
for /f "tokens=1-2 delims=," %%i  IN (cuts.txt) do (
	if !itt! gtr 0 (
		REM generate cuts
		REM TIME MATH
		REM TIME MATH
		REM TIME MATH
		REM TIME MATH
		REM TIME MATH
		REM inputs
		set a=%%i
		set b=%%j
		echo !a!
		echo !b!
		REM separate data
		set s1=!a:~-2,9999!
		set m1=!a:~-5,-3!
		set h1=!a:~-8,-6!
		set s2=!b:~-2,9999!
		set m2=!b:~-5,-3!
		set h2=!b:~-8,-6!
		REM make sure is defined
		IF NOT DEFINED h1 set h1=0
		IF NOT DEFINED h2 set h2=0
		IF NOT DEFINED m1 set m1=0
		IF NOT DEFINED m2 set m2=0
		IF NOT DEFINED s1 set s1=0
		IF NOT DEFINED s2 set s2=0
		REM diference
		set /a s3=!s2!-!s1!
		set /a m3=!m2!-!m1!
		set /a h3=!h2!-!h1!
		REM convert negatives to time
		if 0 gtr !s3!  (
			set /a s3=60+!s3!
			set /a m3-=1
		)
		if 0 gtr !m3!  (
			set /a m3=60+!m3!
			set /a h3-=1
		)
		REM pad w zeroes
		if 10 gtr !s3!  (
			set s3=0!s3!
		)
		if 10 gtr !m3!  (
			set m3=0!m3!
		)
		if 10 gtr !h3!  (
			set h3=0!h3!
		)
		REM construct time code
		set c=!h3!:!m3!:!s3!
		echo !c!
		REM make clip
		ffmpeg -i !inp! -ss !a! -t !c! -c copy part_!itt!.mp4
		
		REM APPEND TO TXT FILE
		if !itt!==1 (echo file 'part_!itt!.mp4'> parts.txt) else (echo file 'part_!itt!.mp4'>> parts.txt)
	) else (
	    REM read file name
		set inp=%%i
		REM set output name
		set out=!inp:~0,-5![edited]!inp:~-5,-1!
	) 
	
	REM itterate on itt
	set /A itt=!itt!+1
)
::combine cuts
ffmpeg -f concat -i parts.txt -c copy !out!

::cleanup
for /f "tokens=1 delims=," %%i  IN (parts.txt) do (
	set f=%%i
	del !f:~6,-1!
)
del parts.txt


endlocal
pause
exit

