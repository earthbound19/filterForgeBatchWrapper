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

## Release history

### 0.9.7.3
Critical bug fix, feature changes.

- Fixed: critical file `FilterForgeBatchTemplate.xml` restored. This program can't have worked for anyone who tried it :(
- changed default paths to FF7
- render PNGs (with default transparency) instead of TIFs
- Project deleted from SourceForge. Clone this repo and that is the latest and greatest (executable included in git repo)
- README.md updated and format improved.

### 0.9.7.2
Expanded/improved documentation.

### 0.9.7
Bug fixes and feature additions.

- Fixed: source image file names with spaces in the file name caused failed renders.
- Drag and drop a folder onto ffBatch.exe to override the render path subfolders to that directory (results will render to a new ff_output subfolder of that folder, etc).
- Option to render only one filter for each source file, the filter being randomly selected anew for each image. Enabled if Render Only One Random Filter Per Image in the .ini file is set to True.

### 0.9.6
10/28/2015 and prior to 11/09/2015 09:34:30 PM -RAH

Bug fixes and feature changes.

- Fixed: renders failed for .ffxml filter file names that include spaces in the file name. No more.
- New features, via .ini settings:
  - Variation Randomization Range=[(min.)1-(max.)30000]
  - Sort Source After Render=[True|False] into _rendered subfolder to avoid duplicate renders
  - Save Generated XML and FFXML=[True|False].

### 0.9.1
09/04/2015 03:02:01 PM -RAH

First release, essential features complete. Program first in satisfactory shape for use for my purposes. 

# Development Notes and TO DO

## TO DO
- Automatically build a filter list (to invoke via copy/paste from generated list into .ini file/summat) (A note here said I had that in development?) (Is this a redundant to do item?)
- Distinguish custom users filters from installed filters (or simply list all of them); specify custom filter by full path.
	- A hurdle to overcome with this is that as of Filter Forge version X (uknown--I see it in 7), user presets for filters are stored in ~`\AppData\Roaming\Filter Forge 7\My Presets`, and the command line renderer doesn't use them if you put the _apparent_ preset number (from the preset list view in Filter Forge) in the `.ini` file.
- Anything tagged "TO DO" in any comment in any file (especially the source .ahk file), for which any of the following might be redundant:
- It would be nice to list filter forge filters by name instead of file name in FFilterList.txt--and have a file search utility index the archive of filters by name matches therein, and automagically substitute the name for the proper path to that filter xml file.
- It would be awesome to have wrapper scripting/.ini settings to randomly vary arbitrary preset control names (depending on what any given filter offers), including giving the range for randomization (per control name parameters in filters).
- Override preset used per filter, via console, or .ini file or summat.
- Should a source images list (besides perhaps a temp file) even be generated--doesn't this just do all of that in memory regardless?
- Retroactive version releases in GitHub and move these notes there? Feasible? Git history etc. detailed enough to support?

## Known issues
- Despite some bug fixes for the issue, it may still be that source image and .ffxml file names that include spaces in the file name could fail to render. It's a good idea to always make your file names internet friendly to begin with; it solves this and other problems.
- The information dialog after a batch render may give counts for events that did not actually happen, given various combinations of False/True options in the [yourComputerName].ini file. To my knowledge, however, all intended renders do happen (if files are names properly).

## Bug reports and feature requests
Open an issue in the GitHub repo's issue tracker.

## Note for developers
This program may only function as intended if compiled with the newest version of 64-bit AutoHotkey downloadable from ahkscript.org (forget autohotkey.com--MIA, that).