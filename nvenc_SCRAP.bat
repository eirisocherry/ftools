@echo off
title ftool-converter v0.9

rem  _________________                     _________________
rem |__|__|__|__|__|__|                   |__|__|__|__|__|__|
rem |                 |                   |                 |
rem |       |\        |   ___________|\   |       |\        |
rem |       | \       |  |             \  |       | \       |
rem |       | /       |  |___________| /  |       | /       |
rem |       |/        |              |/   |       |/        |
rem |_________________|                   |_________________|
rem |__|__|__|__|__|__|                   |__|__|__|__|__|__|

rem -------------------Information-------------------

rem This script converts videos into optimized format for editing software (after effects, vegas pro etc.)
rem Usage: drag and drop videos/folders onto the .bat file and wait till converting is finished

rem Made by Rikki: https://www.youtube.com/@shy_rikki
rem Source: https://github.com/eirisocherry/ftools

rem -------------------Settings-------------------

rem Choose a preset (scroll down a bit and view presets information)
set preset=lite

rem Choose a framerate (recommended fps values: 16/24/25/30/48/50/60/75/120/125/250/500)
rem 0: don't change
rem 24: set to 24 fps
rem 500: set to 500 fps
rem etc...
set fps=0

rem Maintain video length? (applies only when fps is not set to 0)
rem 0: no (total amount of frames will remain the same, but if you trying to convert lossless/uncompressed avi, absolutely identical frames will be deleted)
rem 1: yes (total amount of frames will be decreased or increased by adding identical frames)
set maintain_video_length=1

rem Choose a resolution (use only even numbers to avoid problems 1920:815 is bad, 1920:816 is good)
rem set resolution=0 -> don't change
rem set resolution=1280:720 -> set to 1280:720
rem set resolution=1920:1080 -> set to 1920:1080
rem etc...
set resolution=0

rem Preserve input folder structure?
rem 0: no
rem 1: yes
set preserve_folder_structure=1

rem Сopy files that are not videos? (applies only when preserve_folder_structure=1)
rem 0: no
rem 1: yes
set copy_files=0

rem Render an audio?
rem 0: no
rem 1: yes if exist
rem 2: no if you set custom fps and maintain_video_length=0
set audio_render=2

rem Automatically close the batch file on finish?
rem 0: no
rem 1: yes if no errors
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

set "supported_extensions=.mp4 .m4v .avi .mkv .mov .wmv .webm"

set "utalpha=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v utvideo -pix_fmt rgba -c:a pcm_s16le %%disable_audio%% "%%output_render%%.avi""
set "uttrue=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v utvideo -pix_fmt gbrp -c:a pcm_s16le %%disable_audio%% "%%output_render%%.avi""

set "proresxq=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v prores_ks -profile:v 5 -pix_fmt yuva444p12le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -c:a pcm_s16le -video_track_timescale 60000 %%disable_audio%% "%%output_render%%.mov""
set "prores=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v prores -profile:v 4 -pix_fmt yuva444p10le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -c:a pcm_s16le -video_track_timescale 60000 %%disable_audio%% "%%output_render%%.mov""

set "lossless=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v libx264 -crf 1 -preset fast -tune fastdecode -pix_fmt yuv420p -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k %%disable_audio%% "%%output_render%%.mp4""
set "good=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v libx264 -crf 10 -preset fast -tune fastdecode -pix_fmt yuv420p -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k %%disable_audio%% "%%output_render%%.mp4""
rem set "lite=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v h264_nvenc -preset lossless -tune lossless -profile:v high444p -pix_fmt yuv444p -rc constqp -qp 0 -g 30 -bf 0 -gpu 0 %%disable_audio%% "%%output_render%%.mp4""
rem set "lite=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -vsync 0 -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v h264_nvenc -preset p7 -tune hq -b:v 50M -bufsize 50M -maxrate 100M -qmin 0 -g 30 -bf 0 -temporal-aq 1 -rc-lookahead 20 %%disable_audio%% "%%output_render%%.mp4""
set "lite=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -vsync 0 -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v h264_nvenc -preset p7 -tune hq -b:v 100M -bufsize 100M -maxrate 200M -qmin 0 -g 30 -bf 0 -temporal-aq 1 -rc-lookahead 20 -pix_fmt yuv420p -color_primaries bt709 -color_trc bt709 -colorspace bt709 -c:a aac -b:a 320k %%disable_audio%% "%%output_render%%.mp4""

set "lossless10bit=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v libx264 -crf 1 -preset fast -tune fastdecode -pix_fmt yuv420p10le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k %%disable_audio%% "%%output_render%%.mp4""
set "good10bit=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v libx264 -crf 10 -preset fast -tune fastdecode -pix_fmt yuv420p10le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k %%disable_audio%% "%%output_render%%.mp4""
set "lite10bit=ffmpeg -hide_banner -loglevel error -stats %%framerate_dont_maintain_length%% -i "%%input_render%%" %%framerate_maintain_length%% %%resolution_ffmpeg%% -c:v libx264 -crf 20 -preset fast -tune fastdecode -pix_fmt yuv420p10le -color_primaries bt709 -color_trc bt709 -colorspace bt709 -level:v 5.2 -x264-params keyint=12:min-keyint=1:ref=1:bframes=0:qcomp=0.8:aq-strength=0.5:dct-decimate=0:fast-pskip=0:deblock=-2,-2 -c:a aac -b:a 512k %%disable_audio%% "%%output_render%%.mp4""
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
set "output_render=%~dpn1_%preset%"

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
call :render_check "%%input_video%%" "%%output_render%%" "%%current_framerate%%" "%%current_resolution%%" "%%current_audio_frequency%%"
exit /b
rem --------------------------------------





rem -------------------Render-------------------
:render_check
set "input_render=%~1"
set "output_render=%~2"
set "current_framerate=%~3"
set "current_resolution=%~4"
set "current_audio_frequency=%~5"

rem Framerate settings
if "%fps%"=="0" (
	set "framerate_dont_maintain_length="
	set "framerate_maintain_length="
) else (
	if "%maintain_video_length%"=="0" (
		set "framerate_dont_maintain_length=-r %fps%"
	) else (
		set "framerate_maintain_length=-r %fps%"
	)
)

rem Framerate echo
if "%fps%"=="0" (
	set "new_framerate=%current_framerate%"
) else (
	set "new_framerate=%fps%"
	if "%maintain_video_length%"=="0" (
		set "echo_maintain_video_length=(dont maintain video length)"
	) else (
		set "echo_maintain_video_length=(maintain video length)"
	)
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

rem Audio settings
if "%current_audio_frequency%"=="" (
	set "disable_audio=-an"
	set "current_audio_frequency=0"
	set "disable_audio_info=Disabled, because the audio is missing"
) else (
	if "%audio_render%"=="1" (
		set "disable_audio="
		set "disable_audio_info=Enabled"
	) else (
		if "%fps%"=="0" (
			set "disable_audio="
			set "disable_audio_info=Enabled"
		) else (
			if "%maintain_video_length%"=="1" (
				set "disable_audio="
				set "disable_audio_info=Enabled, because the video will maintain length"
			) else (
				set "disable_audio=-an"
				set "disable_audio_info=Disabled, because you set a custom fps"
			)
		)
	)
)
if "%audio_render%"=="0" (
set "disable_audio=-an"
set "disable_audio_info=Disabled"
)

rem Render a video in all presets?
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

echo -------------------Video converting #%counter%-------------------
echo.
echo       [Source] "%input_render%"
echo    [Framerate] %current_framerate% ^-^> %new_framerate% %echo_maintain_video_length%
echo   [Resolution] %current_resolution% ^-^> %new_resolution%
echo        [Audio] %disable_audio_info%
echo       [Preset] %preset% %preset_number%
echo       [Output] "%output_render%%extension%"
call echo   [Final code] "%chosen_preset%"
echo.

set "ffmpeg_run=1"
call %chosen_preset%
echo.
exit /b

:render_all_presets
set "input_render=%~1"
mkdir "%output_render%" >nul 2>&1

set "preset=utalpha"
set "preset_number=[1/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=uttrue"
set "preset_number=[2/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=proresxq"
set "preset_number=[3/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=prores"
set "preset_number=[4/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=lossless"
set "preset_number=[5/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=good"
set "preset_number=[6/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=lite"
set "preset_number=[7/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=lossless10bit"
set "preset_number=[8/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=good10bit"
set "preset_number=[9/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=lite10bit"
set "preset_number=[10/10]"
set "output_render=%~2\%~n1_%preset%"
call :render "%%input_render%%" "%%output_render%%"

set "preset=all"
set "preset_number="
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
echo Usage: Drag and drop videos/folders onto the .bat file to convert them.
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