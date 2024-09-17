# ftools
This script converts videos into readable format for editing software (after effects, vegas pro etc.)  

## Credits
`shy_rikki` (discord)  
https://www.youtube.com/@shy_rikki  


| awdaw | wadnaw | wadnaw | wandwa
| ---   | ---    | ---    | ---
| 3     | 5      | adnawdn adnawdn adnawdn adnawdn adnawdn adnawdn adnawdn adnawdn   | wadn

## Installation
1. Install FFMPEG and add it to the PATH environment variable: https://ffmpeg.org/  
2. Install K-Lite Codec Pack (standart): https://codecguide.com/download_kl.htm  
It's a good video player that can play almost every video/audio without any issues  
3. Install these codecs to able to import them into editing software:  
UtVideo codec (.avi): https://www.videohelp.com/software/Ut-Video-Codec-Suite  
Quicktime codec (.mov): https://support.apple.com/en-us/106375  
4. [Optional] Install Notepad++ (handy notepad): https://notepad-plus-plus.org/downloads/  

## Usage
1. Edit ftool-converter.bat with a notepad and adjust the settings (preset, fps etc.)  
2. Make sure videos and folders don't have special symbols such as `( ) ^ ! @ $ & %` etc in their name (dashes "-" , underscores "_", english and other languages are safe to use)  
3. Drag all the videos and folders with videos you want to convert onto the `ftool-converter.bat`  
4. Wait till converting is finished  
5. Enjoy your converted videos  

## Bugs
If this script immediately crashes more likely one of your folders/videos have parentheses `( )` in their name, rename them  
During converting pay big attention to [Input] and [Output] paths and rename files/folders which are causing errors  

## To add an ffmpeg preset
1. Make a preset 
![image](https://github.com/user-attachments/assets/cafd32ea-3ad4-4d01-bd4b-f254fa6f473e)  
2. Specify the extension your new preset has
![image](https://github.com/user-attachments/assets/fd3f6160-ca4f-4d19-b44b-1bce369a25b3)  
3. [Optional] Specify the preset in `render_all_presets` function to make "all" preset work correctly  
![image](https://github.com/user-attachments/assets/1c618a9d-689b-4530-a35f-b9409bbce2b0)  

## To add more supported file formats
![image](https://github.com/user-attachments/assets/a1c44d34-c86a-4afa-9e4e-3f144ca3b60b)  
![image](https://github.com/user-attachments/assets/c7bc2f59-3936-445c-af5b-2f1cc2d69304)  

## Random information
https://stackoverflow.com/questions/37255690/ffmpeg-format-settings-matrix-bt709  
