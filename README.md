# No-Intro ROM Parsing

# What's this?

The aim of this script is to sort and organize ROM files by region, release type, and revision.

This script creates a directory structure to accommodate for all the various release types and flags found in a No-Intro rom set, which is replicated to folders for the four major release regions, then sorted appropriately. The script then checks the "Official Releases" folder of each region for titles with multiple revisions. It checks the revision numbers, leaves the latest revision in the "Official Releases" folder, and moves all earlier revisions of a given title to the "Previous Revisions" folder.

By default, this script creates full sets for each region - for example, (World) releases are actually COPIED to every region - I wanted to avoid regional biases where I could so that if someone wanted a full Japanese set or a European set, you only need run the script and grab the contents of the corresponding folder. You can disable this by commenting or removing the "Regional Bias" section found below.

- Previously available as Windows Batch file, converted to PowerShell script for increased functionality.

- Not compatible with Linux or macOS currently.

In the future, I would like to create a GUI wrapper for this script, even if it's just so I can learn how.

This project was originally released on LaunchBox Forums here: 
https://forums.launchbox-app.com/files/file/4268-machtendo-no-intro-rom-parse/

<details>
<summary>Testing</summary>

This script has been tested with the following platforms:

- Atari - 2600
- Atari - 5200
- Atari - 7800
- Atari - Jaguar
- Atari - Lynx
- Bandai - WonderSwan
- Bandai - WonderSwan Color
- GCE - Vectrex
- NEC - PC Engine - TurboGrafx-16
- NEC - PC Engine CD
- NEC - PC Engine SuperGrafx
- Nintendo - 3DS
- Nintendo - DS
- Nintendo - Family Computer Disk System
- Nintendo - Game and Watch
- Nintendo - Game Boy
- Nintendo - Game Boy Advance
- Nintendo - Game Boy Color
- Nintendo - GameCube
- Nintendo - Nintendo 64
- Nintendo - Nintendo 64DD
- Nintendo - Nintendo Entertainment System
- Nintendo - Satellaview
- Nintendo - Super Nintendo Entertainment System
- Nintendo - Virtual Boy
- Nintendo - Wii
- Sega - 32X
- Sega - Dreamcast
- Sega - Game Gear
- Sega - Master System - Mark III
- Sega - Mega Drive - Genesis
- Sega - Saturn
- Sega - SG-1000
- SNK - NeoGeo Pocket
- SNK - NeoGeo Pocket Color
- Sony - PlayStation
- Sony - PlayStation 2
- Sony - PS Vita
- Sony - PSP
</details>

# Why's this?

In order to simplify compatibility with various frontends, to satisfy my own preferences, and possibly the preferences of others. A few use-cases can be found below:

- LaunchBox

  When using LaunchBox, playlists can be created by using the "Application/ROM Path" parameter - the filepaths/folder structure created by this script will allow you to be as granular as you would like.

- EmulationStation-DE

  When using EmulationStation-DE, you're actually just browsing your file/folder structure - the filepaths/folder structure created by this script are meant to be descriptive and (hopefully) 
intuitive.

- Trimming

  Once the script is run, one could simply delete entire regions, remove all the various Test Programs, trim BIOS files, delete Demo or Sample roms, Prototypes, and easily create a custom set that suits their individual tastes. This script can be used to create your own 1G1R-set, though this has not been tested on all platforms.

# Instructions

Simply copy this batch file into the folder containing your roms, and double click to run it. 

If you happen to receive an error along the lines of "Running Scripts is Disabled on this System" you can open the folder in Terminal or PowerShell and run the script with the following command:

```
powershell -ExecutionPolicy Bypass -File .\rom-parse.ps1
```

# Logic & Structure

How have these files been sorted, and why?

BIOS Files - BIOS files are first moved into a _BIOS folder prior to any sorting functionality. This is so that any available version is immediately and easily accessible for use with an emulator if needed.

Regions

I'm going by the three historically major release regions, with a fourth "Other" region to cover the other minor release regions.

Major Regions
- North America - US, Canada
- Japan - Japan
- Europe - Italy, Spain, Sweden, France, Germany, Australia, Denmark, Scandinavia
- Other - Korea, Brazil, Argentina, Taiwan, Mexico, Russia, Hong Kong, Netherlands, China, Greece, Asia

No-Intro Flags

The file structure for the No-Intro flags is replicated to the four regional folders above.

- Aftermarket Releases - Licensed, Unlicensed, or Homebrew games released for a platform after its "active" or "canonical" lifespan.

- Hacks - Not strictly within the scope of No-Intro - these ROMs have had patches applied to them to modify, transform, or attempt to improve an existing game. i.e. patches that can be found at RDHN (romhacking.net)

- Alternate Releases - Re-release of a ROM on a later platform or in a "Classics" Collection, i.e. Virtual Console, Nintendo Switch Online, or compilations such as "Castlevania Anniversary Collection"

- Official Releases - Licensed games released at the time of a platform's "active" lifespan.

- Pre-Release - Unfinished games - betas, demos, or prototypes not meant for the general public

- Previous Revisions - (New in v5) Any revision of a given title that is not the latest version.

- Test Cartridges & Utilities - These are tools generally used by developers or hardware manufacturers, mostly for testing purposes or diagnostics/troubleshooting

- Translations - Again, not strictly within the scope of No-Intro, but these are ROM files with an applied translation patch, commonly denoted with the [T-En] flag. Note that the region that these translations are targeting is the region the rom will be moved to - i.e. target language is English, therefore ends up in the North America > Translations folder. Currently, only [T-En] is supported.

- Unlicensed Releases - Unlicensed games that were released DURING the canonical lifespan of the platform in question without explicit permission or input of the platform's manufacturer.

# Notes & Clarification

Keep in mind, this script is only intended for use with romsets following the No-Intro naming convention. More information can be found here: https://wiki.no-intro.org/index.php?title=Naming_Convention

- This script is entirely filetype agnostic - it doesn't care about file extensions, so as long as the set of files you're applying this script to adheres to the No-Intro naming convention, this script can be used to sort them. One could also use this script to sort through artwork/image/media files for corresponding ROM files.

- This script cares ONLY about the No-Intro naming convention - the use of DAT files and ROM managers have not been considered, and splitting up these ROM files may break compatibility with said DAT files or ROM managers.

- By default, no ROM files are deleted by this script - I'm only sorting and organizing.

# Disclaimer
I am not responsible for any undesirable effects or outcomes running this script may have.
