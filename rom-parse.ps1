#######################################################################################################
# Machtendo No-Intro ROM Parsing
# Version 5.0
# Written by machjas, 2022-2023
#######################################################################################################

#################################
# What's this?
#################################

# Previously available as Windows Batch file, converted to PowerShell script for increased functionality.
# Not compatible with Linux or macOS currently.

###
# The aim of this script is to sort and organize ROM files by region, release type, and revision.
# 
# This script creates a directory structure to accommodate for all the various release types and flags
# found in a No-Intro set, which is then replicated to folders for the four major release regions, then 
# sorted appropriately. The script then checks the "Official Releases" folder of each region for titles
# with multiple revisions. It checks the revision numbers, leaves the latest revision in the "Official
# Releases" folder, and moves all earlier revisions of a given title to the "Previous Revisions" folder.
#
# By default, this script creates full sets for each region - for example, (World) releases are actually
# COPIED to every region - I wanted to avoid regional biases where I could so that if someone wanted a
# full Japanese set or a European set, you only need run the script and grab the contents of the 
# corresponding folder. You can disable this by commenting or removing the "Regional Bias" section found 
# below.
###

#################################
# Why's this?
#################################

###
# In order to simplify compatibility with various frontends, to satisfy my own preferences, and
# possibly the preferences of others. A few use-cases can be found below.
###

###
# When using LaunchBox, playlists can be created by using the "Application/ROM Path" parameter - the
# filepaths/folder structure created by this script will allow you to be as granular as you would like.
###

###
# When using EmulationStation-DE, you're actually just browsing your file/folder structure - the
# filepaths/folder structure created by this script are meant to be descriptive and (hopefully) 
# intuitive.
###

###
# Once the script is run, one could simply delete entire regions, remove all the various Test Programs,
# trim BIOS files, delete Demo or Sample roms, Prototypes, and easily create a custom set that suits
# their individual tastes.
###

###
# This script is entirely filetype agnostic - it doesn't care about file extensions, so as long as the
# set of files you're applying this script to adheres to the No-Intro naming convention, this script can
# be used to sort them. One could also use this script to sort through artwork/image/media files for 
# corresponding ROM files.
###

#######################################################################################################
# Instructions
#######################################################################################################
#
# Simply copy this batch file into the folder containing your roms, and double click to run it. 
#
# That's it!
#

#################################
# Logic & Structure
#################################

# How have these files been sorted, and why?

###
# BIOS Files - BIOS files are first moved into a _BIOS folder prior to any sorting functionality. This is
# so that any available version is immediately and easily accessible for use with an emulator if needed.
###

###
# Regions
###

# I'm going by the three historically major release regions, with a fourth "Other" region to cover
# the other minor release regions.
#
# Major Regions
#	North America - US, Canada
#	Japan - Japan
#	Europe - Italy, Spain, Sweden, France, Germany, Australia, Denmark, Scandinavia
#	Other - Korea, Brazil, Argentina, Taiwan, Mexico, Russia, Hong Kong, Netherlands, China, Greece, Asia

###
# No-Intro Flags
###

# The file structure for the No-Intro flags is replicated to the four regional folders above.

###
# Aftermarket Releases - Licensed, Unlicensed, or Homebrew games released for a platform after its "active" 
# or "canonical" lifespan.
###

###
# Hacks - Not strictly within the scope of No-Intro - these ROMs have had patches applied to them to modify,
# transform, or attempt to improve an existing game. i.e. patches that can be found at RDHN (romhacking.net)
###

###
# Alternate Releases - Re-release of a ROM on a later platform or in a "Classics" Collection, i.e. Virtual
# Console, Nintendo Switch Online, or compilations such as "Castlevania Anniversary Collection"
###

###
# Official Releases - Licensed games released at the time of a platform's "active" lifespan.
###

###
# Pre-Release - Unfinished games - betas, demos, or prototypes not meant for the general public
###

###
# Previous Revisions - (New in v5) Any revision of a given title that is not the latest version.
###

###
# Test Cartridges & Utilities - These are tools generally used by developers or hardware manufacturers,
# mostly for testing purposes or diagnostics/troubleshooting
###

###
# Translations - Again, not strictly within the scope of No-Intro, but these are ROM files with an applied
# translation patch, commonly denoted with the [T-En] flag. Note that the region that these translations
# are targeting is the region the rom will be moved to - i.e. target language is English, therefore ends up 
# in the North America > Translations folder. Currently, only [T-En] is supported.
###

###
# Unlicensed Releases - Unlicensed games that were released DURING the canonical lifespan of the platform
# in question without explicit permission or input of the platform's manufacturer.
###


#################################
# Notes & Clarification
#################################

###
# Keep in mind, this script is only intended for use with romsets following the No-Intro naming 
# convention. More information can be found here: 
#
# 	https://wiki.no-intro.org/index.php?title=Naming_Convention
###

###
# This script cares ONLY about the No-Intro naming convention - the use of DAT files and ROM managers
# have not been considered, and splitting up these ROM files may break compatibility with said DAT
# files or ROM managers.
###

###
# By default, no ROM files are deleted by this script - I'm only sorting and organizing. I am also not
# responsible for any undesirable effects or outcomes running this script may have.
###

###
# Tested with the following platforms
#	Atari - 2600
#	Atari - 5200
#	Atari - 7800
#	Atari - Jaguar
#	Atari - Lynx
#	Bandai - WonderSwan
#	Bandai - WonderSwan Color
#	GCE - Vectrex
#	NEC - PC Engine - TurboGrafx-16
#	NEC - PC Engine CD
#	NEC - PC Engine SuperGrafx
#	Nintendo - 3DS
#	Nintendo - DS
#	Nintendo - Family Computer Disk System
#	Nintendo - Game and Watch
#	Nintendo - Game Boy
#	Nintendo - Game Boy Advance
#	Nintendo - Game Boy Color
#	Nintendo - GameCube
#	Nintendo - Nintendo 64
#	Nintendo - Nintendo 64DD
#	Nintendo - Nintendo Entertainment System
#	Nintendo - Satellaview
#	Nintendo - Super Nintendo Entertainment System
#	Nintendo - Virtual Boy
#	Nintendo - Wii
#	Sega - 32X
#	Sega - Dreamcast
#	Sega - Game Gear
#	Sega - Master System - Mark III
#	Sega - Mega Drive - Genesis
#	Sega - Saturn
#	Sega - SG-1000
#	SNK - NeoGeo Pocket
#	SNK - NeoGeo Pocket Color
#	Sony - PlayStation
#	Sony - PlayStation 2
#	Sony - PS Vita
#	Sony - PSP
###

##############################################################################################################################################################################################################
# FUNCTIONS BEGIN
##############################################################################################################################################################################################################

#################################
# Create BIOS Directory
#################################
Write-Host "Creating Drectory for Global BIOS files..."

New-Item -ItemType Directory -Path "_BIOS"

Write-Host "BIOS Directory Created"

#################################
# Create Temporary Folder Structure for Replication
#################################

Write-Host "Creating Directory Framework..."

New-Item -ItemType Directory -Path "Categories"
New-Item -ItemType Directory -Path "Categories\Test Cartridges & Utilities"
New-Item -ItemType Directory -Path "Categories\Pre-Release"
New-Item -ItemType Directory -Path "Categories\Pre-Release\Prototype"
New-Item -ItemType Directory -Path "Categories\Pre-Release\Beta"
New-Item -ItemType Directory -Path "Categories\Pre-Release\Demo"
New-Item -ItemType Directory -Path "Categories\Pre-Release\Sample"
New-Item -ItemType Directory -Path "Categories\Official Releases"
New-Item -ItemType Directory -Path "Categories\Previous Revisions"
New-Item -ItemType Directory -Path "Categories\Unlicensed Releases"
New-Item -ItemType Directory -Path "Categories\Translations"
New-Item -ItemType Directory -Path "Categories\Hacks"
New-Item -ItemType Directory -Path "Categories\Hacks\FastROM"
New-Item -ItemType Directory -Path "Categories\Hacks\Enhanced Colors"
New-Item -ItemType Directory -Path "Categories\Aftermarket Releases"
New-Item -ItemType Directory -Path "Categories\Alternate Releases"
New-Item -ItemType Directory -Path "Categories\Alternate Releases\Multi-Cart"
New-Item -ItemType Directory -Path "Categories\Alternate Releases\Collections"
New-Item -ItemType Directory -Path "Categories\Alternate Releases\Virtual Console"
New-Item -ItemType Directory -Path "Categories\Alternate Releases\Switch Online"
New-Item -ItemType Directory -Path "Categories\Alternate Releases\GameCube Edition"
New-Item -ItemType Directory -Path "Categories\Alternate Releases\eReader Edition"

Write-Host "Directory Framework Created!"

#################################
# Replicate Folder Structure for Major Regions
#################################

Write-Host "Creating Regional Directory Structure..."

Copy-Item -Path "Categories" -Destination "North America" -Recurse
Copy-Item -Path "Categories" -Destination "Japan" -Recurse
Copy-Item -Path "Categories" -Destination "Europe" -Recurse
Copy-Item -Path "Categories" -Destination "Other" -Recurse

Write-Host "Regional Directory Structure Created!"

#################################
# Remove Temporary Folder Structure
#################################

Write-Host "Removing Framework Base Structure..."

Remove-Item -Path "Categories" -Recurse -Force

Write-Host "Done!"

############################################
# Distributing ROM Files
############################################

#################################
# BIOS Files
#################################

Write-Host "Parsing BIOS Files..."

Get-ChildItem -Filter "*[BIOS]*" | Move-Item -Destination .\"_BIOS"

Write-Host "BIOS Files Parsed!"

###############
# Regional Bias (Disabled by Default)
###############
#
# Comment out or remove the following section to prevent replication of worldwide or multi-regional 
# releases into multiple regional folders - disabling Regional Bias will make copies of ROMs in
# in order to create full regional sets.

Write-Host "Copying Multi-Regional Releases..."

Copy-Item -Path "*(*World*)*.*" -Destination "Japan"
Copy-Item -Path "*(*World*)*.*" -Destination "Europe"
Copy-Item -Path "*(*World*)*.*" -Destination "Other"
Copy-Item -Path "*(*Japan*USA*)*.*" -Destination "Japan"
Copy-Item -Path "*(*Japan*Europe*)*.*" -Destination "Japan"
Copy-Item -Path "*(*USA*Europe*)*.*" -Destination "Europe"

###############

Move-Item -Path "*(*World*)*.*" -Destination "North America"
Move-Item -Path "*(*Japan*Europe*)*.*" -Destination "Europe"

Write-Host "Multi-Regional Releases Copied!"

###############
# English Translations [T-En]
###############

Write-Host "Parsing [T-En] Translations..."

Get-ChildItem -Filter "*[*T-En*]*" | Move-Item -Destination .\"North America\Translations"
Get-ChildItem -Filter "*[*Namingway*Edition*]*" | Move-Item -Destination .\"North America\Translations"
Get-ChildItem -Filter "*[*Woolsey*Uncensored*]*" | Move-Item -Destination .\"North America\Translations"

Write-Host "Translations Parsed!"

###############
# Parse Region: North America
###############

Write-Host "Parsing Regions..."

Move-Item -Path "*(*USA*)*.*" -Destination "North America"
Move-Item -Path "*(*Unknown*)*.*" -Destination "North America"
Move-Item -Path "*(*Canada*)*.*" -Destination "North America"

###############
# Parse Region: Japan
###############

Move-Item -Path "*(*Japan*)*.*" -Destination "Japan"

###############
# Parse Region: Europe
###############

Move-Item -Path "*(*Europe*)*.*" -Destination "Europe"
Move-Item -Path "*(*Italy*)*.*" -Destination "Europe"
Move-Item -Path "*(*Spain*)*.*" -Destination "Europe"
Move-Item -Path "*(*Sweden*)*.*" -Destination "Europe"
Move-Item -Path "*(*France*)*.*" -Destination "Europe"
Move-Item -Path "*(*Germany*)*.*" -Destination "Europe"
Move-Item -Path "*(*Australia*)*.*" -Destination "Europe"
Move-Item -Path "*(*Denmark*)*.*" -Destination "Europe"
Move-Item -Path "*(*Scandinavia*)*.*" -Destination "Europe"
Move-Item -Path "*(*United*Kingdom*)*.*" -Destination "Europe"

###############
# Parse Region: Other
###############

Move-Item -Path "*(*Korea*)*.*" -Destination "Other"
Move-Item -Path "*(*Brazil*)*.*" -Destination "Other"
Move-Item -Path "*(*Argentina*)*.*" -Destination "Other"
Move-Item -Path "*(*Taiwan*)*.*" -Destination "Other"
Move-Item -Path "*(*Mexico*)*.*" -Destination "Other"
Move-Item -Path "*(*Russia*)*.*" -Destination "Other"
Move-Item -Path "*(*Hong*Kong*)*.*" -Destination "Other"
Move-Item -Path "*(*Netherlands*)*.*" -Destination "Other"
Move-Item -Path "*(*China*)*.*" -Destination "Other"
Move-Item -Path "*(*Greece*)*.*" -Destination "Other"
Move-Item -Path "*(*Asia*)*.*" -Destination "Other"

#################################
# Parse Region: Unknown/Unspecified
#################################
#
# None Currently - Placeholder Section

Write-Host "Regions Parsed!"

##################################################################
# North America
##################################################################

#################################
# Standard Moves
#################################

Write-Host "Sorting North American Releases..."

Move-Item -Path ".\North America\*Color hack*.*" -Destination ".\North America\Hacks\Enhanced Colors"
Move-Item -Path ".\North America\*FastROM hack*.*" -Destination ".\North America\Hacks\FastROM"

Move-Item -Path ".\North America\*(*Demo*)*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*Sampler CD*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*Sampler Disc*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*Sampler Disk*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*CD Sampler*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*Demo CD*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*Demo Disc*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*Demo Disk*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Asciiware Training CD*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*Squaresoft on PlayStation*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\*PlayStation Underground*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Dreamcast Express*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Dreamcast Middleware Conference Demo Disc*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Dreamcast Promotion Disk*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Dreamon*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Generator Vol*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Interactive Multi-Game Demo Disc*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Interactive Preview Plus*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Jampack Vol*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Official Sega Dreamcast Magazine*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Official U.S. PlayStation Magazine Demo*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Pizza Hut Disc*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\PlayStation Kiosk Demo*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\PlayStation Picks*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\PS One*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\PS-X-Change*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\PSone*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Toys R Us - Attack of the Killer Demos*.*" -Destination ".\North America\Pre-Release\Demo"
Move-Item -Path ".\North America\Toys R Us Test Drive Promotion*.*" -Destination ".\North America\Pre-Release\Demo"

Move-Item -Path ".\North America\*(*Proto*)*.*" -Destination ".\North America\Pre-Release\Prototype"
Move-Item -Path ".\North America\*(*Promo*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\*(*Program*)*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*(*Enhancement*Chip*)*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*(*Audio*Tapes*)*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*(*Sample*)*.*" -Destination ".\North America\Pre-Release\Sample"
Move-Item -Path ".\North America\*(*Debug*)*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*(*Prerelease*)*.*" -Destination ".\North America\Pre-Release"
Move-Item -Path ".\North America\*(*Test*Program*)*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Service Disc*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*(*SDK*Build*)*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Action Replay*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Super*Game*Boy*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Burn-in*Test*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Demonstration*Program*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Diagnostics*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Flash*Masta*Firmware*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Game*Genie*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\*Info Genius Productivity Pak*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Advanced Music Player*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Aging Disc DOL-*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Aprilia - DiTech Interface*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Atari*PAM*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Breaker Pro*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Cheats 'N Codes Volume*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Code Breaker*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\CodeBreaker*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Codemasters Demo CD*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Doctor GB Card*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Dreamkey*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Game Boy Camera*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Game Boy Player Start-Up Disc*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\GameBooster 64*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\GameShark*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\GBA Jukebox*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\GBA Personal Organizer*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\JRA PAT for Dreamcast*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Lynx II Production Test Program (USA)*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Nintendo 64 Modem*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Randnet*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Ultimate Codes for Use with*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Web Browser*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\XBAND*.*" -Destination ".\North America\Test Cartridges & Utilities"
Move-Item -Path ".\North America\Game Boy Aging Cartridge*.*" -Destination ".\North America\Test Cartridges & Utilities"

Move-Item -Path ".\North America\*(*Arcade*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\*(*Anthology*)*.*" -Destination ".\North America\Alternate Releases\Collections"
Move-Item -Path ".\North America\*(*Capcom*Classics*Mini*Mix*)*.*" -Destination ".\North America\Alternate Releases\Collections"
Move-Item -Path ".\North America\*(*Collect*)*.*" -Destination ".\North America\Alternate Releases\Collections"
Move-Item -Path ".\North America\*(*Disney*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\*(*e-Reader*)*.*" -Destination ".\North America\Alternate Releases\eReader Edition"
Move-Item -Path ".\North America\*(*Final*Cut*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\*(*GameCube*)*.*" -Destination ".\North America\Alternate Releases\GameCube Edition"
Move-Item -Path ".\North America\*(*Genesis*Mini*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\*(*LodgeNet*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\*(*Namco*Museum*)*.*" -Destination ".\North America\Alternate Releases\Collections"
Move-Item -Path ".\North America\*(*PC*Rerelease*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\*(*Sega*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\*(*Switch*)*.*" -Destination ".\North America\Alternate Releases\Switch Online"
Move-Item -Path ".\North America\*(*Virtual*Console)*.*" -Destination ".\North America\Alternate Releases\Virtual Console"
Move-Item -Path ".\North America\*(*Wii*)*.*" -Destination ".\North America\Alternate Releases"
Move-Item -Path ".\North America\e-Reader (USA)*.*" -Destination ".\North America\Alternate Releases\eReader Edition"

Move-Item -Path ".\North America\2 Game Pack*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\2 Games in 1*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\2 Games in One*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\2 Great Games*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\2 in 1 Game Pack*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\2-in-1 Fun Pack*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\3 Game Pack*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\3 Games in 1*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\3 Games in One*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\4 Games on One Game Pak*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"
Move-Item -Path ".\North America\4 in 1 + 8 in 1*.*" -Destination ".\North America\Alternate Releases\Multi-Cart"

Move-Item -Path ".\North America\*(*Hack*)*.*" -Destination ".\North America\Hacks"

Move-Item -Path ".\North America\*(*Unl*)*.*" -Destination ".\North America\Unlicensed Releases"

Move-Item -Path ".\North America\*(*Beta*)*.*" -Destination ".\North America\Pre-Release\Beta"

Move-Item -Path ".\North America\River City Girls Zero*.*" -Destination ".\North America\Aftermarket Releases"
Move-Item -Path ".\North America\8-BIT ADV STEINS;GATE*.*" -Destination ".\North America\Aftermarket Releases"
Move-Item -Path ".\North America\*(*Pirate*)*.*" -Destination ".\North America\Aftermarket Releases"
Move-Item -Path ".\North America\*(*Aftermarket*)*.*" -Destination ".\North America\Aftermarket Releases"

Move-Item -Path ".\North America\*.*" -Destination ".\North America\Official Releases"

Write-Host "Sorting for North America Complete."

##################################################################
# Japan
##################################################################

#################################
# Standard Moves
#################################

Write-Host "Sorting Japanese Releases..."

Move-Item -Path ".\Japan\*Color hack*.*" -Destination ".\Japan\Hacks\Enhanced Colors"
Move-Item -Path ".\Japan\*FastROM hack*.*" -Destination ".\Japan\Hacks\FastROM"

Move-Item -Path ".\Japan\*(*Demo*)*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*Sampler CD*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*Sampler Disc*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*Sampler Disk*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*CD Sampler*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*Demo CD*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*Demo Disc*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*Demo Disk*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Asciiware Training CD*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*Squaresoft on PlayStation*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\*PlayStation Underground*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Dreamcast Express*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Dreamcast Middleware Conference Demo Disc*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Dreamcast Promotion Disk*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Dreamon*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Generator Vol*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Interactive Multi-Game Demo Disc*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Interactive Preview Plus*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Jampack Vol*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Official Sega Dreamcast Magazine*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Official U.S. PlayStation Magazine Demo*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Pizza Hut Disc*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\PlayStation Kiosk Demo*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\PlayStation Picks*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\PS One*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\PS-X-Change*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\PSone*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Toys R Us - Attack of the Killer Demos*.*" -Destination ".\Japan\Pre-Release\Demo"
Move-Item -Path ".\Japan\Toys R Us Test Drive Promotion*.*" -Destination ".\Japan\Pre-Release\Demo"

Move-Item -Path ".\Japan\*(*Proto*)*.*" -Destination ".\Japan\Pre-Release\Prototype"
Move-Item -Path ".\Japan\*(*Promo*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\*(*Program*)*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*(*Enhancement*Chip*)*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*(*Audio*Tapes*)*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*(*Sample*)*.*" -Destination ".\Japan\Pre-Release\Sample"
Move-Item -Path ".\Japan\*(*Debug*)*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*(*Prerelease*)*.*" -Destination ".\Japan\Pre-Release"
Move-Item -Path ".\Japan\*(*Test*Program*)*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Service Disc*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*(*SDK*Build*)*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Action Replay*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Super*Game*Boy*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Burn-in*Test*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Demonstration*Program*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Diagnostics*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Flash*Masta*Firmware*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Game*Genie*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\*Info Genius Productivity Pak*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Advanced Music Player*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Aging Disc DOL-*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Aprilia - DiTech Interface*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Atari*PAM*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Breaker Pro*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Cheats 'N Codes Volume*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Code Breaker*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\CodeBreaker*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Codemasters Demo CD*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Doctor GB Card*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Dreamkey*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Game Boy Camera*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Game Boy Player Start-Up Disc*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\GameBooster 64*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\GameShark*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\GBA Jukebox*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\GBA Personal Organizer*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\JRA PAT for Dreamcast*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Lynx II Production Test Program (USA)*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Nintendo 64 Modem*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Randnet*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Ultimate Codes for Use with*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Web Browser*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\XBAND*.*" -Destination ".\Japan\Test Cartridges & Utilities"
Move-Item -Path ".\Japan\Game Boy Aging Cartridge*.*" -Destination ".\North America\Test Cartridges & Utilities"

Move-Item -Path ".\Japan\*(*Arcade*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\*(*Anthology*)*.*" -Destination ".\Japan\Alternate Releases\Collections"
Move-Item -Path ".\Japan\*(*Capcom*Classics*Mini*Mix*)*.*" -Destination ".\Japan\Alternate Releases\Collections"
Move-Item -Path ".\Japan\*(*Collect*)*.*" -Destination ".\Japan\Alternate Releases\Collections"
Move-Item -Path ".\Japan\*(*Disney*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\*(*e-Reader*)*.*" -Destination ".\Japan\Alternate Releases\eReader Edition"
Move-Item -Path ".\Japan\*(*Final*Cut*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\*(*GameCube*)*.*" -Destination ".\Japan\Alternate Releases\GameCube Edition"
Move-Item -Path ".\Japan\*(*Genesis*Mini*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\*(*LodgeNet*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\*(*Namco*Museum*)*.*" -Destination ".\Japan\Alternate Releases\Collections"
Move-Item -Path ".\Japan\*(*PC*Rerelease*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\*(*Sega*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\*(*Switch*)*.*" -Destination ".\Japan\Alternate Releases\Switch Online"
Move-Item -Path ".\Japan\*(*Virtual*Console)*.*" -Destination ".\Japan\Alternate Releases\Virtual Console"
Move-Item -Path ".\Japan\*(*Wii*)*.*" -Destination ".\Japan\Alternate Releases"
Move-Item -Path ".\Japan\e-Reader (USA)*.*" -Destination ".\Japan\Alternate Releases\eReader Edition"

Move-Item -Path ".\Japan\2 Game Pack*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\2 Games in 1*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\2 Games in One*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\2 Great Games*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\2 in 1 Game Pack*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\2-in-1 Fun Pack*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\3 Game Pack*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\3 Games in 1*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\3 Games in One*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\4 Games on One Game Pak*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Japan\4 in 1 + 8 in 1*.*" -Destination ".\Japan\Alternate Releases\Multi-Cart"

Move-Item -Path ".\Japan\*(*Hack*)*.*" -Destination ".\Japan\Hacks"

Move-Item -Path ".\Japan\*(*Unl*)*.*" -Destination ".\Japan\Unlicensed Releases"

Move-Item -Path ".\Japan\*(*Beta*)*.*" -Destination ".\Japan\Pre-Release\Beta"

Move-Item -Path ".\Japan\River City Girls Zero*.*" -Destination ".\Japan\Aftermarket Releases"
Move-Item -Path ".\Japan\8-BIT ADV STEINS;GATE*.*" -Destination ".\Japan\Aftermarket Releases"
Move-Item -Path ".\Japan\*(*Pirate*)*.*" -Destination ".\Japan\Aftermarket Releases"
Move-Item -Path ".\Japan\*(*Aftermarket*)*.*" -Destination ".\Japan\Aftermarket Releases"

Move-Item -Path ".\Japan\*.*" -Destination ".\Japan\Official Releases"

Write-Host "Sorting for Japan Complete."

##################################################################
# Europe
##################################################################

#################################
# Standard Moves
#################################

Write-Host "Sorting European Releases..."

Move-Item -Path ".\Europe\*Color hack*.*" -Destination ".\Europe\Hacks\Enhanced Colors"
Move-Item -Path ".\Europe\*FastROM hack*.*" -Destination ".\Europe\Hacks\FastROM"

Move-Item -Path ".\Europe\*(*Demo*)*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*Sampler CD*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*Sampler Disc*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*Sampler Disk*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*CD Sampler*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*Demo CD*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*Demo Disc*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*Demo Disk*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Asciiware Training CD*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*Squaresoft on PlayStation*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\*PlayStation Underground*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Dreamcast Express*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Dreamcast Middleware Conference Demo Disc*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Dreamcast Promotion Disk*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Dreamon*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Generator Vol*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Interactive Multi-Game Demo Disc*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Interactive Preview Plus*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Jampack Vol*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Official Sega Dreamcast Magazine*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Official U.S. PlayStation Magazine Demo*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Pizza Hut Disc*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\PlayStation Kiosk Demo*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\PlayStation Picks*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\PS One*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\PS-X-Change*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\PSone*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Toys R Us - Attack of the Killer Demos*.*" -Destination ".\Europe\Pre-Release\Demo"
Move-Item -Path ".\Europe\Toys R Us Test Drive Promotion*.*" -Destination ".\Europe\Pre-Release\Demo"

Move-Item -Path ".\Europe\*(*Proto*)*.*" -Destination ".\Europe\Pre-Release\Prototype"
Move-Item -Path ".\Europe\*(*Promo*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\*(*Program*)*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*(*Enhancement*Chip*)*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*(*Audio*Tapes*)*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*(*Sample*)*.*" -Destination ".\Europe\Pre-Release\Sample"
Move-Item -Path ".\Europe\*(*Debug*)*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*(*Prerelease*)*.*" -Destination ".\Europe\Pre-Release"
Move-Item -Path ".\Europe\*(*Test*Program*)*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Service Disc*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*(*SDK*Build*)*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Action Replay*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Super*Game*Boy*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Burn-in*Test*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Demonstration*Program*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Diagnostics*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Flash*Masta*Firmware*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Game*Genie*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\*Info Genius Productivity Pak*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Advanced Music Player*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Aging Disc DOL-*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Aprilia - DiTech Interface*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Atari*PAM*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Breaker Pro*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Cheats 'N Codes Volume*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Code Breaker*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\CodeBreaker*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Codemasters Demo CD*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Doctor GB Card*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Dreamkey*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Game Boy Camera*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Game Boy Player Start-Up Disc*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\GameBooster 64*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\GameShark*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\GBA Jukebox*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\GBA Personal Organizer*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\JRA PAT for Dreamcast*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Lynx II Production Test Program (USA)*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Nintendo 64 Modem*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Randnet*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Ultimate Codes for Use with*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Web Browser*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\XBAND*.*" -Destination ".\Europe\Test Cartridges & Utilities"
Move-Item -Path ".\Europe\Game Boy Aging Cartridge*.*" -Destination ".\North America\Test Cartridges & Utilities"

Move-Item -Path ".\Europe\*(*Arcade*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\*(*Anthology*)*.*" -Destination ".\Europe\Alternate Releases\Collections"
Move-Item -Path ".\Europe\*(*Capcom*Classics*Mini*Mix*)*.*" -Destination ".\Europe\Alternate Releases\Collections"
Move-Item -Path ".\Europe\*(*Collect*)*.*" -Destination ".\Europe\Alternate Releases\Collections"
Move-Item -Path ".\Europe\*(*Disney*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\*(*e-Reader*)*.*" -Destination ".\Europe\Alternate Releases\eReader Edition"
Move-Item -Path ".\Europe\*(*Final*Cut*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\*(*GameCube*)*.*" -Destination ".\Europe\Alternate Releases\GameCube Edition"
Move-Item -Path ".\Europe\*(*Genesis*Mini*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\*(*LodgeNet*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\*(*Namco*Museum*)*.*" -Destination ".\Europe\Alternate Releases\Collections"
Move-Item -Path ".\Europe\*(*PC*Rerelease*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\*(*Sega*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\*(*Switch*)*.*" -Destination ".\Europe\Alternate Releases\Switch Online"
Move-Item -Path ".\Europe\*(*Virtual*Console)*.*" -Destination ".\Europe\Alternate Releases\Virtual Console"
Move-Item -Path ".\Europe\*(*Wii*)*.*" -Destination ".\Europe\Alternate Releases"
Move-Item -Path ".\Europe\e-Reader (USA)*.*" -Destination ".\Europe\Alternate Releases\eReader Edition"

Move-Item -Path ".\Europe\2 Game Pack*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\2 Games in 1*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\2 Games in One*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\2 Great Games*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\2 in 1 Game Pack*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\2-in-1 Fun Pack*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\3 Game Pack*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\3 Games in 1*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\3 Games in One*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\4 Games on One Game Pak*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Europe\4 in 1 + 8 in 1*.*" -Destination ".\Europe\Alternate Releases\Multi-Cart"

Move-Item -Path ".\Europe\*(*Hack*)*.*" -Destination ".\Europe\Hacks"

Move-Item -Path ".\Europe\*(*Unl*)*.*" -Destination ".\Europe\Unlicensed Releases"

Move-Item -Path ".\Europe\*(*Beta*)*.*" -Destination ".\Europe\Pre-Release\Beta"

Move-Item -Path ".\Europe\River City Girls Zero*.*" -Destination ".\Europe\Aftermarket Releases"
Move-Item -Path ".\Europe\8-BIT ADV STEINS;GATE*.*" -Destination ".\Europe\Aftermarket Releases"
Move-Item -Path ".\Europe\*(*Pirate*)*.*" -Destination ".\Europe\Aftermarket Releases"
Move-Item -Path ".\Europe\*(*Aftermarket*)*.*" -Destination ".\Europe\Aftermarket Releases"

Move-Item -Path ".\Europe\*.*" -Destination ".\Europe\Official Releases"

Write-Host "Sorting for Europe Complete."

##################################################################
# Minor Regions (Other)
##################################################################

#################################
# Standard Moves
#################################

Write-Host "Sorting Minor Release Regions..."

Move-Item -Path ".\Other\*Color hack*.*" -Destination ".\Other\Hacks\Enhanced Colors"
Move-Item -Path ".\Other\*FastROM hack*.*" -Destination ".\Other\Hacks\FastROM"

Move-Item -Path ".\Other\*(*Demo*)*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*Sampler CD*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*Sampler Disc*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*Sampler Disk*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*CD Sampler*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*Demo CD*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*Demo Disc*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*Demo Disk*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Asciiware Training CD*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*Squaresoft on PlayStation*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\*PlayStation Underground*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Dreamcast Express*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Dreamcast Middleware Conference Demo Disc*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Dreamcast Promotion Disk*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Dreamon*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Generator Vol*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Interactive Multi-Game Demo Disc*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Interactive Preview Plus*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Jampack Vol*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Official Sega Dreamcast Magazine*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Official U.S. PlayStation Magazine Demo*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Pizza Hut Disc*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\PlayStation Kiosk Demo*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\PlayStation Picks*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\PS One*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\PS-X-Change*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\PSone*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Toys R Us - Attack of the Killer Demos*.*" -Destination ".\Other\Pre-Release\Demo"
Move-Item -Path ".\Other\Toys R Us Test Drive Promotion*.*" -Destination ".\Other\Pre-Release\Demo"

Move-Item -Path ".\Other\*(*Proto*)*.*" -Destination ".\Other\Pre-Release\Prototype"
Move-Item -Path ".\Other\*(*Promo*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\*(*Program*)*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*(*Enhancement*Chip*)*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*(*Audio*Tapes*)*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*(*Sample*)*.*" -Destination ".\Other\Pre-Release\Sample"
Move-Item -Path ".\Other\*(*Debug*)*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*(*Prerelease*)*.*" -Destination ".\Other\Pre-Release"
Move-Item -Path ".\Other\*(*Test*Program*)*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Service Disc*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*(*SDK*Build*)*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Action Replay*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Super*Game*Boy*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Burn-in*Test*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Demonstration*Program*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Diagnostics*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Flash*Masta*Firmware*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Game*Genie*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\*Info Genius Productivity Pak*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Advanced Music Player*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Aging Disc DOL-*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Aprilia - DiTech Interface*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Atari*PAM*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Breaker Pro*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Cheats 'N Codes Volume*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Code Breaker*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\CodeBreaker*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Codemasters Demo CD*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Doctor GB Card*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Dreamkey*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Game Boy Camera*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Game Boy Player Start-Up Disc*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\GameBooster 64*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\GameShark*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\GBA Jukebox*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\GBA Personal Organizer*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\JRA PAT for Dreamcast*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Lynx II Production Test Program (USA)*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Nintendo 64 Modem*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Randnet*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Ultimate Codes for Use with*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Web Browser*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\XBAND*.*" -Destination ".\Other\Test Cartridges & Utilities"
Move-Item -Path ".\Other\Game Boy Aging Cartridge*.*" -Destination ".\North America\Test Cartridges & Utilities"

Move-Item -Path ".\Other\*(*Arcade*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\*(*Anthology*)*.*" -Destination ".\Other\Alternate Releases\Collections"
Move-Item -Path ".\Other\*(*Capcom*Classics*Mini*Mix*)*.*" -Destination ".\Other\Alternate Releases\Collections"
Move-Item -Path ".\Other\*(*Collect*)*.*" -Destination ".\Other\Alternate Releases\Collections"
Move-Item -Path ".\Other\*(*Disney*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\*(*e-Reader*)*.*" -Destination ".\Other\Alternate Releases\eReader Edition"
Move-Item -Path ".\Other\*(*Final*Cut*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\*(*GameCube*)*.*" -Destination ".\Other\Alternate Releases\GameCube Edition"
Move-Item -Path ".\Other\*(*Genesis*Mini*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\*(*LodgeNet*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\*(*Namco*Museum*)*.*" -Destination ".\Other\Alternate Releases\Collections"
Move-Item -Path ".\Other\*(*PC*Rerelease*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\*(*Sega*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\*(*Switch*)*.*" -Destination ".\Other\Alternate Releases\Switch Online"
Move-Item -Path ".\Other\*(*Virtual*Console)*.*" -Destination ".\Other\Alternate Releases\Virtual Console"
Move-Item -Path ".\Other\*(*Wii*)*.*" -Destination ".\Other\Alternate Releases"
Move-Item -Path ".\Other\e-Reader (USA)*.*" -Destination ".\Other\Alternate Releases\eReader Edition"

Move-Item -Path ".\Other\2 Game Pack*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\2 Games in 1*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\2 Games in One*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\2 Great Games*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\2 in 1 Game Pack*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\2-in-1 Fun Pack*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\3 Game Pack*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\3 Games in 1*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\3 Games in One*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\4 Games on One Game Pak*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"
Move-Item -Path ".\Other\4 in 1 + 8 in 1*.*" -Destination ".\Other\Alternate Releases\Multi-Cart"

Move-Item -Path ".\Other\*(*Hack*)*.*" -Destination ".\Other\Hacks"

Move-Item -Path ".\Other\*(*Unl*)*.*" -Destination ".\Other\Unlicensed Releases"

Move-Item -Path ".\Other\*(*Beta*)*.*" -Destination ".\Other\Pre-Release\Beta"

Move-Item -Path ".\Other\River City Girls Zero*.*" -Destination ".\Other\Aftermarket Releases"
Move-Item -Path ".\Other\8-BIT ADV STEINS;GATE*.*" -Destination ".\Other\Aftermarket Releases"
Move-Item -Path ".\Other\*(*Pirate*)*.*" -Destination ".\Other\Aftermarket Releases"
Move-Item -Path ".\Other\*(*Aftermarket*)*.*" -Destination ".\Other\Aftermarket Releases"

Move-Item -Path ".\Other\*.*" -Destination ".\Other\Official Releases"


Write-Host "Sorting for Minor Release (Other) Regions Complete."

##################################################################
# Revisions
##################################################################

Write-Host "Parsing North American Revisions..."

#################################
# Region: North America
#################################

# Set the source and destination folder paths
$sourceFolder = ".\North America\Official Releases"
$destinationFolder = ".\North America\Previous Revisions"

# Get all the files in the source folder
$files = Get-ChildItem -Path $sourceFolder

# Create a hashtable to store the highest revision for each filename along with its extension
$highestRevisions = @{}

# Loop through each file in the source folder
foreach ($file in $files) {
    $filename = $file.BaseName  # Get the file name without extension

    # Check if the filename matches the pattern ' (Rev #)' or ' (Rev A)' and extract the revision
    if ($filename -match ' \(Rev ([A-Za-z0-9]+)\)') {
        $currentRevision = $Matches[1]  # Store the revision as a string

        $filename = $filename -replace ' \(Rev ([A-Za-z0-9]+)\)', ''  # Remove the revision from the filename
    }
    else {
        $currentRevision = '0'  # Set the default revision to '0' for filenames without the ' (Rev #)' pattern
    }

    $extension = $file.Extension  # Get the file extension

    # Check if the current file has a higher revision than the stored highest revision for the filename
    if (-not $highestRevisions.ContainsKey("$filename$extension") -or [string]$currentRevision -gt [string]$highestRevisions["$filename$extension"]["Revision"]) {
        $highestRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $currentRevision
            "Extension" = $extension
        }
    }
}

# Remove duplicate entries with lower "Highest Revision" strings from the $highestRevisions hashtable
$uniqueRevisions = @{}
foreach ($fileData in $highestRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($uniqueRevisions.ContainsKey("$filename$extension")) {
        $existingRevision = $uniqueRevisions["$filename$extension"]["Revision"]
        if ([string]$revision -gt [string]$existingRevision) {
            $uniqueRevisions["$filename$extension"] = @{
                "Filename" = $filename
                "Revision" = $revision
                "Extension" = $extension
            }
        }
    }
    else {
        $uniqueRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $revision
            "Extension" = $extension
        }
    }
}

# Set the path of the output text file
$outputFilePath = Join-Path -Path $sourceFolder -ChildPath "ReassembledFilenames.txt"

# Create an array to store filenames listed in the output text file
$listedFilenames = @()

# Display the reassembled filenames and highest revisions, write them to the output text file,
# and add them to the listedFilenames array
foreach ($fileData in $uniqueRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($revision -eq '0') {
        $reassembledFilename = "$filename$extension"
    }
    else {
        $reassembledFilename = "$filename (Rev $revision)$extension"
    }

    Write-Host "$filename, Highest Revision: $revision"

    # Append the reassembled filename to the output text file
    Add-Content -Path $outputFilePath -Value $reassembledFilename

    # Add the reassembled filename to the listedFilenames array
    $listedFilenames += $reassembledFilename
}

# Move files that are not listed in the output text file to the destination folder
foreach ($file in $files) {
    $filename = $file.Name

    if (-not $listedFilenames.Contains($filename)) {
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $filename
        Move-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Moved $filename to $destinationPath"
    }
}

# Delete the output text file
Remove-Item -Path $outputFilePath -Force

Write-Host "North American Revisions Parsed."

#################################
# Region: Japan
#################################

Write-Host "Parsing Japanese Revisions..."

# Set the source and destination folder paths
$sourceFolder = ".\Japan\Official Releases"
$destinationFolder = ".\Japan\Previous Revisions"

# Get all the files in the source folder
$files = Get-ChildItem -Path $sourceFolder

# Create a hashtable to store the highest revision for each filename along with its extension
$highestRevisions = @{}

# Loop through each file in the source folder
foreach ($file in $files) {
    $filename = $file.BaseName  # Get the file name without extension

    # Check if the filename matches the pattern ' (Rev #)' or ' (Rev A)' and extract the revision
    if ($filename -match ' \(Rev ([A-Za-z0-9]+)\)') {
        $currentRevision = $Matches[1]  # Store the revision as a string

        $filename = $filename -replace ' \(Rev ([A-Za-z0-9]+)\)', ''  # Remove the revision from the filename
    }
    else {
        $currentRevision = '0'  # Set the default revision to '0' for filenames without the ' (Rev #)' pattern
    }

    $extension = $file.Extension  # Get the file extension

    # Check if the current file has a higher revision than the stored highest revision for the filename
    if (-not $highestRevisions.ContainsKey("$filename$extension") -or [string]$currentRevision -gt [string]$highestRevisions["$filename$extension"]["Revision"]) {
        $highestRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $currentRevision
            "Extension" = $extension
        }
    }
}

# Remove duplicate entries with lower "Highest Revision" strings from the $highestRevisions hashtable
$uniqueRevisions = @{}
foreach ($fileData in $highestRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($uniqueRevisions.ContainsKey("$filename$extension")) {
        $existingRevision = $uniqueRevisions["$filename$extension"]["Revision"]
        if ([string]$revision -gt [string]$existingRevision) {
            $uniqueRevisions["$filename$extension"] = @{
                "Filename" = $filename
                "Revision" = $revision
                "Extension" = $extension
            }
        }
    }
    else {
        $uniqueRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $revision
            "Extension" = $extension
        }
    }
}

# Set the path of the output text file
$outputFilePath = Join-Path -Path $sourceFolder -ChildPath "ReassembledFilenames.txt"

# Create an array to store filenames listed in the output text file
$listedFilenames = @()

# Display the reassembled filenames and highest revisions, write them to the output text file,
# and add them to the listedFilenames array
foreach ($fileData in $uniqueRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($revision -eq '0') {
        $reassembledFilename = "$filename$extension"
    }
    else {
        $reassembledFilename = "$filename (Rev $revision)$extension"
    }

    Write-Host "$filename, Highest Revision: $revision"

    # Append the reassembled filename to the output text file
    Add-Content -Path $outputFilePath -Value $reassembledFilename

    # Add the reassembled filename to the listedFilenames array
    $listedFilenames += $reassembledFilename
}

# Move files that are not listed in the output text file to the destination folder
foreach ($file in $files) {
    $filename = $file.Name

    if (-not $listedFilenames.Contains($filename)) {
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $filename
        Move-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Moved $filename to $destinationPath"
    }
}

# Delete the output text file
Remove-Item -Path $outputFilePath -Force

Write-Host "Japanese Revisions Parsed."

#################################
# Region: Europe
#################################

Write-Host "Parsing European Revisions..."

# Set the source and destination folder paths
$sourceFolder = ".\Europe\Official Releases"
$destinationFolder = ".\Europe\Previous Revisions"

# Get all the files in the source folder
$files = Get-ChildItem -Path $sourceFolder

# Create a hashtable to store the highest revision for each filename along with its extension
$highestRevisions = @{}

# Loop through each file in the source folder
foreach ($file in $files) {
    $filename = $file.BaseName  # Get the file name without extension

    # Check if the filename matches the pattern ' (Rev #)' or ' (Rev A)' and extract the revision
    if ($filename -match ' \(Rev ([A-Za-z0-9]+)\)') {
        $currentRevision = $Matches[1]  # Store the revision as a string

        $filename = $filename -replace ' \(Rev ([A-Za-z0-9]+)\)', ''  # Remove the revision from the filename
    }
    else {
        $currentRevision = '0'  # Set the default revision to '0' for filenames without the ' (Rev #)' pattern
    }

    $extension = $file.Extension  # Get the file extension

    # Check if the current file has a higher revision than the stored highest revision for the filename
    if (-not $highestRevisions.ContainsKey("$filename$extension") -or [string]$currentRevision -gt [string]$highestRevisions["$filename$extension"]["Revision"]) {
        $highestRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $currentRevision
            "Extension" = $extension
        }
    }
}

# Remove duplicate entries with lower "Highest Revision" strings from the $highestRevisions hashtable
$uniqueRevisions = @{}
foreach ($fileData in $highestRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($uniqueRevisions.ContainsKey("$filename$extension")) {
        $existingRevision = $uniqueRevisions["$filename$extension"]["Revision"]
        if ([string]$revision -gt [string]$existingRevision) {
            $uniqueRevisions["$filename$extension"] = @{
                "Filename" = $filename
                "Revision" = $revision
                "Extension" = $extension
            }
        }
    }
    else {
        $uniqueRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $revision
            "Extension" = $extension
        }
    }
}

# Set the path of the output text file
$outputFilePath = Join-Path -Path $sourceFolder -ChildPath "ReassembledFilenames.txt"

# Create an array to store filenames listed in the output text file
$listedFilenames = @()

# Display the reassembled filenames and highest revisions, write them to the output text file,
# and add them to the listedFilenames array
foreach ($fileData in $uniqueRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($revision -eq '0') {
        $reassembledFilename = "$filename$extension"
    }
    else {
        $reassembledFilename = "$filename (Rev $revision)$extension"
    }

    Write-Host "$filename, Highest Revision: $revision"

    # Append the reassembled filename to the output text file
    Add-Content -Path $outputFilePath -Value $reassembledFilename

    # Add the reassembled filename to the listedFilenames array
    $listedFilenames += $reassembledFilename
}

# Move files that are not listed in the output text file to the destination folder
foreach ($file in $files) {
    $filename = $file.Name

    if (-not $listedFilenames.Contains($filename)) {
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $filename
        Move-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Moved $filename to $destinationPath"
    }
}

# Delete the output text file
Remove-Item -Path $outputFilePath -Force

Write-Host "European Revisions Parsed."

#################################
# Region: Other (Minor Release Regions)
#################################

Write-Host "Parsing Minor Release Region (Other) Revisions"

# Set the source and destination folder paths
$sourceFolder = ".\Other\Official Releases"
$destinationFolder = ".\Other\Previous Revisions"

# Get all the files in the source folder
$files = Get-ChildItem -Path $sourceFolder

# Create a hashtable to store the highest revision for each filename along with its extension
$highestRevisions = @{}

# Loop through each file in the source folder
foreach ($file in $files) {
    $filename = $file.BaseName  # Get the file name without extension

    # Check if the filename matches the pattern ' (Rev #)' or ' (Rev A)' and extract the revision
    if ($filename -match ' \(Rev ([A-Za-z0-9]+)\)') {
        $currentRevision = $Matches[1]  # Store the revision as a string

        $filename = $filename -replace ' \(Rev ([A-Za-z0-9]+)\)', ''  # Remove the revision from the filename
    }
    else {
        $currentRevision = '0'  # Set the default revision to '0' for filenames without the ' (Rev #)' pattern
    }

    $extension = $file.Extension  # Get the file extension

    # Check if the current file has a higher revision than the stored highest revision for the filename
    if (-not $highestRevisions.ContainsKey("$filename$extension") -or [string]$currentRevision -gt [string]$highestRevisions["$filename$extension"]["Revision"]) {
        $highestRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $currentRevision
            "Extension" = $extension
        }
    }
}

# Remove duplicate entries with lower "Highest Revision" strings from the $highestRevisions hashtable
$uniqueRevisions = @{}
foreach ($fileData in $highestRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($uniqueRevisions.ContainsKey("$filename$extension")) {
        $existingRevision = $uniqueRevisions["$filename$extension"]["Revision"]
        if ([string]$revision -gt [string]$existingRevision) {
            $uniqueRevisions["$filename$extension"] = @{
                "Filename" = $filename
                "Revision" = $revision
                "Extension" = $extension
            }
        }
    }
    else {
        $uniqueRevisions["$filename$extension"] = @{
            "Filename" = $filename
            "Revision" = $revision
            "Extension" = $extension
        }
    }
}

# Set the path of the output text file
$outputFilePath = Join-Path -Path $sourceFolder -ChildPath "ReassembledFilenames.txt"

# Create an array to store filenames listed in the output text file
$listedFilenames = @()

# Display the reassembled filenames and highest revisions, write them to the output text file,
# and add them to the listedFilenames array
foreach ($fileData in $uniqueRevisions.Values) {
    $filename = $fileData["Filename"]
    $revision = $fileData["Revision"]
    $extension = $fileData["Extension"]

    if ($revision -eq '0') {
        $reassembledFilename = "$filename$extension"
    }
    else {
        $reassembledFilename = "$filename (Rev $revision)$extension"
    }

    Write-Host "$filename, Highest Revision: $revision"

    # Append the reassembled filename to the output text file
    Add-Content -Path $outputFilePath -Value $reassembledFilename

    # Add the reassembled filename to the listedFilenames array
    $listedFilenames += $reassembledFilename
}

# Move files that are not listed in the output text file to the destination folder
foreach ($file in $files) {
    $filename = $file.Name

    if (-not $listedFilenames.Contains($filename)) {
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $filename
        Move-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Moved $filename to $destinationPath"
    }
}

# Delete the output text file
Remove-Item -Path $outputFilePath -Force

Write-Host "Minor Regions Revisions Parsed."

#################################
# Completion
#################################

Write-Host "ROM Parsing Complete!"

##############################################################################################################################################################################################################
# FUNCTIONS END
##############################################################################################################################################################################################################