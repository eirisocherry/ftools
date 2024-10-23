@echo off
title video splitter



REM -------------------Information-------------------
REM This script splits a video into 4 equal parts
REM Made by Rikki: https://www.youtube.com/c/RikkiLove

REM How to use?
REM 1. Install FFMPEG or move ffmpeg.exe file in the same folder as the script (https://ffmpeg.org/)
REM 2. Make sure the video name and the path to it has no special symbols (best example of a good path: "D:/screens/blablabla/video.avi")
REM 3. Adjust the settings below (fps, preset etc.)
REM 4. Just drag the video into the script file (dont drag multiple files at once, drag them separately, or nothing will work)
REM Done!
	
REM -------------------Settings-------------------

REM Choose a preset
set preset=uttrue

REM Choose a framerate (please, use only 75/120/125/250/500/1000 fps to avoid problems)
set fps=1000

REM Choose what layers do you want to get
REM 1: top left
REM 2: top left + top right
REM 3: top left + top right + bottom left
REM 4: top left + top right + bottom left + bottom right
set layers=2

REM Choose if you want to automatically close the batch file on finish or not
REM 0: will be paused
REM 1: will be closed
set autoclose=1

REM -------------------Presets information-------------------
REM //UTVIDEO
REM Compatibility: Sony Vegas 13+, After Effects"
REM Requirement: Ut Video Codec (https://www.videohelp.com/software/Ut-Video-Codec-Suite)"
REM Issue: if you will record in more than 1000 fps it will be converted to 600 fps but the length will be longer to keep the frames amount
REM Why it happens?  1000+ fps avi files don't work well with editing software so ut codec dev decided to make such thing
REM utTrue  -> true rgb, original quality and amazing optimization"
REM utGood  -> the depth map isn't perfect, unnoticeable quality loss"

REM //X264 (YUV420)
REM Compatibility: Sony Vegas 13+, After Effects
REM Issues: doesn't work with odd values resolutions (ex: 1920x815 = BAD; 1920x816 = GOOD), green tint on the depth map (simply desaturate it)"
REM If you use vegas 18 and lower, then make sure to adjust project settings: 'Pixel format: 32-bit (full range)', 'Compositing gamma: 2.222', 'ACES version: 1.0', 'ACES color space: Default', 'View transform: Off'.
REM Ignore ACES options if you don't have them. By changing these project settings you will get the best possible colors.
REM good13 -> best for overall layers"

REM //QUICKTIME
REM Compatibility: Sony Vegas 19+, After Effects
REM Requirement: Quicktime Codec (https://support.apple.com/en-us/106375)"
REM proresxq -> high quality preset with fast playback, supports an alpha channel"
REM -------------------Presets-------------------
set "uttrue=-c:v utvideo -pix_fmt gbrp"
set "utgood=-c:v utvideo -pix_fmt yuv422p"
set "proresxq=-c:v prores -profile:v 5"
set "good13=-c:v libx264 -crf 10 -preset fast -tune fastdecode -pix_fmt yuv420p -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2"
REM --------------------------------------










REM -------------------DON'T TOUCH-------------------
REM -------------------Beginning of the code-------------------
setlocal enabledelayedexpansion

IF "%~1"=="" goto :NoInput

set "input=%~1"
set "output_folder=%~dpn1" REM output_folder_name = input_file_name
if not exist "%output_folder%" mkdir "%output_folder%"

REM -------------------Output parameters for each preset-------------------
if "%preset%" == "uttrue" (
set "top_left=%output_folder%\1beauty.avi"
set "top_right=%output_folder%\6depth.avi"
set "bottom_left=%output_folder%\6normal.avi"
set "bottom_right=%output_folder%\2viewmodel.avi"
)

if "%preset%" == "utgood" (
set "top_left=%output_folder%\1beauty.avi"
set "top_right=%output_folder%\6depth.avi"
set "bottom_left=%output_folder%\6normal.avi"
set "bottom_right=%output_folder%\2viewmodel.avi"
)

if "%preset%" == "proresxq" (
set "top_left=%output_folder%\1beauty.mov"
set "top_right=%output_folder%\6depth.mov"
set "bottom_left=%output_folder%\6normal.mov"
set "bottom_right=%output_folder%\2viewmodel.mov"
)

if "%preset%" == "good13" (
set "top_left=%output_folder%\1beauty.mp4"
set "top_right=%output_folder%\6depth.mp4"
set "bottom_left=%output_folder%\6normal.mp4"
set "bottom_right=%output_folder%\2viewmodel.mp4"
)
REM -------------------Splitting process-------------------
set chosen_preset=!%preset%!

echo.
echo This script splits a video into 4 equal parts.
echo If you want to adjust output parameters, edit the script. 
echo.
echo -------------------Output information-------------------
echo.
echo Input: %input%
echo Preset: %preset%
echo FPS: %fps%
echo Layers: %layers%
echo Autoclose: %autoclose%
echo Output: %output_folder%
echo.
echo -------------------Splitting process-------------------
echo.
set "one_layer=ffmpeg.exe -hide_banner -loglevel repeat+warning -stats -r %fps% -i "%~1" -filter_complex "[0]split=1[in_tl]; [in_tl]crop=iw/2:ih/2:0:0[out_tl]" %chosen_preset% -map [out_tl] "%top_left%""
set "two_layers=ffmpeg.exe -hide_banner -loglevel repeat+warning -stats -r %fps% -i "%~1" -filter_complex "[0]split=2[in_tl][in_tr]; [in_tl]crop=iw/2:ih/2:0:0[out_tl]; [in_tr]crop=iw/2:ih/2:iw/2:0[out_tr]" %chosen_preset% -map [out_tl] "%top_left%" %chosen_preset% -map [out_tr] "%top_right%""
set "three_layers=ffmpeg.exe -hide_banner -loglevel repeat+warning -stats -r %fps% -i "%~1" -filter_complex "[0]split=3[in_tl][in_tr][in_bl]; [in_tl]crop=iw/2:ih/2:0:0[out_tl]; [in_tr]crop=iw/2:ih/2:iw/2:0[out_tr]; [in_bl]crop=iw/2:ih/2:0:ih/2[out_bl]" %chosen_preset% -map [out_tl] "%top_left%" %chosen_preset% -map [out_tr] "%top_right%" %chosen_preset% -map [out_bl] "%bottom_left%""
set "four_layers=ffmpeg.exe -hide_banner -loglevel repeat+warning -stats -r %fps% -i "%~1" -filter_complex "[0]split=4[in_tl][in_tr][in_bl][in_br]; [in_tl]crop=iw/2:ih/2:0:0[out_tl]; [in_tr]crop=iw/2:ih/2:iw/2:0[out_tr]; [in_bl]crop=iw/2:ih/2:0:ih/2[out_bl]; [in_br]crop=iw/2:ih/2:iw/2:ih/2[out_br]" %chosen_preset% -map [out_tl] "%top_left%" %chosen_preset% -map [out_tr] "%top_right%" %chosen_preset% -map [out_bl] "%bottom_left%" %chosen_preset% -map [out_br] "%bottom_right%""

if %layers% == 1 (
call %one_layer%
)
if %layers% == 2 (
call %two_layers%
)
if %layers% == 3 (
call %three_layers%
)
if %layers% == 4 (
call %four_layers%
)

echo.
echo -------------------The end-------------------
echo.
REM -------------------The end-------------------
IF %ERRORLEVEL% EQU 0 (
	echo Done. The window will now close.
	if %autoclose% == 0 (
	goto :Done
	) else (
	goto :DoneNoPause
	)
)

echo An error ocurred.
goto :Done

:NoInput
echo Usage: Drag and drop your video onto the script.
echo No input, closing.
echo.

:Done
pause

:DoneNoPause
REM --------------------------------------