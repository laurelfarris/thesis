;+
;- 22 June 2022
;-
;- FILENAME:
;-   main.pro
;-
;- USEAGE:
;-   IDL> @main


;- [] Merge with all the things? reference to filenames (aia/hmi, level 1.0 and 1.5),
;-     parameters, temp_path, ...
;- [] Merge with par2.pro, with structure definitions in subroutine?
;- []
;- []
;-


function multiflare_struc

    ; Fill this in later (09 July 2021)
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

    return, multiflare

end

multiflare = multiflare_struc()


;flare = multiflare.c46
;flare = multiflare.m10
;flare = multiflare.m15
;
flare = multiflare.c83
;flare = multiflare.m73
;flare = multiflare.x22

help, flare.class

; 1) Extract class into 2-element string array (without period)
; 2) Combine elements into one (lowercase) string
; e.g.  flare.class = M1.5 --> class = m15
;
;class = strsplit(flare.class, '.', /extract)
;class = strlowcase(class[0] + class[1])
;
; OR do it like this:
class = strlowcase(strjoin(strsplit(flare.class, '.', /extract)))
;
; OR use IDL's "Replace" method for strings, like this:
class = strlowcase((flare.class).Replace('.',''))

help, class

date = flare.year + flare.month + flare.day
;- flare.date = 12-Aug-2013 --> date = 20130812
help, date

end
