ERF/RIM Edit 
Version: v0.5
Released: 2006-05-18
Updated: 2007-03-11
Updated_FS: 2017-03-19


What is this?
-------------
This is a simple Packer/Unpacker/Browser for the ERF/MOD/SAV/HAK/RIM format files used by the bioware engine games Neverwinter Nights and Knights of the Old Republic. The resource type list is updated to handle some types of files used by the KotOR games that were not used by Neverwinter Nights.

It is capable of creating new files or modify existing ones, as well as extract any resources found within the file. A simple search feature makes it easier to locate resources in the list within large ERF format files. 

The Description field is currently not shown or editable since it is not used with the KotOR games.


User Interface shortcuts
------------------------
You may drag and drop files into the list to add them instead of using the "Insert" button, or you may drag selected files from the list to the Desktop or a Windows Explorer window to extract them rather than use the "Extract" button. Selected files in the list can be deleted with the hotkeys Backspace and DEL in addition to using the Remove button.

When dragging many or large files from the ERF/RIM file to the desktop (or a Windows Explorer window), keep the mouse button pressed until the progress bar has reached 100%, then drag the files to where you want them and let go. Hopefully I'll be able to fix this quirky behavior in the future. :)


IMPORTANT!
----------
New files/resources added to an ERF file are not actually added until you Save the file. Do not move, rename or delete any files you have added before you save the open ERF/RIM file, or the resource will not be added upon save.

Resources in the list with an asterisk (*) following the ResRef are newly added and not yet saved into the file. These files cannot be extracted until the ERF file has been saved.


Change history:
---------------
---> 2006-05-20 (0.2a2)
* Added support for reading and saving RIM files.

* Fixed bug with duplicate entries in resource list when replacing an existing resource with a new one with the same name.

* Fixed sorting the list by clicking the column headers to work peoperly.


---> 2006-05-24 (0.2a4)
* Added support for opening files directly specified as a commandline parameter. This makes it possible to associate the relevant file types to ErfEdit in the Windows Explorer, and to Drag n Drop files onto the ErfEdit.exe icon to open them.

* Enabled extraction progress feedback when drag and dropping a large amount of files (or very large files) from the Resource list to the Desktop or a WinExplorer window.

---> 2006-07-06 (0.2a5)
* Added a "Yes to all" button to the Replace Files confirmation dialog box when replacing a bunch of existing files in an archive.

---> 2006-07-06 (0.2a6)
* Fixed sneaky bug in the RIM handler which caused the game to have trouble loading RIM files saved by ErfEdit. Apparently there was an error in the RIM specification... 


---> 2006-09-30 (0.2a8)
* Fixed bug when deleting resources from ERF/RIM files, where the resources would seemingly be removed, but the actual data still kept in the ERF/RIM file. Deleted resources are now completely removed.


---> 2007-03-11 (0.3)
* As requested: made it capable of working with files of unrecognized file types (this should only happen if using it with ERF files from another game than KOTOR or TSL). It will use the file type index prefixed by a # character instead of the (unknown) file extension of the file when extracting or importing these files.

* Made it capable of loading the ERF V1.1 files that are used with Neverwinter Nights 2. The file type lookup table may still be incorrect for new file types here for now. I'll look into making this utility more fully NWN2 compatible in the future.

IMPORTANT: If you use the ERF/RIM editor for another game than KOTOR or TSL some of types of files will be given an improper file extension, since the type<-->extension table may have changed in this game. If you plan on putting the extracted file in the override folder of this game you will have to determine the file type and change the file extension accordingly. If, however, you plan on using the ERF/RIM Editor to put the file back into the ERF you extracted it from you should leave the improper file extension as it is.

---> 2014-12-08 (0.4)
* Fixed issue where + and - symbols would get removed from filenames...

---> 2017-03-19 (0.5)
* Fixed issue where ! symbols would get removed from filenames...

* Fixed geometry placement issues that eliminated the scrollbar and buttons on the side.