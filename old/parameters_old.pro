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


;-------------------------------------------------------------------------------

goto, SOL2011
;goto, SOL2013


;-------------------------------------------------------------------------------
SOL2011:

;- Flare #1
;-
;tstart = '15-Feb-2011 00:00:00'
;tend   = '15-Feb-2011 04:59:59'

date = '15-Feb-2011'
tstart = '00:00:00'
tend = '04:59:59'
gstart = '01:47:00'
gpeak = '01:56:00'
gend = '02:06:00'
year = '2011'
month = '02'
day = '15'
dimensions = [500,330]
center = [2400,1650]
;x1 = 2150 ; (hardcoded, don't need this anymore)
;y1 = 1485 ;    or this...

;- NOTE: see crop_data.pro, where 15 was added to each
;-   dimension when computing center coords of cropped data...

;goto, lowerleftCoords

;-------------------------------------------------------------------------------
SOL2013:

;- Flare #2
;- C3.0
date = '28-Dec-2013'
tstart = '10:00:00'
tend   = '13:59:59'
gstart = '12:40:00'
gpeak = '12:47:00'
gend = '12:59:00' ; don't actually know this yet...
year = '2013'
month = '12'
day = '28'
center = [1675,1600]
dimensions = [500,330]
align_dimensions = [1000,800];- "Pad" dimensions with extra pixels to prepare for alignment

;goto, lowerleftCoords

;-------------------------------------------------------------------------------

;lowerleftCoords:
;- lower left corner (used to get X, Y image coords)
x1 = center[0] - dimensions[0]/2
y1 = center[1] - dimensions[1]/2


end
