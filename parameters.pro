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


;----------------------------------------------------------


;instr = 'aia'
;;channel = '1600'
;channel = '1700'
;cadence = 24

;instr = 'hmi'
;channel = 'mag'
;channel = 'cont'
;cadence = 45

;----------------------------------------------------------

flare_num = 0 ; X22
;flare_num = 1 ; C30
;flare_num = 2 ; M73


;AR
;AR
;AR

AR = [ '11158', '11936', '12036' ]
class = ['X22', 'C30', 'M73']
date = ['15-Feb-2011', '28-Dec-2013', '18-Apr-2014']
year = ['2011', '2013', '2014']
month = ['02', '12', '04']
day = ['15', '28', '18']
ts_start = ['00:00:00', '10:00:00', '10:00:00']
ts_end   = ['04:59:59', '13:59:59', '14:59:59']
gstart = ['01:47:00', '12:40:00', '12:31:00']
gpeak  = ['01:56:00', '12:47:00', '13:03:00']
gend   = ['02:06:00', '12:59:00', '13:20:00']
center = [ [2400,1650], [1675,1600], [2879,1713] ]
dimensions = [ [500,330], [500,330], [500,330] ]

;----------------------------------------------------------
;- 17 January 2020
;-  BDA start/end times for shaded regions on LC and P_t plots, defined
;-  here so that codes can be generalized for multiflare.
;-  NOTE: still need times for C and M flares.
my_start = ['01:44']
my_end = ['02:30']

utbase = [ $
    '15-Feb-2011 00:00:01.725', $
    '28-Dec-2013 00:00:12.600', $
    '18-Apr-2014 00:00:12.500'  $
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
