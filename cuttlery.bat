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
		::generate cuts
		set start=%%i
		set end=%%j
		ffmpeg -i !inp! -ss !start! -t !end! -c copy part_!itt!.mp4
		
		::APPEND TO TXT FILE
		if !itt!==1 (echo file 'part_!itt!.mp4'> parts.txt) else (echo file 'part_!itt!.mp4'>> parts.txt)
	) else (
	    ::read file name
		set inp=%%i
		::set output name
		set out=!inp:~0,-5![edited]!inp:~-5,-1!
	) 
	
	::itterate on itt
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

