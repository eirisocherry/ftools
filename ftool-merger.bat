@echo off
title ftool-merger v0.9

rem  ____   ____   ____                     _________________
rem |    | |    | |    |                   |__|__|__|__|__|__|
rem |____| |____| |____|                   |                 |
rem  ____   ____   ____    ___________|\   |       |\        |
rem |    | |    | |    |  |             \  |       | \       |
rem |____| |____| |____|  |___________| /  |       | /       |
rem  ____   ____   ____               |/   |       |/        |
rem |    | |    | |    |                   |_________________|
rem |____| |____| |____|                   |__|__|__|__|__|__|

rem -------------------Information-------------------

rem This script merges pictures into a video
rem Usage: drag and drop folders containing pictures onto the .bat file and wait till converting is finished

rem Made by Rikki: https://www.youtube.com/@shy_rikki
rem Source: https://github.com/eirisocherry/ftools

rem -------------------Settings-------------------

rem Choose a preset (scroll down a bit and view presets information)
set preset=uttrue

rem Choose a framerate (recommended fps values: 16/24/25/30/48/50/60/75/120/125/250/500)
rem 24: set to 24 fps
rem 500: set to 500 fps
rem etc...
set fps=60

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

rem Preserve input folder structure?
rem 0: no
rem 1: yes, videos will be rendered inside the folders
rem 2: yes, videos will be rendered outside the folders
set preserve_folder_structure=2

rem Automatically close the batch file on finish?
rem 0: no
rem 1: yes, if no errors
set autoclose=0

rem -------------------Presets information-------------------

rem //////////////////
rem //UTVIDEO (.avi)//
rem //////////////////
rem Requirement: Ut Video Codec (https://www.videohelp.com/software/Ut-Video-Codec-Suite)
rem
rem utalpha -> lossless quality, supports an alpha channel (best choise if you wanna keep the original quality)
rem uttrue  -> lossless quality (best choise if you wanna keep the original quality, especially for depth/normal maps)


rem ////////////////////
rem //QUICKTIME (.mov)//
rem ////////////////////
rem Requirement: Quicktime Codec (https://support.apple.com/en-us/106375)
rem
rem proresxq -> supports an alpha channel (best choise for rendering short videos to youtube)
rem prores   -> supports an alpha channel (much smaller size compared to utalpha) 
rem
rem Issues:
rem 1. prores doesn't support 8k+ resolution (use proresxq instead) 
rem 2. proresxq doesn't work in vegas 18 and lower. 
rem 3. Low contrast bug in vegas 18 and lower. You probably can't fix it.


rem //////////////////////
rem //X264 YUV420 (.mp4)//
rem //////////////////////
rem lossless -> best quality; best choise for rendering long videos to youtube due to small size"
rem good	 -> good quality; good for editing"
rem lite	 -> decent quality; good for sharing due super small size"
rem lossless10bit -> best quality; good for converting raw 10-bit anime clips"
rem good10bit     -> good quality; good for converting raw 10-bit anime clips"
rem lite10bit     -> decent quality; good for converting raw 10-bit anime clips"
rem
rem Issues:
rem 1. Doesn't work with odd values resolutions (ex: 1920x815 = BAD; 1920x816 = GOOD)
rem 2. Low contrast bug in vegas 18 and lower.
rem To fix it adjust project settings (ignore ACES options if you don't have them):
rem 'Pixel format: 32-bit (full range)'
rem 'Compositing gamma: 2.222'
rem 'ACES version: 1.0'
rem 'ACES color space: Default'
rem 'View transform: Off'.


rem ///////
rem //ALL//
rem ///////
rem all -> will render a video in all presets, so you can test which one you like the most


rem ///////////////////
rem //WHAT TO CHOOSE?//
rem ///////////////////
rem Quality (best to worst) utalpha=uttrue > proresxq > prores > lossless/lossless10bit > good/good10bit > lite/lite10bit
rem Size (lowest to biggest) lite/lite10bit < good/good10bit < lossless/lossless10bit < prores < uttrue < proresxq < utalpha
rem Playback speed (fastest to slowest) uttrue > utalpha > lite/lite10bit > good/good10bit > lossless/lossless10bit > prores > proresxq
rem Converting time (fastest to slowest) uttrue < utalpha < lite/lite10bit < prores < proresxq < good/good10bit < lossless/lossless10bit

rem --------------------------------------














REM -------------------MAGIC. DO NOT TOUCH.-------------------
rem -------------------Presets-------------------
set "utalpha=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v utvideo -pix_fmt rgba -c:a pcm_s16le "%%output_render%%.avi""
set "uttrue=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v utvideo -pix_fmt gbrp -c:a pcm_s16le "%%output_render%%.avi""

set "proresxq=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v prores_ks -profile:v 5 -pix_fmt yuva444p12le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -c:a pcm_s16le -video_track_timescale 60000 "%%output_render%%.mov""
set "prores=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v prores -profile:v 4 -pix_fmt yuva444p10le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -c:a pcm_s16le -video_track_timescale 60000 "%%output_render%%.mov""

set "lossless=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v libx264 -crf 1 -preset fast -tune fastdecode -pix_fmt yuv420p -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k "%%output_render%%.mp4""
set "good=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v libx264 -crf 10 -preset fast -tune fastdecode -pix_fmt yuv420p -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k "%%output_render%%.mp4""
set "lite=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v libx264 -crf 20 -preset fast -tune fastdecode -pix_fmt yuv420p -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k "%%output_render%%.mp4""

set "lossless10bit=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v libx264 -crf 1 -preset fast -tune fastdecode -pix_fmt yuv420p10le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k "%%output_render%%.mp4""
set "good10bit=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v libx264 -crf 10 -preset fast -tune fastdecode -pix_fmt yuv420p10le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k "%%output_render%%.mp4""
set "lite10bit=ffmpeg -hide_banner -loglevel error -stats %%framerate_remove_duplicate_frames%% -i "%%input_render%%" %%framerate_dont_remove_duplicate_frames%% %%resolution_ffmpeg%% -c:v libx264 -crf 20 -preset fast -tune fastdecode -pix_fmt yuv420p10le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k "%%output_render%%.mp4""

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
if exist "%~1\*" (
    set "input_type=folder"
)
exit /b

:analyze
set "input=%~1"
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
	echo Wrong input! Drag and drop folders containing image sequences only.
	echo.
	exit /b
)

rem Choose renderer
if "%input_type%"=="folder" (
	call :folder "%%input%%"
	exit /b
)
rem --------------------------------------





rem -------------------Folder-------------------
:preserve_folder_structure1
rem Subtract the paths
call set "result=%%input_path:%global_input_folder%=%%"
rem Make a folder
mkdir "%output_folder%%result%" >nul 2>&1
rem Combine the result
set "output_render=%output_folder%%result%%folder_name%"
exit /b

:preserve_folder_structure2
rem Subtract the paths
call set "result=%%input_path:%global_input_folder%=%%"
rem Make a folder
mkdir "%output_folder%%result%" >nul 2>&1
rem Combine the result
set "output_render=%output_folder%%result%"
rem Move one directory up
for %%A in ("%output_render%") do set "output_render=%%~dpA"
set "output_render=%output_render:~0,-1%"
for %%A in ("%output_render%") do set "output_render=%%~dpA"
set "output_render=%output_render:~0,-1%"
rem Combine the result 2
set "output_render=%output_render%\%folder_name%"
exit /b

:folder
set "global_input_folder=%~1"
set "output_folder=%global_input_folder%_%preset%"
mkdir "%output_folder%" >nul 2>&1
call :find_image_sequence "%%global_input_folder%%"
call :list_of_subfolders "%%global_input_folder%%"
exit /b

:find_image_sequence
set "input_folder=%~1"

for %%f in (
	"%input_folder%\*.jpg"
	"%input_folder%\*.jpeg"
	"%input_folder%\*.png"
	"%input_folder%\*.tga"
	"%input_folder%\*.bmp"
	"%input_folder%\*.tiff"
	"%input_folder%\*.tif"
	"%input_folder%\*.webp"
) do (
	set "input_picture=%%f"
    call :pattern "%%input_picture%%"
	exit /b
)
rem echo.
rem echo "%input_folder%" is empty
rem echo.
exit /b

:list_of_subfolders
for /R "%input_folder%" /D %%d in (*) do (
    set "subfolder=%%d"
	call :find_image_sequence "%%subfolder%%"
)
exit /b
rem -------------------Pattern-------------------
:pattern
set "input_picture=%~1"
set "input_picture_name=%~n1"
set "input_picture_name_reserve=%~n1"
set "input_extension=%~x1"

rem Extract folder name
set "input_path=%~dp1"
set "input_path=%input_path:~0,-1%"
for %%A in ("%input_path%") do set "folder_name=%%~nA"
set "input_path=%~dp1"

rem Get the length of the input_picture_name string
set "length=0"
:get_string_length
if defined input_picture_name_reserve (
    set "input_picture_name_reserve=%input_picture_name_reserve:~1%"
    set /a length+=1
    goto :get_string_length
)

rem Loop through the string from the end to the beginning (get pattern length)
set "pattern_length=0"
set "pattern_is_finished=0"
set /a length_for_cycle=%length%-1
for /l %%a in (%length_for_cycle%,-1,0) do (
    call set "char=%%input_picture_name:~%%a,1%%"
	call :pattern_length "%%char%%"
)
call :prefix
exit /b

:pattern_length
set "char=%~1"
if "%pattern_is_finished%"=="1" (
	exit /b
)
if "%char%" geq "0" if "%char%" leq "9" (
    set /a pattern_length+=1
	exit /b
)
set "pattern_is_finished=1"
exit /b

:prefix
rem Get prefix
set /a new_length=%length%-%pattern_length%
call set "prefix=%%input_picture_name:~0,%new_length%%%"

rem Setup parameters
set "input_render=%input_path%%prefix%%%%pattern_length%d%input_extension%"
set "output_render=%output_folder%\%folder_name%"
rem Get current resolution
set "current_resolution=ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%%input_picture%%""
for /f "tokens=*" %%a in ('call %%current_resolution%%') do set current_resolution=%%a

if "%preserve_folder_structure%"=="1" (
	call :preserve_folder_structure1
)
if "%preserve_folder_structure%"=="2" (
	call :preserve_folder_structure2
)

rem echo "%input_render%"
rem echo "%input_path%"
rem echo "%global_input_folder%"
rem echo "%output_folder%"
rem echo "%result%"
rem echo "%output_render%"
rem pause

set /a "pattern_counter+=1"
echo.
echo -------------------Pattern information #%pattern_counter%-------------------
echo.
echo      [Found file] "%input_picture%"
echo           [Input] "%input_picture_name%"
echo    [Input length] %length%
echo  [Pattern length] %pattern_length%
echo          [Prefix] "%prefix%"
echo.

call :render_check "%%input_render%%" "%%output_render%%" "%%current_resolution%%"
exit /b
rem --------------------------------------





rem -------------------Render-------------------
:render_check
set "input_render=%~1"
set "output_render=%~2"
set "current_resolution=%~3"

rem Framerate settings
if "%remove_duplicate_frames%"=="0" (
	set "framerate_dont_remove_duplicate_frames=-r %fps%"
) else (
	set "framerate_remove_duplicate_frames=-r %fps%"
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

rem Render in all presets?
if "%preset%"=="all" (
	call :render_all_presets "%%input_render%%" "%%output_render%%"
	exit /b
)

call :render "%%input_render%%" "%%output_render%%"
exit /b

:render
set /a "counter+=1"
call set chosen_preset=%%%preset%%%
set "input_render=%~1"
set "output_render=%~2"

rem Extension echo
if "%preset%"=="utalpha" (set "extension=.avi")
if "%preset%"=="uttrue" (set "extension=.avi")
if "%preset%"=="proresxq" (set "extension=.mov")
if "%preset%"=="prores" (set "extension=.mov")
if "%preset%"=="lossless" (set "extension=.mp4")
if "%preset%"=="good" (set "extension=.mp4")
if "%preset%"=="lite" (set "extension=.mp4")
if "%preset%"=="lossless10bit" (set "extension=.mp4")
if "%preset%"=="good10bit" (set "extension=.mp4")
if "%preset%"=="lite10bit" (set "extension=.mp4")

echo -------------------Output information #%counter%-------------------
echo.
echo       [Source] "%input_render%"
echo    [Framerate] %fps% %echo_remove_duplicate_frames%
echo   [Resolution] %current_resolution% ^-^> %new_resolution%
echo       [Preset] %preset% %preset_number%
echo       [Output] "%output_render%%extension%"
call echo   [Final code] "%chosen_preset%"
echo.
call %chosen_preset%
echo.
exit /b

:render_all_presets
set "input_render=%~1"

set "preset=utalpha"
set "preset_number=[1/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=uttrue"
set "preset_number=[2/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=proresxq"
set "preset_number=[3/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=prores"
set "preset_number=[4/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=lossless"
set "preset_number=[5/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=good"
set "preset_number=[6/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=lite"
set "preset_number=[7/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=lossless10bit"
set "preset_number=[8/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=good10bit"
set "preset_number=[9/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=lite10bit"
set "preset_number=[10/10]"
set "output_render=%~2_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=all"
set "preset_number="
exit /b
rem --------------------------------------





rem -------------------The end-------------------
:no_ffmpeg
echo.
echo FFmpeg is not found. Please make sure it's installed and added to the PATH environment variable.
echo.
powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\Windows Critical Stop.wav').PlaySync();"
pause
exit

:no_input
echo.
echo Usage: Drag and drop folders containing image sequences to merge them into videos.
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


