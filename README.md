# ftools
Is a collection of ffmpeg batch scripts that allow you to recursively:  
1. Convert videos to optimized formats (ftool-converter.bat)  
2. Merge image sequences into videos (ftool-merger.bat)  
3. Extract image sequences and audio tracks from videos (ftool-extractor.bat)  
4. Split resolution of videos into peaces (ftool-splitter.bat)  

## Credits
`shy_rikki` (discord)  
https://www.youtube.com/@shy_rikki  

## Advantages
- FFmpeg presets which provide the best quality with precise colors and work super fast in any software (Vegas Pro, After Effects, Premiere Pro etc)
- Easy to use: just drag and drop the videos/folders onto the `.bat` file and wait till converting is finished
- Fully customizable
  - Adjustable frame rate (FPS)
  - Changeable resolution
  - Create your own FFmpeg presets (for advanced users only)
  - and more...

## Installation
1. Install FFMPEG and add it to the PATH environment variable: https://ffmpeg.org/  
Tutorial: https://www.youtube.com/watch?v=qSlxv68Xpkw  
2. Install K-Lite Codec Pack (standart): https://codecguide.com/download_kl.htm  
It's a good video player that can play almost every video/audio without any issues  
3. Install these codecs to be able to import them into software:  
UtVideo codec (.avi): https://www.videohelp.com/software/Ut-Video-Codec-Suite  
Quicktime codec (.mov): https://support.apple.com/en-us/106375  
4. [Optional] Install Notepad++ (handy notepad): https://notepad-plus-plus.org/downloads/  
5. Install the batch scripts.  

### Usage
1. Edit `*.bat` with a notepad and adjust the settings (preset, fps etc.)  
2. Make sure videos and folders don't have special symbols such as `% ^ = & , ;` etc in their names (dashes "-" , underscores "_", english and other languages are safe to use)  
   During converting pay big attention to [Input] and [Output] paths and rename files/folders which are causing errors  
3. Drag and drop videos/folders onto the `*.bat` file and wait till converting is finished
4. Enjoy your converted videos  


## Guide
<details>
<summary> How to add an ffmpeg preset </summary>
<br>



<details>
<summary> >> ftool-converter.bat </summary>
<br>

1. Make a new preset  
![image](https://github.com/user-attachments/assets/2a82f8a7-5817-478c-8d13-c8a8842d81e1)  
2. [Optional] Setup more extensions which ffmpeg will try to convert  
![image](https://github.com/user-attachments/assets/d2e36bc9-2a6e-49fc-9f21-717f1b1fcdc7)  
3. Adjust echo  
![image](https://github.com/user-attachments/assets/660246b8-c04e-4b7d-912e-1dae1ac64c64)  
4. Specify the new preset in `render_all_presets` function to make a preset called "all" work correctly  
![image](https://github.com/user-attachments/assets/7afdd0d8-e285-4806-977d-14f71684036a)  

<br>
</details>


<details>
<summary> >> ftool-merger.bat </summary>
<br>


<br>
</details>


<details>
<summary> >> ftool-extractor.bat </summary>
<br>

<br>
</details>


<details>
<summary> >> ftool-splitter.bat </summary>
<br>

<br>
</details>



<br>
</details>
