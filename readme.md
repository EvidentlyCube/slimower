![Slimower logo](.readme/logo.png?raw=true)

[![Slimower - Screenshot 1](.readme/screen_1_thumb.png?raw=true)](.readme/screen_1.png?raw=true) [![Slimower - Screenshot 2](.readme/screen_2_thumb.png?raw=true)](.readme/screen_2.png?raw=true) [![Slimower - Screenshot 3](.readme/screen_3_thumb.png?raw=true)](.readme/screen_3.png?raw=true) [![Slimower - Screenshot 4](.readme/screen_4_thumb.png?raw=true)](.readme/screen_4.png?raw=true) [![Slimower - Screenshot 5](.readme/screen_5_thumb.png?raw=true)](.readme/screen_5.png?raw=true)

Slimower is a minimalistic twin-stick platformer shooter featuring a moderate amount of fun

This repository contains the freely available source code and assets for the game by [Retrocade.net](http://retrocade.net).

# General info

## Meta

 * **Title**: Slimower 
 * **Technology:** ActionScript 3.0, Flash
 * **First release date:** Jul 3, 2011
 * **Play the game:** http://retrocade.net/game/slimower/
 * **Opensoure resources:** http://retrocade.net/open-art/slimower/
 * **License:**
   * **Source code:** [MIT](https://opensource.org/licenses/MIT)
   * **Levels:** [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode)
   * **Art:** [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode)
   * **Sound Effects:** [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode)
   * **Music:** Copyright Wojciech Panufnik
 * **Who to credit:**
   * **Source Code:** Retrocade.net
   * **Art:** Retrocade.net
   * **Sound Effects:** No credit required
   
## Licensing

File LICENSE.txt contains the actual body of the license for Source Code, Artworks and Sound Effects for the project. If any text file is licensed by someone else in a different manner the text of the license will be at the top of the file. Non-text file licenses are presented in a format `<filename>.<extension>.LICENSE.txt`, eg. `music.mp3.LICENSE.txt`. Alternatively `LICENSE.txt` might exist in a directory - in this case this license covers the whole contents of the directory and its subdirectories. 

## Supporting Retrocade.net

If this project taught you something new, was useful in any way or generally you want to support Retrocade.net or thank us for our work you can find more information on [this page](http://retrocade.net/how-to-support-retrocade-net/).

## More Projects

Retrocade.net is at the slow process of releasing the source code and graphical assets of almost all of their old projects. If you're interested in other games please visit [this page](http://retrocade.net/open-art/).

## File Formats

In case you encounter arcane and unknown file formats here are the tools you might need:

 * **PMP** - [Pro Motion project file, by Cosmigo](http://www.cosmigo.com/promotion/index.php)
 * **RWD** - [Real Draw project file, by Media Chance](http://www.mediachance.com/realdraw/)

# Slimower

## How to build the project

Open `build.cmd` in your text editor, update `MXMLC_PATH` variable with the path to Flex SDK (it should support at least Flash Player 10.1), and then run `build.cmd`. If you're on a non-windows o/s the commands used in the file should still work fine so you can use them as basis.

## Editing levels

 1. Grab our copy of [Ogmo Editor](https://github.com/RetrocadeNet/ogmo-editor) (Original Ogmo Editor was made by [Matt Thorson](www.mattmakesgames.com)) - either the [Windows binary](https://github.com/RetrocadeNet/ogmo-editor/releases/tag/1.0) or the source code to build it for other platforms.
 2. Unpack/build the editor.
 3. Run the editor.
 4. Open the project file in `/src.level_editor/Editor.oep` and then either proceed to create a new level from scratch or edit one of the existing ones.
 
