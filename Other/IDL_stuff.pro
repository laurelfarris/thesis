;+
;- 09 July 2021
;-   This file contains code for new IDL functions, classes, methods, etc.
;-   so I can practice using them.
;-

;========================================================================
;+
;- STRING functions
;-

oldclass = 'M7.3'
splitclass = strlowcase( strsplit( oldclass, '.', /extract ) )
;
newclass = splitclass[0] + splitclass[1]
newclass = splitclass.Join()
;- str.Join( [Delimiter] )
;

oldclassagain = strupcase( newclass.Insert( '.', 2 ) )
print, oldclassagain
oldclassagain = strupcase( splitclass.Join( '.' ) )
print, oldclassagain
;- same thing


x = 6
str = string(x)
help, str
help, str.Compress()
;- remove ALL whitespace

str.Replace( '.', '' )
;- Would like to simply remove all periods, e.g. str.Remove('.'), but that doesn't appear
;-  to be a simple code that exists... could write one, but using replace with empty string
;-  is good enough for now.
;-----

fileclass = strlowcase( strsplit( flare.class, '.', /extract ) )

fileclass = strlowcase( (flare.class).Remove(2,2) )
print, fileclass

print, flare.class
fileclass = strlowcase( (flare.class).Replace('.','') )
print, fileclass

date = flare.year + flare.month + flare.day

class = 'M15'
print, class
print, class.insert('.', 1)

wave1 = '303'
wave2 = '1600'
print, wave1.insert( '_20210709', 4, fill_character='x' ) 
print, wave2.insert( '_20210709', 4, fill_character='x' ) 

print, wave1.insert( '_20210709', 4) 


;========================================================================

;+
;- IDL_Savefile => get information about .sav file without restoring
;-


savefile = '/solarstorm/laurel07/flares/m73_20140418/m73_aia1700header.sav'
sObj = OBJ_NEW( 'IDL_Savefile', savefile )


sContents = sObj->Contents()
;sContents = sObj.Contents() ... same thing, I think
help, sContents
;- => structure

help, sContents.N_VAR
;- => LONG64 = 1

help, sObj.Contents();.N_VAR
;-  Structure

help, sContents
;- => Structure! with lots of info
print, n_tags(sContents)
print, tag_names(sContents)

sNames = sObj->Names()
print, sNames


;- The class 'IDL_Savefile' has the following Methods:
;-   • Cleanup
;-   • Contents
;-   • Init
;-   • Names
;-   • Restore
;-   • Size

;========================================================================


end
