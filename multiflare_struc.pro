;+
;- LAST UPDATED
;-
;-   02 August 2022
;-     Moved ML code that redefines class and date to main.pro,
;-     commented remaining ML code so this is primarily an external function
;-     to be called from a different file.
;-
;-   13 July 2022
;-     Merged parameters.pro, par_test.pro, and multiflare_struc.pro with par2.pro.
;-     par2.pro currently contains three function definitions (parameters, par_test, multiflare_struc)
;-        + consolidated ML code at the bottom.
;-
;-   NOTE: par2 no longer runs like a script, i.e. @par2
;-     ML code calls function to return multiflare struc and set class/date variables.
;-
;- 13 July 2022
;-   Copied contents of parameters.pro (the "original" params module)
;-     and par_test.pro into functions below with the same name.
;-   Deleted lots of duplicate text.
;-
;-
;-
;- TO DO
;-
;-  [] Find easier/more intuitive way to switch flares:
;-       • alternative to commenting/uncommenting (sloppy)
;-       • updates/resets ALL globally defined flare-specific variables to prevent conflicting values
;-          (e.g. "time" array still reflects date_obs from previous flare)..
;-         "undefine" variables after use if necessary
;-
;-  [] Refer to old/parameters_????????.pro for older code.
;-

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



function MULTIFLARE_STRUC, $
    flare_id=flare_id

    ;+
    ;- 13 July 2022
    ;-
    ;- FILENAME:
    ;-   multiflare_struc.pro (changed from "main.pro" to match the function name,
    ;-      even tho rather tedious to type every time I call it...)
    ;-
    ;- USEAGE:
    ;-   IDL> .RUN multiflare_struc
    ;-
    ;- TO DO:
    ;-   [] Merge with all the things? reference to filenames (aia/hmi, level 1.0 and 1.5),
    ;-       parameters, temp_path, ...
    ;-   [] Merge with par2.pro, with structure definitions in subroutine?
    ;-

    ;-
    ;- 07 January 2021 (re-worded 13 July 2022)
    ;-  NOTE: structure NAME ==> first entry in {}'s, no ':' to assign value
    ;-    ('flare' in structures below)
    ;-   structure name defines the TYPE of structure, which is probably the same for each flare,
    ;-   so probably won't be able to use flare name for each GOES class, as I was probably trying to do..


    c30 = { $
        ;flare, $
        ;name : 'c46', $
        AR     : '', $
        class  : 'C4.6', $
        date   : '23-Oct-2014', $
        year   : '2014', $
        month  : '10', $
        day    : '23', $
        tstart : '13:20', $
        tpeak  : '00:00', $
        tend   : '00:00', $
        xcen   : 0, $
        ycen   : 0 $
    }

    c46 = { $
        ;flare, $
        ;name : 'c46', $
        AR     : '', $
        class  : 'C4.6', $
        date   : '23-Oct-2014', $
        year   : '2014', $
        month  : '10', $
        day    : '23', $
        tstart : '13:20', $
        tpeak  : '', $
        tend   : '', $
;        tpeak  : '00:00', $
;        tend   : '00:00', $
        xcen   : 0.00, $
        ycen   : 0.00 $
    }

    c83 = { $
        ;flare, $
        ;c83, $
        AR     : '11836', $
        class : 'C8.3', $
        date  : '30-Aug-2013' , $
        year : '2013', $
        month : '08', $
        day : '30', $
        tstart : '02:04', $
        tpeak  : '02:46', $
        tend   : '04:06', $
        xcen : -633.276, $ ; -43 degrees
        ycen : 128.0748 $  ;  13 degrees
    }

    m10 = { $
        ;flare, $
        ;m10, $
        AR     : '12205', $
        class : 'M1.0', $
        date  : '07-Nov-2014' , $
        year : '2014', $
        month : '11', $
        day : '07', $
        ;ts_start : '08:15:00', $
        ;ts_end : '13:14:59', $
        tstart : '10:13', $
        tpeak  : '10:22', $
        tend   : '10:30', $
        xcen : -639.624, $  ; -43 degrees (? double check this..)
        ycen :  206.1222 $  ; 15 degrees
    }






    m15 = { $
        ;flare, $
        ;m15, $
        AR     : '11817', $
        class : 'M1.5', $
        date  : '12-Aug-2013' , $
        year : '2013', $
        month : '08', $
        day : '12', $
        ;ts_start : '08:15:00', $
        ;ts_end : '13:14:59', $
        tstart : '10:21', $
        tpeak  : '10:41', $
        tend   : '10:47', $
        xcen : -268.800, $ ; -19 degrees
        ycen : -422.400 $  ; -17 degrees
    }





    m73 = { $
        ;flare, $
        ;m73, $
        AR     : '12036', $
        class : 'M7.3', $
        date  : '18-Apr-2014' , $
        year : '2014', $
        month : '04', $
        day : '18', $
        tstart : '12:31', $
        tpeak  : '13:03', $
        tend   : '13:20', $
        xcen : 0, $
        ycen : 0 $
    }

    x22 = { $
        ;flare, $
        ;x22, $
        AR     : '11158', $
        class : 'X2.2', $
        date : '15-Feb-2011', $
        year : '2011', $
        month : '02', $
        day : '15', $
        tstart : '01:47', $
        tpeak  : '01:56', $
        tend   : '02:06', $
        xcen : 0, $
        ycen : 0 $
    }

    ; 27 April 2022
    ;   COORDS (xcen, ycen) = loc of AR [center/corner] at flare [start/peak] time,
    ;   in units of [arcsec/degrees/pixels] relative to [disk center/origin]
    ;
    ; xcen, ycen assumed to be in ARCSEC (see ./Prep/struc_aia.pro)

    multiflare = { m15:m15, c83:c83, c46:c46, m10:m10, m73:m73, x22:x22 }

    print, ''
    print, '==-- Multiflare structure --=========================================='
    help, multiflare
    print, '======================================================================'
    print, ''


    ;flare = multiflare_struc(flare_id='c83')
    ; =>> doesn't work! structure tags are not strings...
    ;      Could pass flare id using index notation, e.g. multiflare.(1) instead of multiflare.c83..

    if keyword_set(flare_id) then begin
        ;return, multiflare.flare_id else 

        print, ''
        print, 'Flare ID = ', flare_id, ' Is this correct?'
        ; READ, [Prompt,] Var₁, ..., Varₙ 
        response = ''
        read, ' Type y or n, (or type q to quit) :  ', response

        while (strlowcase(response) NE 'n') && (strlowcase(response) NE 'y') && (strlowcase(response) NE 'q') do begin
            print, ' ==>> ERROR! Please type "n" or "y" only (or "q" to quit) '
            read, response
        endwhile

        if (strlowcase(response) EQ 'q') then return, 0

        if strlowcase(response) eq 'n' then begin
            read, flare_id, prompt='Type desired class ("c83", "m73", or "x22"): '
        endif

        ; 02 August 2022
        ;   not sure if this is correct use of 'continue'... may get error.
        ; 13 December 2022
        ;   Did in fact get error because 'if' statements are only conditionals, not loops.
        ;if strlowcase(response) eq 'y' then begin

        if (flare_id eq 'c83') then return, multiflare.c83
        if (flare_id eq 'm73') then return, multiflare.m73
        if (flare_id eq 'x22') then return, multiflare.x22

    endif else return, multiflare

end


;=
;= ML code to call function "multiflare_struc" defined above
;=



;multiflare = multiflare_struc(flare_id='c83')
;multiflare = multiflare_struc(flare_id='m73')
;multiflare = multiflare_struc(flare_id='x22')

;flare = multiflare.c83
;flare = multiflare.m73
;flare = multiflare.x22


;==============================================================
;= Different way to save struc maybe?
;=   (copied from par2.pro 08 August 2022)
;
;;s1 = A
;;s2 = A
;s3 = A
;;
;multiflare_struc = { s1:s1, s2:s2, s3:s3 }
;help, multiflare_struc
;save, multiflare_struc, filename='multiflare_struc.sav'
;==============================================================

;end
