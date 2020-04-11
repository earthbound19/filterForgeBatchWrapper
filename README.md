# filterForgeBatchWrapper
Wraps Filter Forge's command line tool (`FFXCmdRenderer-x86.exe` or `FFXCmdRenderer-x64.exe` at this writing), to make it simpler to render many image files from a folder in one go (batch), with any variety of applied filters, including by drag-and-drop of an images source folder onto this executable (`ffBatch.exe`) or script (~`.ahk`).

## Usage
See [`FilterForgeBatchWrapper_Help.pdf`](FilterForgeBatchWrapper_Help.pdf)

## License
Public Domain. See [`LICENSE.txt`](LICENSE.txt).

## Source code
[`https://github.com/earthbound19/filterForgeBatchWrapper`](https://github.com/earthbound19/filterForgeBatchWrapper)

## Dependencies
Filter Forge command-line renderer, `GNUwin32sed.exe` (included and renamed from GNUwin32 CoreUtils), source images which you provide and use this tool to create other images from (the whole point).

## Known issues
- It will not render user presets (presets that are in a separate "My Presets" folder of Filter Forge user folders). It will only render presets that are hard-coded into a filter. In testing a direct command line render and custom xml/.ffxml set for this with Filter Forge 7, this appeared to be a limitation of the Filter Forge command-line renderer itself. For help baking presets into a filter, see 
- Since you can drag and drop a folder with images onto `ffBatch.exe` and it will render output in an `ff_output` subfolder of that folder, you might expect similar behavior if you drag and drop images onto `ffBatch.exe`. This is not the case. This doom was had after miserable trying and silly frustration 2020-04-09, in quarantine.
- Despite some bug fixes for the issue, it may still be that source image and .ffxml file names that include spaces in the file name could fail to render. It's a good idea to always make your file names internet friendly to begin with; it solves this and other problems.
- The information dialog after a batch render may give counts for events that did not actually happen, given various combinations of False/True options in the [yourComputerName].ini file. To my knowledge, however, all intended renders do happen (if files are names properly).

## Bug reports and feature requests
Open an issue in the GitHub repo's issue tracker.

# Release history

## 0.9.7.3
Critical bug fix, feature changes.

- Fixed: critical file `FilterForgeBatchTemplate.xml` restored. This program can't have worked for anyone who tried it :(
- changed default paths to FF7
- render PNGs (with default transparency) instead of TIFs
- Project deleted from SourceForge. Clone this repo and that is the latest and greatest (executable included in git repo)
- README.md updated and format improved.

## 0.9.7.2
Expanded/improved documentation.

## 0.9.7
Bug fixes and feature additions.

- Fixed: source image file names with spaces in the file name caused failed renders.
- Drag and drop a folder onto ffBatch.exe to override the render path subfolders to that directory (results will render to a new ff_output subfolder of that folder, etc).
- Option to render only one filter for each source file, the filter being randomly selected anew for each image. Enabled if Render Only One Random Filter Per Image in the .ini file is set to True.

## 0.9.6
10/28/2015 and prior to 11/09/2015 09:34:30 PM -RAH

Bug fixes and feature changes.

- Fixed: renders failed for .ffxml filter file names that include spaces in the file name. No more.
- New features, via .ini settings:
  - Variation Randomization Range=[(min.)1-(max.)30000]
  - Sort Source After Render=[True|False] into _rendered subfolder to avoid duplicate renders
  - Save Generated XML and FFXML=[True|False].

## 0.9.1
09/04/2015 03:02:01 PM -RAH

First release, essential features complete. Program first in satisfactory shape for use for my purposes. 

# TO DO
- Fix can't drag and drop images directly onto executable and get renders (re Known issues). Utilize the loop over folders/files function given [over here](https://www.autohotkey.com/docs/commands/LoopFile.htm) to do so (in test code I found that I must first loop over %0%, then loop over the 1st param with mode `D`, then loop over the first result of that and `\*`.)
- Add notes (in documentation) about custom presets [from here](https://www.filterforge.com/forum/read.php?FID=8&TID=15506&MID=150867#message150867)
- Helpful error messages about wrong paths in INI, or what else?
- Automatically build a filter list (to invoke via copy/paste from generated list into .ini file/summat) (A note here said I had that in development?) (Is this a redundant to do item?)
- Distinguish custom users filters from installed filters (or simply list all of them); specify custom filter by full path.
	- A hurdle to overcome with this is that as of Filter Forge version X (uknown--I see it in 7), user presets for filters are stored in ~`\AppData\Roaming\Filter Forge 7\My Presets`, and the command line renderer doesn't use them if you put the _apparent_ preset number (from the preset list view in Filter Forge) in the `.ini` file.
- Anything tagged "TO DO" in any comment in any file (especially the source .ahk file), for which any of the following might be redundant:
- It would be nice to list filter forge filters by name instead of file name in FFilterList.txt--and have a file search utility index the archive of filters by name matches therein, and automagically substitute the name for the proper path to that filter xml file.
- It would be awesome to have wrapper scripting/.ini settings to randomly vary arbitrary preset control names (depending on what any given filter offers), including giving the range for randomization (per control name parameters in filters).
- Override preset used per filter, via console, or .ini file or summat.
- Should a source images list (besides perhaps a temp file) even be generated--doesn't this just do all of that in memory regardless?
- Retroactive version releases in GitHub and move these notes there? Feasible? Git history etc. detailed enough to support?
- Toast `sourceImagesList.txt` and other (?) extraneous tracked files from git history (and untrack them and add them to `.gitignore` if need be)
- set up a project tracker at GitHub?

# For developers
I welcome pull requests for new features or bug fixes.

This program may only function as intended if compiled with the newest version of 64-bit AutoHotkey downloadable from ahkscript.org (forget autohotkey.com--MIA, that).

This program works by adapting a batch template, `FilterForgeBatchTemplate.xml`, to specify the images provided by you (via drag and drop of a folder onto `ffBatch.exe`, or by double-clicking that `.exe` with images in a `srcImg` folder in the same directory), as well as the filters to use, all via automagic search-replace mumbo-jumbo scripted with `ffBatch.ahk` (and compiled into an executable). That ~`.ahk` is an AutoHotkey script (see [autohotkey.com](https://www.autohotkey.com/)), compiled via `Ahk2exe.exe` (provided with AutoHotkey), iconified with an image created by yours truly via Filter Forge, with a batch script (`call-ahkrip.bat`) to accomplish the same. I provide the source code with the hope that if you want additional features I haven't the resources to program ;) that you may do so yourself.

An example working ff cmd render command (it goes all on one line, but this is broken into multiple lines to be better viewable) :

`"C:\Program Files\Filter Forge 7\Bin\FFXCmdRenderer-x64.exe"`
`"C:\Users\<Your username>\Documents\tst2.png_ff_Library_14934-1.ffxml_pre20_var6126.xml"`

The xml file must reference a .ffxml file which is (I think?) actually just a stripped down copy of a filter. I don't know where I documented how this works; obviously the .ahk script / compiled to an .exe makes it work. Here is [a Filter Forge help web page](https://www.filterforge.com/more/help/Miscellaneous/CommandLineRenderer.html) about the command line renderer. Note that errors are logged to a file named `FFX CmdRenderer.log`.

Filter preset indexing begins at `0`; preset `0` is the first preset displayed by Filter Forge's preset preview.