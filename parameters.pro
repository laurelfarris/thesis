;- 21 April 2019
;-
;- If changes to the contents of this file or its name,
;-  make appropriate changes to comments in prep routines.
;- [] Make easier way to switch flares without
;-  commenting/uncommenting...
;- unless I rarely have to switch between flares, in which
;-  case it doesn't matter.


;- Flare #1
;tstart = '15-Feb-2011 00:00:00'
;tend   = '15-Feb-2011 04:59:59'
;year = '2011'
;month = '02'
;day = '15'
;dimensions = [500,330]
;center = [2400,1650]
;x1 = 2150 (hardcoded)
;y1 = 1485 (hardcoded)

;- NOTE: see crop_data.pro, where 15 was added to each
;-   dimension when computing center coords of cropped data...




;- Flare #2
date = '28-Dec-2013'
tstart = '10:00:00'
tend   = '13:59:59'
gstart = '12:40:00'
gpeak = '12:47:00'
gend = '12:59:00' ; don't actually know this yet...
year = '2013'
month = '12'
day = '28'

instr = 'aia'
center = [1675,1600]
;dimensions = [600,500]
dimensions = [500,330]


;----------------------------------------------------------------

;lower left corner (used to get X, Y image coords)
x1 = center[0] - dimensions[0]/2
y1 = center[1] - dimensions[1]/2
