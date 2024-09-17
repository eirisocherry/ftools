# ftools
This script converts videos into a format compatible with software such as After Effects, Vegas Pro, and more.  

## Credits
`shy_rikki` (discord)  
https://www.youtube.com/@shy_rikki  



## Features
- Best ffmpeg presets which provide the best quality with precise colors and work super fast in any software (Vegas Pro, After Effects etc)
- Easy to use: just drag and drop the folders/videos onto the batch and wait till converting is finished
- Fully customizable
  - Adjustable frame rate (FPS)
  - Changeable resolution
  - Create your own FFmpeg presets (for advanced users only)

## Installation
1. Install FFMPEG and add it to the PATH environment variable: https://ffmpeg.org/  
2. Install K-Lite Codec Pack (standart): https://codecguide.com/download_kl.htm  
It's a good video player that can play almost every video/audio without any issues  
3. Install these codecs to able to import them into editing software:  
UtVideo codec (.avi): https://www.videohelp.com/software/Ut-Video-Codec-Suite  
Quicktime codec (.mov): https://support.apple.com/en-us/106375  
4. [Optional] Install Notepad++ (handy notepad): https://notepad-plus-plus.org/downloads/  



## Usage

<details>
<summary> Usage </summary>
<br>

1. Edit ftool-converter.bat with a notepad and adjust the settings (preset, fps etc.)  
2. Make sure videos and folders don't have special symbols such as `( ) ^ ! @ $ & %` etc in their name (dashes "-" , underscores "_", english and other languages are safe to use)  
3. Drag all the videos and folders with videos you want to convert onto the `ftool-converter.bat`  
4. Wait till converting is finished  
5. Enjoy your converted videos  

**Bug:** If this script immediately crashes more likely one of your folders/videos have parentheses `( )` in their name, rename them  
During converting pay big attention to [Input] and [Output] paths and rename files/folders which are causing errors  

<br>
</details>



<details>
<summary> Presets information </summary>
<br>

### UTVIDEO (.avi)  
Requirement: Ut Video Codec (https://www.videohelp.com/software/Ut-Video-Codec-Suite)  
`utalpha` -> true lossless quality, supports an alpha channel (best choise if you wanna keep the original quality)  
`uttrue`  -> true lossless quality (best choise if you wanna keep the original quality, especially on depth/normal maps)  

### QUICKTIME (.mov)  
Requirement: Quicktime Codec (https://support.apple.com/en-us/106375)  
Issues: 1. prores doesn't support 8k+ resolution (use proresxq instead)  
2. proresxq doesn't work in vegas 18 and lower.  
3. Low contrast bug in vegas 18 and lower. You can't fix it.  
`proresxq` -> supports an alpha channel (best choise for rendering short videos (less than 1 minute) to youtube)  
`prores`   -> supports an alpha channel (much smaller size compared to utalpha)  

### X264 YUV420 (.mp4)  
Issues:  
1. Doesn't work with odd values resolutions (ex: 1920x815 = BAD; 1920x816 = GOOD)  
2. Low contrast bug in vegas 18 and lower.  
To fix it adjust project settings (ignore ACES options if you don't have them):  
'Pixel format: 32-bit (full range)'  
'Compositing gamma: 2.222'  
'ACES version: 1.0'  
'ACES color space: Default'  
'View transform: Off'.  
`lossless` -> best choise for rendering long videos (1 minute+) to youtube due to small size  
`good`     -> best balance  
`lite`     -> good for sharing, because of super small size  

### ALL  
`all` -> will render a video in all presets, so you can test which one you like the most  

### What to choose?  
**Quality (best to worst):** utalpha = uttrue > proresxq > prores > lossless13 > good > lite  
**Size (lowest to biggest):** lite < good < lossless < prores < uttrue < proresxq < utalpha  
**Playback speed (fastest to slowest):** uttrue > utalpha > lite > good > lossless > prores > proresxq  
**Converting time (fastest to slowest):** uttrue < utalpha < lite < prores < proresxq < good < lossless  

<br>
</details>



<details>
<summary> To add an ffmpeg preset </summary>
<br>

1. Make a preset 
![image](https://github.com/user-attachments/assets/cafd32ea-3ad4-4d01-bd4b-f254fa6f473e)  
2. Specify the extension your new preset has
![image](https://github.com/user-attachments/assets/fd3f6160-ca4f-4d19-b44b-1bce369a25b3)  
3. [Optional] Specify the preset in `render_all_presets` function to make "all" preset work correctly  
![image](https://github.com/user-attachments/assets/1c618a9d-689b-4530-a35f-b9409bbce2b0)  

<br>
</details>



<details>
<summary> To add more supported file formats </summary>
<br>

![image](https://github.com/user-attachments/assets/a1c44d34-c86a-4afa-9e4e-3f144ca3b60b)  
![image](https://github.com/user-attachments/assets/c7bc2f59-3936-445c-af5b-2f1cc2d69304)  

<br>
</details>

## Random information
https://stackoverflow.com/questions/37255690/ffmpeg-format-settings-matrix-bt709  
