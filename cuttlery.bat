@echo off
setlocal enabledelayedexpansion

::read cuts.txt
::FORMAT:

::FILE;"filename"			 | origin file

::NAME;clip name			 | clip name
::CLIP;00:00:00,00:00:00	 | start and end time
::CLIP;00:00:00,00:00:00	 | start and end time

::NAME;clip name			 | clip name
::CLIP;00:00:00,00:00:00	 | start and end time
::CLIP;00:00:00,00:00:00	 | start and end time


::each name can have several clips
::there can be several name 




::clean up
if exist parts.txt (
	del parts.txt
)
::predefine some vars
set itt=0
set nm=x

::loop though cuts.txt
for /f "tokens=1-2 delims=;" %%r  IN (cuts.txt) do (
	REM split up line into definor r(FILE, NAME, CLIP) and data s(timecodes, names etc):
	
	
	echo %%r
	echo %%s
	
	if %%r == CLIP (
		REM generate cuts
		REM cuts s into start and end clip, and them ffmpegs them into part_x.mp4 and adds them to parts.txt file
		for /f "tokens=1-2 delims=," %%i  IN ("%%s") do (
		
		
		REM TIME MATH

		REM inputs
		set a=%%i
		set b=%%j

		echo !a!
		echo !b!
		echo !k!
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
		
		REM echo !s3!,!m3!,!h3!
		REM echo !s2!,!m2!,!h2!
		REM echo !s1!,!m1!,!h1!

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
			set /a s3=!s3!
			set s3=0!s3!
		)
		if 10 gtr !m3!  (
			set /a m3=!m3!
			set m3=0!m3!
		)
		if 10 gtr !h3!  (
			set /a h3=!h3!
			set h3=0!h3!
		)
		REM construct time code
		set c=!h3!:!m3!:!s3!
		echo !c!
		echo ------
		REM make clip
		ffmpeg -i !inp! -ss !a! -t !c! -c copy part_!itt!.mp4
		
		REM APPEND TO TXT FILE
		if exist parts.txt (echo file 'part_!itt!.mp4'>> parts.txt)	else (echo file 'part_!itt!.mp4'> parts.txt)  

		REM ffmpeg -i !inp! -ss !a! -t !c! -c copy !q!.mp4
		set /A itt=!itt!+1
		echo ------
		)
		
		
	) else if %%r == NAME (
		REM sets the name of the clip, if there already is a clip, that clip is saved before start on next clip
		if exist parts.txt (
			REM if name exists: save
			::combine cuts
			ffmpeg -f concat -i parts.txt -c copy "!nm!.mp4"

			::cleanup
			for /f "tokens=1 delims=," %%i  IN (parts.txt) do (
				set f=%%i
				del !f:~6,-1!
			)
			del parts.txt
		)
		
		set /A itt=0
		set nm=%%s
		
	) else if %%r == FILE (
		REM sets input file
		set inp=%%s
	)


)

REM to avoid needing an extra name or end in the cuts file we make sure to save the last clip anyways
if exist parts.txt (
	::combine cuts
	ffmpeg -f concat -i parts.txt -c copy "!nm!.mp4"

	::cleanup
	for /f "tokens=1 delims=," %%i  IN (parts.txt) do (
		set f=%%i
		del !f:~6,-1!
	)
	del parts.txt
)

endlocal
pause
exit


