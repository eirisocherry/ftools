rem Exit if input is empty
if "%~1"=="" (
	echo Empty input
	pause
	exit
)

mkdir "%~dp1exr_video"
rem ffmpeg -i "%~1" -compression 0 -pix_fmt gbrpf32le -format 2 -gamma 1 "%~dp1exr_video\video_%%04d.exr"
rem ffmpeg -i "%~1" -vf "geq=r='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535':g='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535':b='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535'" -compression 0 -pix_fmt gbrpf32le -format 2 -gamma 1 "%~dp1exr_video\video_%%04d.exr"

rem ffmpeg -i "%~1" -vf "geq=r='(r(X,Y)*255*255 + g(X,Y)*255 + b(X,Y))/65535':g='(r(X,Y)*255*255 + g(X,Y)*255 + b(X,Y))/65535':b='(r(X,Y)*255*255 + g(X,Y)*255 + b(X,Y))/65535',format=gbrpf32le" -compression 0 "%~dp1exr_video\video_%%04d.exr"


rem ffmpeg -i "%~1" -vf "geq=r='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535':g='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535':b='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535'" -compression 0 -pix_fmt gbrpf32le -format 1 -gamma 1 "%~dp1exr_video\video_%%04d.exr"

rem ffmpeg -i "%~1" -compression 0 -format 2 -gamma 1 -vf "format=gbrpf32le,geq=r='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535':g='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535':b='(r(X,Y)*256*256 + g(X,Y)*256 + b(X,Y))/65535'" "%~dp1exr_video\video_%%04d.exr"

ffmpeg -i "%~1" -compression_algo raw -vf "format=gbrp, format=rgba64le" "%~dp1exr_video\video_%%04d.tiff"


ffmpeg -h encoder=tiff



pause
exit