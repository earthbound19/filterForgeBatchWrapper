#NoEnv
SetWorkingDir %A_ScriptDir%
#SingleInstance force

; BEGIN GLOBALS =================
; #include buildFFfilterIndex.ahk.txt

; Horked from: http://ahkscript.org/forum/viewtopic.php?p=63604&sid=510cf82868f13f5e8ea57cf750d7957e
; Function which removes illegal characters from a variable, after replacing all spaces with underscores.
varize(var)
{
   stringreplace,var,var,%A_space%,_,a
   ; NOTE: the double-quote mark was removed from the following chars list.
   chars = .,<>:;'/|\(){}=-+!`%^&*~#
   loop, parse, chars,
      stringreplace,var,var,%A_loopfield%,,a
   return var
}

; Horked from: http://autohotkey.com/board/topic/69753-if-folder-empty/?p=441649
; Checks if a directory is empty; returns 1 if it is:
IsEmpty(Dir) {
	Loop %Dir%\*.*, 0, 1
		return 0
	return 1
}


; DEV-ONLY INCLUDE: COMMENT OUT FOR DISTRIBUTION:
; ---- AUTO-RELOAD INCLUDE . . . if it works; maybe due to a change in a newer version of autoHotkey it stopped working? :/ 04/28/2015 09:05:31 PM -RAH
; ---- Reload this script and restart execution whenever CTRL+ALT+? (/) is typed:
; #Persistent		; So that auto-reload include will even work (because the script is still running).
; GoSub START
; #Include C:\_devtools\include\devReloadOnSave.ahk
; START:
; ---- END AUTO-RELOAD INCLUDE
; END DEV-ONLY INCLUDE: DELETE UPON DISTRIBUTION

; TO DO: Put the filter forge command-line renderer in the user's path temporarily ("on the fly")?

; INI FILENAME
EnvGet, ComputerName, COMPUTERNAME
iniFileName=%A_ScriptDir%\ffBatch_%ComputerName%.ini
; END GLOBALS =====================
; =================================


; IF THERE IS NO FFBATCH.INI, CREATE A DEFAULT ONE.
; reference: IniWrite, this is a new value, C:\Temp\myfile.ini, section2, key
		;[Global Paths] SECTION
IfExist, %iniFileName%
	{
	fileExists = 1
			 ; MsgBox, ini file exists, will not overwrite.
	}
	Else
	{
	fileExists = 0
			; MsgBox, file does not exist, will create anew (and empty).
	FileAppend,, %iniFileName%
	}
; --- DEV OVERRIDES: COMMENT OUT FOR PRODUCTION: ---
; --- REMEMBER: IF THE SCRIPT MISBEHAVES, IT MAY BE THAT YOU FORGOT TO COMMENT THESE OUT! ---
			;FileDelete, %iniFileName%
			;fileExists = 0

; DEV TESTING ONLY, next line (comment out or delete in production) :
; FileDelete, %iniFileName%
; Sleep, 200

If (%fileExists% == 0)
	{
; TO DO? : have this conditional for each possible item in the .ini, meaning, check for and create (if necessary) each .ini setting?
	EnvGet, Roaming, APPDATA
	IniWrite, C:\Program Files (x86)\Filter Forge 4\Bin\FFXCmdRenderer-x86.exe, %iniFileName%, Paths, FFXCmdRenderer-x86.exe with PATH
; TO DO: Make the following so (it's something else for now), after coding filter auto-indexing and copy/paste:
	; IniWrite, %A_ScriptDir%\FF_installed_filter_names.txt, %iniFileName%, Paths, Filter List File Name
	IniWrite, %A_ScriptDir%\FFfilterList.txt, %iniFileName%, Paths, Filter List File Name
	IniWrite, %A_ScriptDir%\FilterForgeBatchTemplate.xml, %iniFileName%, Paths, Filter Forge Batch Template XML file
	IniWrite, %A_ScriptDir%, %iniFileName%, Paths, Working Directory
	IniWrite, %Roaming%\Filter Forge 4\System\Library, %iniFileName%, Paths, Filters Library Path
	IniWrite, %Roaming%\Filter Forge 4\My Filters, %iniFileName%, Paths, My Filters Path
	IniWrite, %A_ScriptDir%\srcImg, %iniFileName%, Paths, Source Images Directory
	IniWrite, %A_ScriptDir%\sourceImagesList.txt, %iniFileName%, Paths, Source Images List File
; TO DO? : make an option for a per image file path? First do default to /ff_output?
	IniWrite, %A_ScriptDir%\ff_output, %iniFileName%, Paths, Result Images Directory
	; Note the backtick ` character in the next line of code, escaping the semicolon character, likewise for commas in later .ini comments.
	; FileAppend, `; Note that the next line is irrelevant if Save Generated XML Batch File=False in the [Options] section., %iniFileName%
	iniWrite, %A_ScriptDir%\ff_output\XML_FFXMLbatches, %iniFileName%, Paths, XML and FFXML Batch File Save Directory
		;[Options] SECTION:
	iniWrite, 1, %iniFileName%, Options, Global Filter Preset Number Override
	; FileAppend, `; bJALIEFHOIJ Note that if you only want one specific variation number`, you may set the following variable to e.g. Variation Randomization Range=3-3, %iniFileName%
	iniWrite, 1-30000, %iniFileName%, Options, Variation Randomization Range
	iniWrite, Hide, %iniFileName%, Options, Rendering Console Visibility
	; FileAppend, `; The options for all of the following are True or anything else (anything else will be seen as false):, %iniFileName%
	iniWrite, False, %iniFileName%, Options, Keep Generated XML And FFXML Batch And Filter Settings Files
	iniWrite, False, %iniFileName%, Options, Randomly Shuffle Source Images List
	iniWrite, False, %iniFileName%, Options, Randomly Shuffle Filter List File Names
	iniWrite, False, %iniFileName%, Options, Render Only One Random Filter Per Image
	; FileAppend, `; Controls whether source images are shuffled into a new _rendered subfolder (to avoid re-rendering with a different variation), as this batch tool scans and renders against all images in the source directory--but it doesn't render files in subfolders of a given directory; ALSO NOTE that if this is used with multiple filters in the list`, it will only render one of the filters per image (perhaps randomly, which could be cool, depending on your purposes) :
	iniWrite, False, %iniFileName%, Options, Sort Source After Render
/*
; TO DO? : Actually something with the below (see other notes)?
	;[Filter #(s)] SECTION:
		; Filter 1 default
	IniWrite, Bacteria, %iniFileName%, Filter 1, Filter
	IniWrite, 5, %iniFileName%, Filter 1, Preset
	IniWrite, Installed, %iniFileName%, Filter 1, Locale
	IniWrite, 27761, %iniFileName%, Filter 1, Variation
		; Filter 2 default
	IniWrite, Metal Storm, %iniFileName%, Filter 2, Filter
	IniWrite, 4, %iniFileName%, Filter 2, Preset
	IniWrite, Installed, %iniFileName%, Filter 2, Locale
	IniWrite, Random, %iniFileName%, Filter 2, Variation
*/
	; For undetermined reasons, this doesn't render all files as it should if we simply continue after creating the default .ini file; only *reloading* the script/executable allows it to properly work:
	Reload
	}

; READ INI FILE VALUES INTO LOCAL VALUES.
	;Reference: IniRead, OutputVar, Filename, Section, Key [, Default]
	IniRead, FFXCmdRendererX86exeWithPATH, %iniFileName%, Paths, FFXCmdRenderer-x86.exe with PATH
	IniRead, filterListFileName, %iniFileName%, Paths, Filter List File Name
	IniRead, FilterForgeBatchTemplateXMLfile, %iniFileName%, Paths, Filter Forge Batch Template XML file
	IniRead, workingDirectory, %iniFileName%, Paths, Working Directory
	IniRead, filtersLibraryPath, %iniFileName%, Paths, Filters Library Path
	IniRead, myFiltersPath, %iniFileName%, Paths, My Filters Path
	IniRead, sourceImagesDirectory, %iniFileName%, Paths, Source Images Directory
	IniRead, sourceImagesListFile, %iniFileName%, Paths, Source Images List File
	IniRead, resultImagesDirectory, %iniFileName%, Paths, Result Images Directory
	IniRead, XML_and_FFXMLbatchSaveDirectory, %iniFileName%, Paths, XML and FFXML Batch File Save Directory
		;[Options] SECTION:
	IniRead, randomlyShuffleSourceImagesList, %iniFileName%, Options, Randomly Shuffle Source Images List
	IniRead, randomlyShuffleFilterListFileNames, %iniFileName%, Options, Randomly Shuffle Filter List File Names
	IniRead, globalFilterPresetNumberOverride, %iniFileName%, Options, Global Filter Preset Number Override
	IniRead, renderingConsoleVisibility, %iniFileName%, Options, Rendering Console Visibility
	IniRead, variationRandomizationRange, %iniFileName%, Options, Variation Randomization Range
; TO DO: Set the following to an automatic default if no option in .ini? :
	IniRead, saveXMLandFFXML, %iniFileName%, Options, Keep Generated XML And FFXML Batch And Filter Settings Files
	IniRead, renderOnlyOneRandomFilterPerImage, %iniFileName%, Options, Render Only One Random Filter Per Image
	IniRead, sortSourceAfterRender, %iniFileName%, Options, Sort Source After Render


	; If a parameter is passed to this script (being and expected to be a directory), override sourceImagesDirectory with the value of it (and respectively, resultImagesDirectory and XML_and_FFXMLbatchSaveDirectory to include it). Thanks to someone at: http://autohotkey.com/boards/viewtopic.php?t=2468
	params := Object()

	Loop %0%  ; For each parameter (or file dropped onto a script):
	{
		GivenPath := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
		Loop %GivenPath%, 1
			LongPath = %A_LoopFileLongPath%
		; MsgBox The case-corrected long path name of file`n%GivenPath%`nis:`n%LongPath%
		params.Push(LongPath)
		; MsgBox, inserted into params object.
	}
	If (params[1])
	{
	sourceImagesDirectory := params[1]
	resultImagesDirectory = %sourceImagesDirectory%\ff_output
	XML_and_FFXMLbatchSaveDirectory = %resultImagesDirectory%\XML_FFXMLbatches
			; MsgBox, sourceImagesDirectory val is:`n%sourceImagesDirectory%`n`nresultImagesDirectory val is:`n%resultImagesDirectory%`n`nXML_and_FFXMLbatchSaveDirectory val is:`n%XML_and_FFXMLbatchSaveDirectory%
	}

; TO DO? : SYNC ffxml FILTERS (between computers) IF .INI FILE SAYS TO; *never deleting files,* only copying new files.
	; SEE IF LOOP CAN LIST INI SLAVES IN READ.
; Would use e.g. IniRead,...Filters Library Path?

; TO DO: enable this (including by uncommenting the necessary include line near the start of this script):
; buildFFfilterListIndex()


;Controls for whether to show or hide console windows executed from this program. If they are shown, they will interrupt navigation every time a render completes = annoying. Options are: Show, Hide. Value set from given option in .ini file; if no such option expressed, written to .ini file and executed as default Hide. I could not get this dang comparison to work until I did it the way shown here; it seems to compare ok with either the = or == operator: http://ahkscript.org/boards/viewtopic.php?t=2399 09/02/2015 11:27:31 PM -RAH
checkVar = Hide
if (renderingConsoleVisibility == checkVar){
    whetherHide = %renderingConsoleVisibility%
	SplashImage,, b1 cw008000 ctffff00, ffBatch is in Hide mode via .ini file. You will not see the render console.
	Sleep, 5312
	SplashImage, Off
}
checkVar = Min
if (renderingConsoleVisibility == checkVar){
    whetherHide = %renderingConsoleVisibility%
	SplashImage,, b1 cw008000 ctffff00, ffBatch is in Min (or "minimize--") mode via .ini file. Render consoles may interrupt your activity.
	Sleep, 5312
	SplashImage, Off
}
checkVar = Show
if (renderingConsoleVisibility == checkVar){
    whetherHide = %renderingConsoleVisibility%
	SplashImage,, b1 cw008000 ctffff00, ffBatch is in Show mode via .ini file. Render consoles may interrupt your activity.
	Sleep, 5312
	SplashImage, Off
}
If showRenderingConsole = ERROR
	{
	MsgBox, No setting (or incorrect setting) in .ini file for whether to hide render console window. Wrote default Hide option (the other options are Show and Min), and going with that.
	whetherHide = Hide
	}


; CHECK FOR INI PRESET ERROR, and advise user if so.
; TO DO? FIX: Eh, should that be (... == ERROR)? It works anyway:
If globalFilterPresetNumberOverride = ERROR
	{
	MsgBox, There is no proper value for Global Filter Preset Number Override. Create one in the [Options] section of:`n`n %iniFileName%`n`nLike so:`n`nGlobal Filter Preset Number Override=2`n`nWhere 2 (or any other number) is the number of the preset which you wish to use for every filter. If you wish to specify a preset per filter you must either program that yourself (the source code and compiler are freely available) or bother me the mysterious . . . computer . . . and/or programmer. I plan to add that functionality in a future program update. You might also try talking to . . . me or the computer . . . and see if it or I seemingly magically and suddenly does or do . . . es what you wish.
	Exit	;Do not pass Go, do not collect $200.
	}
	Else
	{
; TO DO: Something here or there assigning this value per filter file, via .ini file settings or otherwise.
	presetValue = %globalFilterPresetNumberOverride%
	}


; CREATE SOURCE IMAGE LIST.
; TO DO? : rework the next code line via AutoHotkey functionality? Won't work as a file loop because of the shuffling option/requirement.
; OR do away with the file list anyhoo?
; List files sorted by date (oldest first), but not directories, thanks to someone yon: http://stackoverflow.com/a/7164243/1397555
RunWait, %comspec% /C "DIR /B /A-D /OD %sourceImagesDirectory% > %sourceImagesListFile%", workingDirectory, %whetherHide%

; IF THE INI SAYS SO, randomly shuffle the source images list array.
If (%randomlyShuffleFilterListFileNames% == True)
{
	; Reworked to simply use an external tool after a failed attempt at randomly shuffling an AHK array. 11/03/2015 07:25:17 PM -RAH
; MsgBox, command:`n`n RunWait, CygwinShuf.exe %sourceImagesListFile% > temp.txt, %workingDirectory%, %whetherHide%
	; Prior used, accomplishes same: CygwinSort.exe --random-sort ~
RunWait, %comspec% /C "%workingDirectory%\CygwinShuf.exe `"%sourceImagesListFile%`" > `"%workingDirectory%\temp.txt`"", %workingDirectory%, %whetherHide%
FileMove, temp.txt, %sourceImagesListFile%, 1
}
; READ SOURCE IMAGE LIST INTO A STRING ARRAY.
	;Reference: http://ahkscript.org/docs/misc/Arrays.htm
	;Initialize an empty array:
sourceImagesListArray := Object()
	; Read from a text file into the array:
Loop, Read, %sourceImagesListFile%		; This loop retrieves each line from the file, one at a time.
{
	; check for space character here, or fix bug that isnissts on not hainvg them alfready.
							; FoundPos := RegExMatch(Haystack, " ")
							; If (FoundPos > 0)
								; {
								; MsgBox, affirmative, space character found.
								; }
								; Else
								; {
								; MsgBox, negatory, space character not found.
								; }
    sourceImagesListArray.Insert(A_LoopReadLine)		; Append this line to the array.
}


; IF THE INI FILE SO INSTRUCTS, DYNAMICALLY RANDOMLY SHUFFLE, once, the items in the filter list. NOTE That this only changes the ordered of rendered filters, and that all renders would still complete. (Shuffling the filters at every render would unpredictably cause not all filters to render. Also note that if the .ini file [Options] section has the setting Sort Source After Render=True, it would also fail to render all source images anyway.)
If (%RandomlyShuffleFilterListFileNames% == True)	; With the monstrous variable name.
{
RunWait, %comspec% /C "%workingDirectory%\CygwinShuf.exe `"%filterListFileName%`" > `"%workingDirectory%\temp.txt`"", %workingDirectory%, %whetherHide%
FileMove, temp.txt, %filterListFileName%, 1
}
; END IF THE INI SAYS SO..
filterListArray := Object()
Loop, Read, %filterListFileName%
{
    filterListArray.Insert(A_LoopReadLine)
}


; CREATE REFERENCE ARRAY for filterListArray, which stores how many presets there are in each filter.
	; TO DO? : for other wanted features, simply check this when any filter is loaded (instead of creating a reference away, which will be unrealiable if we e.g. change the order of or randomly select the filter we want)? NOTE: This may require substantial code reorganization/rewrite. 11/12/2015 04:53:34 PM -RAH
filterPresetCountsArray := Object()
for filterListArrayIndex, filterFileName in filterListArray
{
filterListArrayMaxIndex := filterListArray._MaxIndex()
; CHECK IF THE PROPOSED FILTER FILE TO RENDER FROM EVEN HAS THE PROPOSED PRESET NUMBER, and if it doesn't, use the default fitler (1) instead, and notify the user of the fact (which is done and mentioned in later code and comments).
	; Read filter file into variable from whichever directory it exists in, conditionally.
			; Tried making the following a function, several tries (including reading explicit global variables) failed :(
	fileFound = 0
IfExist, %filtersLibraryPath%\%filterFileName%
	{
	FileRead, ffxmlContentString, %filtersLibraryPath%\%filterFileName%
	fileFound = 1
	}
IfExist, %myFiltersPath%\%filterFileName%
	{
	FileRead, ffxmlContentString, %myFiltersPath%\%filterFileName%
	fileFound = 1
	}
IfExist, %workingDirectory%\%filterFileName%
	{
	FileRead, ffxmlContentString, %workingDirectory%\%filterFileName%
	fileFound = 1
	}
If (fileFound == 1)
	{
			; MsgBox, fileFound value is 1 where filterFileName val is %filterFileName%.
			; TO DO? Fix potential problem: if the file exists in both folders, it will only use the newest scanned.
	; Implement clugy gotcha, re: https://www.autohotkey.com/docs/commands/LoopParse.htm
	StringReplace, tempString, ffxmlContentString, <Preset, ¢, UseErrorLevel
	numberOfFoundFilterPresets = %ErrorLevel%
			; MsgBox, value of ErrorLevel--which should be a count of how many times the string:`n`n<Preset`n`n--appears in the proposed ffxml filter file--is %ErrorLevel%.
	; THERE'S AN INSERT command here!
	filterPresetCountsArray.Insert(numberOfFoundFilterPresets)
	filterPresetCountsArrayMaxIndex := filterPresetCountsArray._MaxIndex()
			; MsgBox, filterPresetCountsArrayMaxIndex max index is %filterPresetCountsArrayMaxIndex%.
	}
}
; END CREATE REFERENCE ARRAY for filterListArray.

					
; START DOING SERIOUS STUFF! SERIOUSLY! IN ALL CAPS! WITH AWESOMENESS!
preExistingRendered = 0
rendered = 0
srcImgFileNotFound = 0
defaultPresetsUsedBecauseNoSuchPreset = 0
		; TO DO? : make us of one skippedImagesArray := Object() ?
skippedImagesVia_renderOnlyOneRandomFilterPerImage = 0
for sourceImagesListArrayIndex, imageFileName in sourceImagesListArray
{
	for filterListArrayIndex, filterFileName in filterListArray
	{
										; ====
										; LOGICAL COMPLICATION INTERRUPTION: 
											; -- Whereas, depending on the ini setting, it before shuffled the filter list only once (and will only so ever do (once) for the entire run of this program), and at every iteration through this point of the loop it, renders the next filter in the list (including doing this for the same source image over again, instead optionally to this), rather: do NOT re-render the same source image with a different filter, but skip, at this point of the loop, to the next image (if a filter has already been rendered against the same source image here), while also randomly re-selecting here *any* filter from the whole list (instead of continuing to go with a filter already selected as determined by the earlier one-time shuffle of the filter source list). Yes, might that be confusing, or complex. And yes, might it conflict with other options. But it's an option I want. And while I know what I'm talking about, I'll code it . . . right . . . this . . . NOW. 11/12/2015 02:50:48 PM -RAH.
											If (%renderOnlyOneRandomFilterPerImage% == True)
											{
											checkFileFor_renderOnlyOneRandomFilterPerImage = %resultImagesDirectory%\%imageFileName%*
												IfExist, %checkFileFor_renderOnlyOneRandomFilterPerImage%*
												{
													skippedImagesVia_renderOnlyOneRandomFilterPerImage += 1
													Continue
												}
												Else
												{
												sizeOfFilterListArray := filterListArray.MaxIndex()
												Random, randomNum, 1, sizeOfFilterListArray
												filterFileName := filterListArray[randomNum]
												}
											}	
										; END LOGICAL COMPLICATION INTERRUPTION
										; ====
		numberOfFoundFilterPresets := filterPresetCountsArray[filterListArrayIndex]
			; If the filter preset requested does not exist, default to preset 1.
			If (numberOfFoundFilterPresets < presetValue)
				{
				presetValue = 1
				defaultPresetsUsedBecauseNoSuchPreset += 1
				Continue
; TO DO, however it may be reasonable to so do? : store and then re-check the stored answer (after the first check), so that it only checks for each filter file *once,* instead of repeatedly re-loading and re-checking the filter file (which is *much* slower). 04/29/2015 02:02:16 AM -RAH
				; DONE? I had a note here saying so, but I think it was a straggler from a moved comment.
				}
	; Pick number to later alter variation of filter per random range in .ini setting. If the range is 1-1, it will always executed this wasted computation and make it 1 :
	StringSplit, rangeArray, variationRandomizationRange, -,
	Min = %rangeArray1%
	Max = %rangeArray2%
	Random, randomVariation, Min, Max
			; MsgBox, num picked is %randomVariation%
	; CHECK FOR PREEXISTENCE OF TARGET RENDER FILE NAMES; IF THEY EXIST, SKIP THIS RENDER. OTHERWISE, RENDER.
	checkFile = %resultImagesDirectory%\%imageFileName%_ff_%filterFileName%_pre%presetValue%_var%randomVariation%.tif
	renderingCheckFile = %checkFile%.rendering
	IfNotExist, %renderingCheckFile%
		{
		IfExist, %checkFile%
			{
			; Skip this render (the following Else block won't be triggered), and increment a count variable.
			preExistingRendered += 1
			}
			Else
			{
					; GUARD AGAINST RENDERING MOVED/DELETED/CORRUPTED SOURCE FILE DURING BATCH RUN:
					; If the .ini file [Options] section has the setting Sort Source After Render=True, the source file will be moved and thus not available for would-be future iterations of renders from it: therefore check if the source image can be found, and if not, skip this loop iteration (which would only attempt to render from a nonexistent file, and fail, which would be a waste of time and power). Note that this also guards against a wasted render attempt from the file going corrupt or otherwise being moved or deleted during a batch run.
					IfNotExist, %sourceImagesDirectory%\%imageFileName%
					{
						srcImgFileNotFound +=1
						Continue		; skips this render loop iteration.
					}
					; END GUARD AGAINST RENDERING MOVED/DELETED/CORRUPTED SOURCE FILE DURING BATCH RUN
					; If instructed by the gruesomely long ini setting-derived variable:
				; ====
			; BEGIN FFXML FILTER HANDLING
			; FIRST CREATE A COPY OF THE .ffxml FILTER, and if so instructed by the .ini, change that copy. If this ever goes to an insane scale (e.g. hundreds or more of parallel processes), I may conditionally skip copying the file.
; TO DO? : have an option to render variants vs. not and detect variant file names if not?
			FileCreateDir, %XML_and_FFXMLbatchSaveDirectory%
			batchName = %imageFileName%_ff_%filterFileName%_pre%presetValue%_var%randomVariation%
			batchNameFullPath = %XML_and_FFXMLbatchSaveDirectory%\%batchName%
			; NOTE: the preceding doubles as the name for the .xml batch and .ffxml filter, only varying by those respective extensions.
									; FILTER FILE COPY from appropriate dir; will gracelessly fail. Also copies only last found if duplicates. Finally, deletes %batchNameFullPath%.ffxml if filter file not found.
				IfExist, %filtersLibraryPath%\%filterFileName%
				{
			FileCopy, %filtersLibraryPath%\%filterFileName%, %batchNameFullPath%.ffxml, 1
				}
				IfExist, %myFiltersPath%\%filterFileName%
				{
			FileCopy, %myFiltersPath%\%filterFileName%, %batchNameFullPath%.ffxml, 1
				}
				IfExist, %workingDirectory%\%filterFileName%
				{
			FileCopy, %workingDirectory%\%filterFileName%, %batchNameFullPath%.ffxml, 1
				}
				; NOTE that if no such files (per the prior code lines) are copied, render will appropriately FAIL.
			FileRead, FFXMLfileString, %batchNameFullPath%.ffxml			; Reference:
			FileDelete, makeRandomVariationFFXML_via_sed.bat		; To "blank" that file (it will only contain the following on recreation).
			; NOTE that the presetValue in the following command is part of a regex directing to place the nth instance of the match. And *where* the heck did I find and adapt the following command from?
			FileAppend, GNUwin32sed.exe ":a;N;$!ba;s/variation=\"[0-9]*/variation=\"%randomVariation%/%presetValue%" "%batchNameFullPath%.ffxml" > ffxmlSwapTemp.txt, makeRandomVariationFFXML_via_sed.bat
			RunWait, %comspec% /C "%A_ScriptDir%\makeRandomVariationFFXML_via_sed.bat", %A_ScriptDir%, Hide
			FileDelete, %batchNameFullPath%.ffxml	; This is okay because that modified temp file has all the contents of it (plus modificaitons), and we'll just rename the temp file back to it:
			FileMove, ffxmlSwapTemp.txt, %batchNameFullPath%.ffxml, 1
; DEBUG: why is ffxml file empty?
			FileDelete, makeRandomVariationFFXML_via_sed.bat
			; END FFXML FILTER HANDLING
				; ====
				; ====
			; BEGIN XML BATCH HANDLING
			; NOTE that the following is for the .xml file (as opposed to the .ffxml file above) :
			FileRead, XMLfileString, %FilterForgeBatchTemplateXMLfile%
			; StringReplace, OutputVar, InputVar, SearchText [, ReplaceText, ReplaceAll?]
			StringReplace, XMLfileString, XMLfileString, Library.ffxml, %batchNameFullPath%.ffxml
			StringReplace, XMLfileString, XMLfileString, img.jpg, %sourceImagesDirectory%\%imageFileName%
			StringReplace, XMLfileString, XMLfileString, ff_output\img_out.tif, %resultImagesDirectory%\%batchName%.tif
			; NOTE: This next line of code is necessary because the filter count in the xml batch is (ridiculously) at zero-based index (2 is designated with 1, 1 is designated with 0); ALSO NOTE that if we simply substract from presetValue and store the result in itself, the filter preset will change by -1 with every iteration of this loop. No thanks, wan't to keep the preset specified:
			xmlZeroBasedPresetValue = %presetValue%
			xmlZeroBasedPresetValue -= 1
			StringReplace, XMLfileString, XMLfileString, Preset value="1", Preset value="%xmlZeroBasedPresetValue%"
			FileDelete, %batchNameFullPath%.xml
; TO DO ? : Place a comment like the following in the ffxml, via FileAppend? :  FileAppend, <!-- ffBatch overrideVariation=%variation% -->`n, %batchNameFullPath%.xml
	; I'D RATHER IT BE a list of preset and variation numbers than an entire new .xml / .ffxml file set for each file, maybe.
			FileAppend, testTestorTestyTest.txt,
			FileAppend, %XMLfileString%, %batchNameFullPath%.xml
			; If so directed by the ini file, save the generated XML batch file to the instructed directory (per the .ini file).
			; Create the render check file (which may indicate to any other batch processes running parallel renders that a render for the given target file name is already in process, so they may skip it) :
			; Counting on create directory failure after the first time this command is called. Wasteful, yes.
			FileCreateDir, %resultImagesDirectory%
			FileAppend,, %renderingCheckFile%
			; RENDER! :
							; MsgBox, command is: %FFXCmdRendererX86exeWithPATH% %workingDirectory%\batch.xml
					; Reference: ToolTip [, Text, X, Y, WhichToolTip]
					compString := varize(imageFileName)
							; MsgBox, compString value is: %compString%
					StringLeft, fileLsample, compString, 15
							; MsgBox, fileLsample val is %fileLsample%
					StringRight, fileRsample, compString, 15
							; MsgBox, fileRsample val is %fileRsample%
					ToolTip, ffBatch render start`, %fileLsample% . . . %fileRsample%
					; SplashImage,, b1 cw008000 ctffff00, Starting render of %compString%.
					Sleep, 1750
					ToolTip
					
			; UNCOMMENT THE FOLLOWING LINE IN PRODUCTION! IN ALL CAPS!
					; No, not the following indented line! The one after it! ffxml renderer exe name is: FFXCmdRenderer-x86.exe
					; MsgBox COMMAND IS:`n`nRunWait, %FFXCmdRendererX86exeWithPATH% %batchNameFullPath%.xml, %workingDirectory%, %whetherHide%
			RunWait, "%FFXCmdRendererX86exeWithPATH%" "%batchNameFullPath%.xml", %workingDirectory%, %whetherHide%
			rendered += 1
			FileDelete, %renderingCheckFile%

				If (%sortSourceAfterRender% == True)
				{
				; Again wasteful, yes:
				FileCreateDir, %sourceImagesDirectory%\_rendered
				FileMove, %sourceImagesDirectory%\%imageFileName%, %sourceImagesDirectory%\_rendered\%imageFileName%, 1
				}

				If (%saveXMLandFFXML% != True)
				{
				; Again wasteful, yes:
				FileDelete, %batchNameFullPath%.xml
				FileDelete, %batchNameFullPath%.ffxml
				booleanVal := IsEmpty(XML_and_FFXMLbatchSaveDirectory)
				If (booleanVal == 1)
					{
					FileRemoveDir, %XML_and_FFXMLbatchSaveDirectory%
					}
				}
			}
		}
	}
}

; UNCOMMENT in production:
MsgBox, Total batch render files skipped, or found to already exist before render: %preExistingRendered%`n`n`Total files rendered in batch: %rendered%`n`nTotal renders skipped because the source image was moved or not found: %srcImgFileNotFound%*`n`nTotal renders where the preset to use was changed to preset 1 because the specified filter preset number did not exist: %defaultPresetsUsedBecauseNoSuchPreset%`n`nTotal renders skipped because Render Only One Random Filter Per Image in the .ini file was set to true: %skippedImagesVia_renderOnlyOneRandomFilterPerImage%`n`n*The render source file will be moved after one render if the [Options] section of %iniFileName% has the line:`n`n`Sort Source After Render=True`n`n--if that is not the case, yet the source file failed to render, the source file may have been moved, deleted, corrupted, or otherwise impossible to access before a render from it was attempted.


; ExitApp


; IN DEVELOPMENT: syncing ffxml filters among all render slaves; maybe have this as a function in a separate batch.

; ROBOCOPY COMMAND DEVELOPMENT
; REFERENCE:
; ROBOCOPY source dest [file [file]...] [options]

; options to use:
; /MT:%NUMBER_OF_PROCESSORS%

; Library sync command that worked:
; robocopy "C:\Users\%USERNAME%\AppData\Roaming\Filter Forge 4\System\Library" "\\AnotherComputer\c$\Users\%THEIR_USERNAME%\AppData\Roaming\Filter Forge 4\System\Library"

; -then reverse the command:
; robocopy "\\AnotherComputer\c$\Users\%THEIR_USERNAME%\AppData\Roaming\Filter Forge 4\System\Library" "C:\Users\%USERNAME%\AppData\Roaming\Filter Forge 4\System\Library"