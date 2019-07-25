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
;        'aia.lev1.1600A_2013-12-28T10:00:00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10:00:00.00Z.image_lev1.fits'
;     PREPPED fits:
;        'AIA20131228_10:00:00_1600.fits'
;        'AIA20131228_10:00:00_0304.fits'


;----------------------------------------------------------
flare_num = 2


;AR 11158
;AR 11936
;AR 12036

date = ['15-Feb-2011', '28-Dec-2013', '18-Apr-2014']
year = ['2011', '2013', '2014']
month = ['02', '12', '04']
day = ['15', '28', '18']
tstart = ['00:00:00', '10:00:00', '10:00:00']
tend = ['04:59:59', '13:59:59', '14:59:59']
gstart = ['01:47:00', '12:40:00', '12:31:00']
gpeak = ['01:56:00', '12:47:00', '13:03:00']
gend = ['02:06:00', '12:59:00', '13:20:00']
center = [ [2400,1650], [1675,1600], [2879,1713] ]
dimensions = [ [500,330], [500,330], [500,330] ]

align_dimensions = [1000,800];- "Pad" dimensions with extra pixels to prepare for alignment
;x1 = 2150 ; (hardcoded, don't need this anymore)
;y1 = 1485 ;    or this...

;----------------------------------------------------------
date = date[ flare_num ]
year = year[ flare_num ]
month = month[ flare_num ]
day = day[ flare_num ]
tstart = tstart[ flare_num ]
tend = tend[ flare_num ]
gstart = gstart[ flare_num ]
gpeak = gpeak[ flare_num ]
gend = gend[ flare_num ]
center = reform(center[*, flare_num ])
dimensions = reform(dimensions[*, flare_num ])


;- NOTE: see crop_data.pro, where 15 was added to each
;-   dimension when computing center coords of cropped data...


;- lower left corner (used to get X, Y image coords)
x1 = center[0] - dimensions[0]/2
y1 = center[1] - dimensions[1]/2
