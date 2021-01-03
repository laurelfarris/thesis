;+
;-  MODIFIED:
;-
;-  03 January 2021
;-    ==>> Make this better!!
;-

;+
;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;     UNprepped fits:
;        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;     PREPPED fits:
;        'AIA20131228_100000_1600.fits'
;        'AIA20131228_100000_0304.fits'
;-


buffer = 1


@parameters
;C8.3 2013-08-30 T~02:04:00


;- HMI ---
;instr = 'hmi'
;channel = 'cont'
;channel = 'mag'

;- AIA ---
instr = 'aia'
channel = '1600'
;channel = '1700'


;---------------------------------------

;-
;- TEST : playing with structures


;REPLICATE can also be used to create arrays of structures.



;- create structure named "emp" that contains a
;- string name field and a long integer employee ID field:
;-   NOTE: don't confuse VARIABLE name (employee) with STRUCTURE name (emp),
;-   which is the first arg in {}s
;-

employee = {emp, NAME:' ', ID:0L}

;- create a 10-element ARRAY of this structure, enter:
emps = REPLICATE(employee, 10)

help, emps
;-  ==>> is this same form as my 2-element array of AIA channel structures?
;-    A[0] = 1600, A[1] = 1700, in case I've forgotten that much..
;-

STOP

;---------------------------------------

channel = strtrim(channel,1)
instr = strtrim(instr,1)
;- ??


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


stop

;-------------------


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

flareN = create_struct( $
    flare_tags, $
    )

;- ...then every additional flare can "inherit" or whatever from the original struc.
;-   without retyping all the tags. Maybe better for future codes where existing strucs
;-   are restored from .sav files, but definition of FLARE_TAGS string array is no
;-   longer present... hard to tell until I try out a few options and see what's best.


;---------------------------------------------------


end
