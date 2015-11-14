# filterForgeBatchWrapper
Wraps Filter Forge's command line tool (FFXCmdRenderer-x86.exe at this writing), to make it simpler to render many image files from a folder in one go (batch), with any variety of applied filters, including by drag-and-drop of an images source folder onto this executable (ffBatch.exe) or script (~.ahk).

### USAGE
See FilterForgeBatchWrapper_Help.pdf, archived in FilterForgeBatchWrapperDist.7z, which you must extract using e.g. 7-zip (http://www.7-zip.org/).

### LICENSE
See LICENSE.txt.

### DEPENDENCIES
Filter Forge command-line renderer, sed from GNUwin32 CoreUtils (included--or use any other compatible sed package, possibly for example from cygwin, etc), source images.

# RELEASE HISTORY

V. 0.9.7 FEATURE ADDITIONS and BUG FIXES
Drag and drop a folder onto ffBatch.exe to override the render path subfolders to that directory (results will render to a new ff_output subfolder of that folder, etc). Option to render only one filter for each source file, the filter being randomly selected anew for each image. Enabled if Render Only One Random Filter Per Image in the .ini file is set to True. BUG FIX: Source image file names with spaces in the file name caused failed renders.

V. 0.9.6 FEATURE ADDITIONS and BUG FIXES
New features, via .ini settings: Variation Randomization Range=[(min.)1-(max.)30000], Sort Source After Render=[True|False] into _rendered subfolder to avoid duplicate renders, Save Generated XML and FFXML=[True|False]. BUG FIX: Renders failed for .ffxml filter file names that include spaces in the file name. No more. 10/28/2015 and prior to 11/09/2015 09:34:30 PM -RAH

V. 0.9.1 ESSENTIAL FEATURES COMPLETE
Program first in satisfactory shape for use for my purposes. 09/04/2015 03:02:01 PM -RAH

## Development Notes and TO DO

### TO DO
Distinguish custom users filters from installed filters (or simply list all of them); specify custom filter by full path.

Anything tagged "TO DO" in any comment in any file (especially the source .ahk file), for which any of the following might be redundant:

It would be nice to list filter forge filters by name instead of file name in FFilterList.txt--and have a file search utility index the archive of filters by name matches therein, and automagically substitute the name for the proper path to that filter xml file.

It would be awesome to have wrapper scripting/.ini settings to randomly vary arbitrary preset control names (depending on what any given filter offers), including giving the range for randomization (per control name parameters in filters).

Override preset used per filter, via console, or .ini file or summat.

Drag-and-drop any folder onto FFbatch.exe to render all images in it (including in subfolders) -- if this is already programmed (I don't recall) verify whether it works; if not, fix.

Create default .ini file (if not present) without terminating program.

Should a source images list (besides perhaps a temp file) even be generated--doesn't this just do all of that in memory regardless?

### KNOWN ISSUES
Despite some bug fixes for the issue, it may still be that source image and .ffxml file names that include spaces in the file name could fail to render. It's a good idea to always make your file names internet friendly to begin with; it solves this and other problems.

The information dialog after a batch render may give counts for events that did not actually happen, given various combinations of False/True options in the [yourComputerName].ini file. To my knowledge, however, all intended renders do happen (if files are names properly).

### BUG REPORTS and FEATURE REQUESTS
Please contact me via the afore provided URL. Don't necessarily expect any resolution of your request unless you program it yourself (which is why I provide the AutoHotkey source code).

### NOTE FOR DEVELOPERS
This program may only function as intended if compiled with the newest version of 64-bit AutoHotkey downloadable from ahkscript.org (forget autohotkey.com--MIA, that).

### IN DEVELOPMENT
Automatically build a filter list (to invoke via copy/paste from generated list into .ini file/sommat).