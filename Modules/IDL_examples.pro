;+
;-
;- 12 December 2023
;-  moved function "multiflare_struc_TEST" here & deleted lines from 
;-  thesis/multiflare_struc.pro -- only has one function now: "multiflare_struc"
;-
;-
;- 08 August 2022
;-  Use this to run example code to practice using and testing new
;-     functions, classes, methods, etc. in IDL.
;-

;=================================================================================================
;+
;- STRUCTURES
;-


;+
;- Experiment with saving multiflare_struc's to .sav files...
;-

;restore, '../multiflare_struc.sav'
;S = multiflare_struc
;undefine, multiflare_struc
;
;help, S.s1[0]
;help, S.s1[1]
;- NOTE: s1, s2, and s3 are ARRAYs corresponding to three flares.
;-  Each consists of two structures, one for each channel (~A for single flare).
;-
;- For each flare, should have one main structure/dictionary/array/whatever
;-   with simple, single-value tags that are constant regardless of instr/channel
;-  (e.g. flare date, AR #, GOES start/peak/end times, GOES class, etc.)
;-  Final tag(s) has a value that is another structure that is unique to a
;-   specific instr/channel (e.g. HMI B_LOS or AIA 1700Å continuum emission).
;-
;-

;- Add tag/value to existing structure:
;-   struc = CREATE_STRUCT( struc, 'new_tag', new_value )

;S = create_struct( S, 'AR', '11158' )



function multiflare_struc_TEST


;===================================================================================
;function test_struc
    ;   [] Move back to "IDL_examples.pro" ?

    ;==
    ;- 13 July 2022
    ;-   The following (commented) lines appear to test structures in general,
    ;-   not an alternate way to specifically handle multiflares / structures,
    ;-   but may be useful for that, so copied into yet another function.
    ;-
    ;==


    ;- 03 January 2021
    ;-
    ;- TEST : playing with structures
    ;-
    ;REPLICATE can also be used to create arrays of structures.
    ;-
    ;- create structure named "emp" that contains a
    ;- string name field and a long integer employee ID field:
    ;-   NOTE: don't confuse VARIABLE name (employee) with STRUCTURE name (emp),
    ;-   which is the first arg in {}s
    ;-

    ;employee = {emp, NAME:' ', ID:0L}

    ;- create a 10-element ARRAY of this structure, enter:
    ;emps = REPLICATE(employee, 10)

    ;help, emps
    ;-  ==>> is this same form as my 2-element array of AIA channel structures?
    ;-    A[0] = 1600, A[1] = 1700, in case I've forgotten that much..
    ;-
;===================================================================================


    ;== define structures using REPLICATE

    flare = { X22, $
        AR    : '11158', $
        class : 'X2.2', $
        date  : '15-Feb-2011', $
        year  : '2011', $
        month : '02', $
        day   : '15', $
        ts_start : '00:00:00', $
        ts_end   : '04:59:59', $
        gstart   : '01:47:00', $
        gpeak    : '01:56:00', $
        gend     : '02:06:00', $
        center     : [ 2400, 1650], $
        dimensions : [  500,  330], $
        my_start : '01:44', $
        my_end   : '02:30', $
        utbase : '15-Feb-2011 00:00:01.725', $
        align_dimensions : [1000, 800] $
    }

    flare = { X22, $
        AR    : '', $
        class : '', $
        date  : '', $
        year  : '', $
        month : '', $
        day   : '', $
        ts_start : '', $
        ts_end   : '', $
        gstart   : '', $
        gpeak    : '', $
        gend     : '', $
        center     : make_array( 2, /integer ), $
        dimensions : make_array( 2, /integer ), $
        my_start : '', $
        my_end   : '', $
        utbase : '', $
        align_dimensions : make_array( 2, /integer ) $
    }

    multiflare = REPLICATE(flare, 6)
    help, multiflare

    ;-  separately define each new flare as it arises
    flareN = { $
        name_of_flare, $
        year : 2013, $
        month : 08, $
        day : 30 $
        }

    ;- OR

    flare_tags = [ $
        'AR', $
        'class', $
        'date', $
        'year', $
        'month', $
        'day', $
        'ts_start', $
        'ts_end', $
        'gstart', $
        'gpeak', $
        'gend', $
        'center', $
        'dimensions', $
        'my_start', $
        'my_end', $
        'utbase' $
    ]

    ;flareN = create_struct( $
    ;    flare_tags, $
    ;    )

    ;- ...then every additional flare can "inherit" or whatever from the original struc.
    ;-   without retyping all the tags. Maybe better for future codes where existing strucs
    ;-   are restored from .sav files, but definition of FLARE_TAGS string array is no
    ;-   longer present... hard to tell until I try out a few options and see what's best.

end





;====================================================================================================
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



end
