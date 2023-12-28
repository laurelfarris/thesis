;+
;- LAST UPDATED:
;-   08 August 2022
;-     Moved most code to multiflare_struc.pro; only remaining function is "parameters".
;-     Re-named file from "par2.pro" to "parameters_20220808.pro"
;-       (appended current date b/c not sure of actual last modified date...
;-        haven't called "@parameters" in a long time.. even @par2 is now obsolete).
;-
;-   13 July 2022
;-     Merged parameters.pro (the "original" params module), par_test.pro, and par2.pro
;-        and deleted lots of duplicate text.
;-     FINAL FILE: par2.pro; contains three function definitions:
;-        1. test_struc
;-        2. par_test
;-        3. parameters
;-     + consolidated ML code at the bottom.
;-
;-   NOTE: par2 no longer runs like a script, i.e. @par2
;-     ML code calls function to return multiflare struc and set class/date variables.
;-
;-
;- TO DO:
;-   [] WHERE to define variables instr, channel, cadence, buffer, etc.?
;-         --> common structure maybe...
;-   [] "my_start" & "my_end" defined for X2.2 only (1:44 & 2:30, respectively);
;-      error when @parameters is run for other flares.
;-         ==>> this task is obviously old, may or may not be safe to delete.
;-


function parameters

    ;+
    ;- 04 May 2020
    ;-   Instructions for user:
    ;-    uncomment the "flare_num" below to set index of flare you desire to analyze.
    ;-    Don't need to change anything else in this file.
    ;-
    ;- 24 July 2020
    ;-   From Todoist:
    ;-     • variable definitions for "inst" and "channel" are commented...
    ;-         should these be defined elsewhere?
    ;-         --> common structure maybe...
    ;-     • string variables "my_start" and "my_end" are defined for X2.2 only,
    ;-         (1:44 and 2:30, respectively).
    ;-         get error when run @parameters for other flares.
    ;-


    flare_num = 0 ; X22
    ;- .sav files for Sean S. -- 28 May 2021

    ;;+
    ;;flare_num = 0 ; X22
    ;;flare_num = 1 ; C30
    ;;flare_num = 2 ; M73
    ;flare_num = 3 ; C8.3
    ;flare_num = 4 ; M1.0
    ;flare_num = 5 ; M1.5
    ;flare_num = 6 ; C4.6
    ;;flare_num = 7 ; X1.0
    ;;-
    ;

    ;===================================================================================

    ;+
    ;- 21 April 2019
    ;-
    ;- If changes to the contents of this file or its name,
    ;-  make appropriate changes to comments in prep routines.
    ;- [] Make easier way to switch flares without
    ;-  commenting/uncommenting...
    ;- unless I rarely have to switch between flares, in which
    ;-  case it doesn't matter.
    ;-

    ;- --> see _README.pro -- similar general purpose as this one.


    ;- Naming convention of fits files for, e.g. AIA 1600\AA{}
    ;     UNprepped fits:
    ;        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
    ;        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
    ;     PREPPED fits:
    ;        'AIA20131228_100000_1600.fits'
    ;        'AIA20131228_100000_0304.fits'


    ;instr = 'aia'
    ;;channel = '1600'
    ;channel = '1700'
    ;cadence = 24

    ;instr = 'hmi'
    ;channel = 'mag'
    ;channel = 'cont'
    ;cadence = 45

    ;AR
    ;AR
    ;AR

    AR = [ '11158', '11936', '12036', '' ]
    class = ['X22', 'C30', 'M73', 'C83']
    date = ['15-Feb-2011', '28-Dec-2013', '18-Apr-2014', '30-Aug-2013']
    year = ['2011', '2013', '2014', '2013']
    month = ['02', '12', '04', '08']
    day = ['15', '28', '18', '30']
    ts_start = ['00:00:00', '10:00:00', '10:00:00', '00:00:00']
    ts_end   = ['04:59:59', '13:59:59', '14:59:59', '04:59:59']
    gstart = ['01:47:00', '12:40:00', '12:31:00', '02:04:00']
    gpeak  = ['01:56:00', '12:47:00', '13:03:00', '']
    gend   = ['02:06:00', '12:59:00', '13:20:00', '']
    center = [ [2400,1650], [1675,1600], [2879,1713], [0,0] ]
        ;- 09 November 2020
        ;-   center of which image? Beginning of time series? Reference image used for alignment??
        ;-     ==>> [] COMMENT EVERYTHING!!
    dimensions = [ [500,330], [500,330], [500,330], [500,330] ]


    ;- 17 January 2020
    ;-  BDA start/end times for shaded regions on LC and P_t plots, defined
    ;-  here so that codes can be generalized for multiflare.
    ;-
    ;- 17 April 2020
    ;-  NOTE: added values for C and M flares somewhat arbitrarily by simply
    ;-    starting 10 minutes prior to official GOES start time
    ;-    and ending after 45 minutes, regardless of actual duration of gradual phase.

    my_start = [ '01:44', '12:30', '12:21', '02:00']
    my_end   = [ '02:30', '13:16', '13:07', '02:45']


    utbase = [ $
        '15-Feb-2011 00:00:01.725', $
        '28-Dec-2013 00:00:12.600', $
        '18-Apr-2014 00:00:12.500',  $
        '30-Aug-2013 00:00:02.067'  $
    ]
    ;- NOTE: utbase times for C and M flare are ESTIMATES based
    ;-   on gstart... [] --> look up official utbase!
    ;----------------------------------------------------------

    align_dimensions = [1000,800];- "Pad" dimensions with extra pixels to prepare for alignment
    ;x1 = 2150 ; (hardcoded, don't need this anymore)
    ;y1 = 1485 ;    or this...


    AR = AR[ flare_num ]
    class = class[ flare_num ]
    date = date[ flare_num ]
    year = year[ flare_num ]
    month = month[ flare_num ]
    day = day[ flare_num ]
    ts_start = ts_start[ flare_num ]
    ts_end = ts_end[ flare_num ]
    gstart = gstart[ flare_num ]
    gpeak = gpeak[ flare_num ]
    gend = gend[ flare_num ]
    center = reform(center[*, flare_num ])
    dimensions = reform(dimensions[*, flare_num ])

    my_start = my_start[ flare_num ]
    my_end = my_end[ flare_num ]

    utbase = utbase[ flare_num ]

    ;- NOTE: see crop_data.pro, where 15 was added to each
    ;-   dimension when computing center coords of cropped data...

    ;- lower left corner (used to get X, Y image coords)
    x1 = center[0] - dimensions[0]/2
    y1 = center[1] - dimensions[1]/2

end
