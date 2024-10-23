@echo off
title ftool-extractor v0.9

rem  _________________                     ____   ____   ____           __________
rem |__|__|__|__|__|__|                   |    | |    | |    |         |          |
rem |                 |                   |____| |____| |____|         |          |
rem |       |\        |   ___________|\    ____   ____   ____          |          |
rem |       | \       |  |             \  |    | |    | |    |         |          |
rem |       | /       |  |___________| /  |____| |____| |____|    ____ |     ____ |
rem |       |/        |              |/    ____   ____   ____    /    \|    /    \|
rem |_________________|                   |    | |    | |    |  |      |   |      |
rem |__|__|__|__|__|__|                   |____| |____| |____|   \____/     \____/

rem -------------------Information-------------------

rem This script extracts image sequences and audio tracks from videos
rem Usage: drag and drop videos/folders onto the .bat file and wait till extracting is finished

rem Made by Rikki: https://www.youtube.com/@shy_rikki
rem Source: https://github.com/eirisocherry/ftools

rem -------------------Settings-------------------

rem Extract image sequence?
rem 0: no
rem 1: yes
set image_sequence=1

rem Image format
rem png: lossless/uncompressed (8-bit)
rem jpeg: compressed
rem tiff: uncompressed (16-bit)
set image_format=png

rem Remove duplicate frames?
rem 0: no
rem 1: yes (identical frames will be deleted)
set remove_duplicate_frames=1

rem Choose a resolution (use only even numbers to avoid problems 1920:815 is bad, 1920:816 is good)
rem set resolution=0 -> don't change
rem set resolution=1280:720 -> set to 1280:720
rem set resolution=1920:1080 -> set to 1920:1080
rem etc...
set resolution=0

rem -------------------

rem Extract audio tracks?
rem 0: no
rem 1: yes
set audio_tracks=1

rem Audio format
rem wav: uncompressed (huge size, original quality)
rem flac: lossless (medium size, original quality)
rem mp3: compressed (small size, good quality)
set audio_format=flac

rem -------------------

rem Preserve input folder structure?
rem 0: no
rem 1: yes
set preserve_folder_structure=0

rem Automatically close the batch file on finish?
rem 0: no
rem 1: yes, if no errors
set autoclose=0

rem --------------------------------------














REM -------------------MAGIC. DO NOT TOUCH.-------------------
rem -------------------Presets-------------------

set "supported_extensions=.mp4 .m4v .avi .mkv .mov .wmv .webm"

set "wav=ffmpeg -hide_banner -loglevel error -stats -i "%%input_render%%" -vn -c:a pcm_s16le -map 0:a:%%track_number%% "%%output_render%%_%%track_number%%.wav""
set "flac=ffmpeg -hide_banner -loglevel error -stats -i "%%input_render%%" -vn -c:a flac -map 0:a:%%track_number%% "%%output_render%%_%%track_number%%.flac""
set "mp3=ffmpeg -hide_banner -loglevel error -stats -i "%%input_render%%" -vn -c:a libmp3lame -b:a 320k -map 0:a:%%track_number%% "%%output_render%%_%%track_number%%.mp3""

set "image=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% "%%output_render%%.%%image_format%%""


rem -------------------Input-------------------
:input
rem Exit if ffmpeg is not installed
where ffmpeg >nul 2>nul
if "%errorlevel%"=="0" (
    rem FFmpeg is found
) else (
	goto :no_ffmpeg
)

rem Exit if input is empty
if "%~1"=="" goto :no_input

set "ffmpeg_run=0"

rem Analyze input
:process_args
if "%~1"=="" goto :end
set "input=%~1"
call :analyze "%%input%%"
shift
goto :process_args

rem -------------------Analyze-------------------
:check_type
set "input_type="
set "ext=%~x1"

if exist "%~1\*" (
    set "input_type=folder"
) else (
	call :check_extension "%%ext%%"
)
exit /b

:check_extension
echo %supported_extensions% | findstr /i /r "\<%ext%\>" >nul
if %errorlevel% equ 0 (
	set "input_type=video"
)
ver >nul
exit /b

:analyze
set "input=%~1"
set "extension=%~x1"
call :check_type "%%input%%"

if not exist "%input%" (
	call :not_exist "%%input%%"
	exit /b
)

rem Skip unsupported formats
if "%input_type%"=="" (
	echo -------------------Skipped-------------------
	echo.
	echo [Source] "%input%"
	echo.
	if "%extension%"=="" echo Wrong input! Files without extension are not supported.
	if "%extension%" neq "" echo Wrong input! "%extension%" is not supported.
	echo Supported formats: %supported_extensions%
	echo.
	exit /b
)

rem Choose renderer
if "%input_type%"=="video" (
    call :video "%%input%%"
	exit /b
)

if "%input_type%"=="folder" (
	if "%preserve_folder_structure%"=="0" (
		call :folder "%%input%%"
		exit /b
	)
	if "%preserve_folder_structure%"=="1" (
		call :folder_maintain_structure "%%input%%"
		exit /b
	)
)
rem --------------------------------------





rem -------------------Video-------------------
:video
set "input_video=%~1"
set "output_render_audio=%~dp1%~n1_extracted\%~n1_audio\%~n1"
set "output_render_sequence=%~dp1%~n1_extracted\%~n1_sequence\%~n1_%%d"
mkdir "%~dp1%~n1_extracted\%~n1_audio\" >nul 2>&1
mkdir "%~dp1%~n1_extracted\%~n1_sequence\" >nul 2>&1

rem Get current framerate
set "current_framerate=ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%current_framerate%%') do set current_framerate=%%a
rem Get current resolution
set "current_resolution=ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%current_resolution%%') do set current_resolution=%%a
rem Get amount of audio tracks
set "audio_tracks_amount="
set "count_audio_tracks_amount=ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%count_audio_tracks_amount%% 2^>NUL') do set audio_tracks_amount=%%a

call :audio "%%input_video%%" "%%output_render_audio%%" "%%audio_tracks_amount%%"
call :render_check "%%input_video%%" "%%output_render_sequence%%" "%%current_framerate%%" "%%current_resolution%%"
exit /b
rem -------------------Folder-------------------
:folder
set "input_folder=%~1"
set "output_folder=%input_folder%_%preset%"
mkdir "%output_folder%" >nul 2>&1
for /r "%input_folder%" %%A in (*) do (
	set "input_video=%%A"
	call :folder_analyze "%%input_video%%"
)
exit /b

:folder_analyze
set "input=%~1"
call :check_type "%%input%%"
if "%input_type%" neq "video" (exit /b)
set "input_video=%~1"
set "output_render=%output_folder%\%~n1"
rem Get current framerate
set "current_framerate=ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%current_framerate%%') do set current_framerate=%%a
rem Get current resolution
set "current_resolution=ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%current_resolution%%') do set current_resolution=%%a
rem Get current audio frequency
set "current_audio_frequency="
set "testing_audio_frequency=ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of default=noprint_wrappers=1:nokey=1 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%testing_audio_frequency%%') do set current_audio_frequency=%%a
call :render_check "%%input_video%%" "%%output_render%%" "%%current_framerate%%" "%%current_resolution%%" "%%current_audio_frequency%%"
exit /b

rem -------------------Folder (maintain structure)-------------------
:copy
set "input_path=%~dp1"
set "input_folder=%~2"
set "output_folder=%~3"

rem Subtract paths 
call set "result=%%input_path:%input_folder%=%%"
rem Combine the result
set "output_path=%output_folder%%result%"

rem Copy file
mkdir "%output_path%" >nul 2>&1
echo -------------------Copied-------------------
echo.
echo  [Source] "%input%"
echo  [Output] "%output_path%%~n1%~x1"
echo.
copy "%input%" "%output_path%"
echo.
exit /b

:folder_maintain_structure
set "input_folder=%~1"
set "output_folder=%~1_%preset%"
mkdir "%output_folder%" >nul 2>&1

for /r "%input_folder%" %%A in (*) do (
	set "input=%%A" 
	call :folder_maintain_structure_analyze "%%input%%"
)
exit /b

:folder_maintain_structure_analyze
set "input=%~1"
set "input_path=%~dp1"

rem Skip render for non-videos
call :check_type "%%input%%"

if "%input_type%" neq "video" (
	if "%copy_files%"=="1" (
		call :copy "%%input%%" "%%input_folder%%" "%%output_folder%%"
		exit /b
	) else (
		exit /b
	)
)

set "input_video=%~1"
rem Get current framerate
set "current_framerate=ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%current_framerate%%') do set current_framerate=%%a
rem Get current resolution
set "current_resolution=ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%current_resolution%%') do set current_resolution=%%a
rem Get current audio frequency
set "current_audio_frequency="
set "testing_audio_frequency=ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of default=noprint_wrappers=1:nokey=1 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%testing_audio_frequency%%') do set current_audio_frequency=%%a
rem Subtract the paths
call set "result=%%input_path:%input_folder%=%%"
rem Combine the result
set "output_render=%output_folder%%result%%~n1"
rem Make a folder
mkdir "%output_folder%%result%" >nul 2>&1
call :audio "%%input_video%%" "%%output_render%%" "%%current_audio_frequency%%"
call :render_check "%%input_video%%" "%%output_render%%" "%%current_framerate%%" "%%current_resolution%%"
exit /b
rem --------------------------------------





rem -------------------Render-------------------
:audio
set "input_render=%~1"
set "output_render=%~2"
set "audio_tracks_amount=%~3"
set /a "audio_tracks_amount-=1"

if "%audio_tracks%"=="1" (
	for /l %%d in (0,1,%audio_tracks_amount%) do (
	set "track_number=%%d"
	call :audio_extract "%%input_render%%" "%%output_render%%" "%%track_number%%"
)
exit /b

:audio_extract
set "input_render=%~1"
set "output_render=%~2"
set "track_number=%~3"
set /a "echo_track_number=%track_number%+1"

rem Get current audio frequency
set "current_audio_frequency="
set "testing_audio_frequency=ffprobe -v error -select_streams a:%%track_number%% -show_entries stream=sample_rate -of default=noprint_wrappers=1:nokey=1 "%%input_video%%""
for /f "tokens=*" %%a in ('call %%testing_audio_frequency%%') do set current_audio_frequency=%%a

call set chosen_audio_preset=%%%audio_format%%%

echo.
echo -------------------Audio information #%echo_track_number%-------------------
echo.
echo       [Source] "%input_render%"
echo       [Preset] %audio_format%
echo    [Frequency] %current_audio_frequency% Hz
echo       [Output] "%output_render%.%audio_format%"
call echo   [Final code] "%chosen_audio_preset%"
echo.

set "ffmpeg_run=1"
call %chosen_audio_preset%
exit /b

:render_check
set "input_render=%~1"
set "output_render=%~2"
set "current_framerate=%~3"
set "current_resolution=%~4"

rem Framerate settings
if "%remove_duplicate_frames%"=="1" (
	set "framerate_remove_duplicate_frames=-r %current_framerate%"
) else (
	set "framerate_dont_remove_duplicate_frames="
	set "framerate_remove_duplicate_frames="
)

rem Framerate echo
if "%remove_duplicate_frames%"=="0" (
	set "echo_remove_duplicate_frames="
) else (
	set "echo_remove_duplicate_frames=(remove duplicate frames)"
)

rem Resolution settings
if "%resolution%"=="0" (
	set "resolution_ffmpeg=-vf setsar=1:1,scale=out_color_matrix=bt709"
) else (
	set "resolution_ffmpeg=-vf scale=%resolution%,setsar=1:1,scale=out_color_matrix=bt709"
)

rem Resolution echo
if "%resolution%"=="0" (
	set "new_resolution=%current_resolution%
) else (
	set "new_resolution=%resolution%"
)

call :render "%%input_render%%" "%%output_render%%"
exit /b

:render
set /a "counter+=1"
set "chosen_image_preset=%image%"
set "input_render=%~1"
set "output_render=%~2"

echo.
echo -------------------Output information #%counter%-------------------
echo.
echo       [Source] "%input_render%"
echo    [Framerate] %current_framerate% %echo_remove_duplicate_frames%
echo   [Resolution] %current_resolution% ^-^> %new_resolution%
echo       [Preset] %image_format%
echo       [Output] "%output_render%.%image_format%"
call echo   [Final code] "%chosen_image_preset%"
echo.
set "ffmpeg_run=1"
call %chosen_image_preset%
echo.
exit /b
rem --------------------------------------





rem -------------------The end-------------------
:no_ffmpeg
echo.
echo FFmpeg not found. Please make sure it's installed and added to the PATH environment variable.
echo.
powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\Windows Critical Stop.wav').PlaySync();"
pause
exit

:no_input
echo.
echo Usage: Drag and drop videos/folders onto the .bat file to extract image sequences and audio tracks.
echo Supported formats: %supported_extensions%
echo.
echo No input, closing.
echo.
powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\notify.wav').PlaySync();"
pause
exit

:not_exist
echo -------------------Skipped-------------------
echo.
echo [Source] "%~1"
echo.
echo "Unable to read the input. Please, remove all special symbols (%% ^ = & , ; etc) from input's name and its path."
echo.
powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\notify.wav').PlaySync();"
pause
exit /b

:no_ffmpeg_run
echo Nothing to process.
echo Make sure your input contain one of the supported formats: %supported_extensions%
echo.
powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\notify.wav').PlaySync();"
pause
exit

:end
echo.
echo -------------------The end-------------------
echo.
if "%errorlevel%"=="0" (
	if "%ffmpeg_run%"=="0" (
		goto :no_ffmpeg_run
	)
	goto :done
)
echo An error ocurred.
echo.
powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\Windows Critical Stop.wav').PlaySync();"
pause
exit

:done
echo Converting is finished!
echo.
powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\Ring06.wav').PlaySync();"

if "%autoclose%"=="0" (
	pause
	exit
)
if "%autoclose%"=="1" (
	exit
)

rem if autoclose is not set to 1 or 0
echo.
echo "autoclose" variable is broken (make sure it is set to 1 or 0)
echo.
pause
exit
rem --------------------------------------