;+
;- LAST UPDATED:
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
;- TO DO:
;-   [] WHERE to define variables instr, channel, cadence, buffer, etc.?
;-         --> common structure maybe...
;-   [] Make easier way to switch flares without commenting/uncommenting.
;-   [] "my_start" & "my_end" defined for X2.2 only (1:44 & 2:30, respectively);
;-      error when @parameters is run for other flares.
;-         ==>> this task is obviously old, may or may not be safe to delete.
;-


function multiflare_struc, $
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
        xcen   : 0, $
        ycen   : 0 $
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
    ;    ts_start : '08:15:00', $
    ;    ts_end : '13:14:59', $
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
        tstart : '10:21', $
        tpeak  : '10:41', $
        tend   : '10:47', $
        xcen : -268.8, $  ; -19 degrees
        ycen : -422.4 $   ; -17 degrees
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


        if (flare_id eq 'c83') then begin
            return, multiflare.c83
        endif

        if (flare_id eq 'm73') then begin
            return, multiflare.m73
        endif

        if (flare_id eq 'x22') then begin
            return, multiflare.x22
        endif

    endif else begin
        return, multiflare
    endelse


end


;=
;= ML code to call function "multiflare_struc" defined above
;=


multiflare = multiflare_struc(flare_id='c83')
;multiflare = multiflare_struc(flare_id='m73')
;multiflare = multiflare_struc(flare_id='x22')

;flare = multiflare.c83
;flare = multiflare.m73
;flare = multiflare.x22

; 13 July 2022
;   NOTE: In order to call flare.class, flare.date, etc.,
;     must first define multiflare_struc (i.e. call function and return to ML...)
;     AND define variable "flare" as multiflare.<flare_id>
;     (restricts where these lines can go, basically).
  

help, flare.class
help, flare.date

;=
;= Class: change format to all lowercase with no period delimiter
;=     e.g. flare.class = 'M1.5' --> class = 'm15'

; Two steps:
;   1) Extract class into 2-element string array (without period)
;   2) Combine elements into one (lowercase) string
;class = strsplit(flare.class, '.', /extract)
;class = strlowcase(class[0] + class[1])

; Or accomplish this using a single line of code by
;   splitting and re-joining string elements in one go,
;   OR use IDL's "Replace" method for strings:
;class = strlowcase(strjoin(strsplit(flare.class, '.', /extract)))
class = strlowcase((flare.class).Replace('.',''))
help, class

;=
;= Date: change format to 'yyyymmdd' for beginning of filenames so files are ordered by flare date.
;=   e.g. flare.date = '12-Aug-2013' --> date = '20130812'

date = flare.year + flare.month + flare.day
help, date


end
