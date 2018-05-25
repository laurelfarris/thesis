



goto, start






; 22 May 2018
; Read new, prepped fits files




; crop data for alignment.

path = '/solarstorm/laurel07/Data/AIA_prepped/'
fls = file_search( path + '*1600*.fits' )
stop

start_time = systime(/seconds)
read_sdo, fls, index, data
print, (systime(/seconds) - start_time) / 60., format='(F0.2)' $
    + ' minutes.'
stop

; What does "avoiding 4GB byteorder limit" mean??
print, get_nbytes(data) ge 2.^32
; also see swap_endian, and wiki page on "Endianness"


; Testing printout of time passed, then detour to once again reviewing
; how to use format codes when printing string + variable.
start_time = systime(/seconds)
wait, 5
print, (systime(/seconds)-start_time)/60., format='(F0.2, " minutes")'
stop

; "Program caused arithmetic error: floating illegal operand"
; Some values in data are negative, so get this error if taking sqrt.

; Scaling data (see documentation on SDO data)
; log10 moves values much closer together.
; should try this for power maps (be sure to account for values=0)
im = image( temp^0.5, min_value=0.0 )
im = image( alog10(temp), min_value=0.001)
stop

; lower left corner to center up active region
; (for FIRST image in series!)
; Should use image in middle of time series --> reference for alignment
sz = size( temp, /dimensions )
ref = temp[*,*,sz[2]/2]
im = image( ref^0.5, min_value=0.0 )
x1 = 2120
y1 = 1500
temp = data[ x1:x1+500, y1:y1+330, 0 ]

; compare first and last image to see roughly how much my data
; should shift in x
im = image( temp[*,*, 0]^0.5, $
    layout=[1,2,1], $
    margin=0.0, $
    min_value=0.0 )
im = image( temp[*,*,-1]^0.5, $
    /current, $
    margin=0.0, $
    layout=[1,2,2], $
    min_value=0.0 )

; Center of 3 sunspot regions shift by ~70 pixels from first to last image.
; So +/-35 pixels from center image.
; Pad with 100 pixels on both sides
x1 = 2120
x2 = x1 + 500-1
y1 = 1500
y2 = y1 + 330-1
temp = data[ x1:x2, y1:y2, * ]

; lower left corner for center (ref) image
; (shifted x1 by 5 more just to center up a little better.
;   y1 doesn't need to change, since this is primarily for solar rotation.)

;x1 = 2120 + 35
x1 = 2160
x2 = x1 + 500 - 1
y1 = 1500
y2 = y1 + 330 - 1
dx = 100 ; = 500 * 0.2
dy = 66  ; = 330 * 0.2

; reflect coordinates across origin (maybe.. not sure if doing this right)
;x1 = 4096-2160
;y1 = 4096-1500

temp = data[ $
    x1-dx : x2+dx, $
    y1-dy : y2+dy, $
    sz[2]/2 ]
im = image( temp^0.5, min_value=0.0 )
stop

temp = data[ $
    x1-dx : x2+dx, $
    y1-dy : y2+dy, $
    * ]

START:;--------------------------------------------------------------------
sz = size(temp, /dimensions)
mask = fltarr(sz) + 1.0
threshold = 10000
threshold = 3000
mask[ where( temp ge threshold ) ] = 0.0
mask2 = product( mask, 3 )
stop

;im = image( mask[*,*,286] )
im = image( mask2 )
xstepper, mask
stop



; correct(-ish) xshifts
xs = ((findgen(749)/748) * 70) - 35
xs = reverse(xs)

; may or may not need this:
;k1 = [ 4,  81, 240, 458, 469, 638, 668, 713 ]
;k2 = [ 14, 112, 335, 465, 480, 645, 704, 720]
;align_locs = [0, k1, k2+1, sz[2] ]
;A = align_locs[ sort(align_locs) ]
;A = [ 0, 14, 81, 112, 240, 335, 458, 480, 638, 668, 704, sz[2] ]



temp = data[ x1-dx : x2+dx, y1-dy : y2+dy, * ]
sz = size( temp, /dimensions )
ref = temp[*,*,sz[2]/2]
calculate_shifts, temp, ref, shifts2

;xrange = [450,485]
;xrange = [630,650]
;xrange = [650,710]
;xrange = [700,748]

test = fltarr(749)
test[cad] = shifts[0,cad]
p = plot(test)
stop


xrange = [600,748]
xdata = [ 0:sz[2]-1 ]
w = window( dimensions=[1600, 500] )
p = objarr(2)
p[0] = plot2( $
    xdata, $
	shifts[0,*], $
    /current, $
    xrange=xrange, $
    symbol='circle', $
    sym_filled=1, $
;    linestyle=6, $
	color=colors[0], $
    name='horizontal shifts' )
p[1] = plot2( $
    xdata, $
	shifts[1,*], $
	/overplot, $
    xrange=xrange, $
    symbol='circle', $
    sym_filled=1, $
;    linestyle=6, $
	color=colors[1], $
    name='vertical shifts' )

leg=legend( target=[p] )
stop


sh = reform(shifts[0,*])
diff = sh - xs
stop

;A = [ 0, 14, 81, 112, 240, 335, 458, 480, 638, 668, 704, sz[2] ]
;cad = [0,1,4:6,12]



stop



temp = data[ $
    x1-dx : x1+500+dx-1, $
    y1-dy : y1+330+dy-1, $
    sz[2]/2 ]

start_time = systime(/seconds)
align_cube3, temp, ref, shifts=shifts
print, (systime(/seconds)-start_time)/60., format='(F0.2, " minutes")'



cad = [ $
    [12:76], $
	[128:172], $
	[177:189], $
	[194:240], $
	[243:264], $
    [316:460], $
	[463:471], $
	[479:636], $
	[646:652], $
	[703:713], $
	[718:747], $
	748 ]

cad = [ $
    [0:82], $
    [104:106], $
	[110:264], $
    [330:460], $
	[464:470], $
	[479:640], $
	[644:670], $
	[702:715], $
	[718:747], $
	748 ]

; Get new shifts in one of two ways:
new_shifts = INTERP_SHIFTS( shifts, cad )
PLOT_SHIFTS, new_shifts

; or just set stupid values to 0.0
new_shifts = shifts
new_shifts[ where( abs(shifts) gt 0.05 ) ] = 0.0
PLOT_SHIFTS, new_shifts
stop

START:;--------------------------------------------------------------------
; apply new_shifts to temp and calculate next set
start_time = systime(/seconds)
shifts3 = mean([ [[shifts1]], [[shifts2]] ], dimension=3)
APPLY_SHIFTS, temp, shifts3
print, format='(F0.2, " minutes")', (systime(/seconds)-start_time)/60.
xstepper, temp^0.5
stop

stop


; Overall variation in intensity between images, seems to be effect
; of color scaling (images with higher max values had lower intensity
; everywhere else).
max_values = fltarr(749)
for i = 0, 748 do $
    max_values[i] = max(temp[*,*,i])
dat1 = temp[50:100,400:450,453]
dat2 = temp[50:100,400:450,455]

dat1 = temp[*,*,31]
;dat2 = temp[*,*,279]
dat2 = temp[*,*,455]

im = image2( dat1, layout=[1,2,1], margin=0.01, min_value=0.0, max_value=3454)
im = image2( dat2, /current, layout=[1,2,2], margin=0.01, $
    min_value=0.0, max_value=3454)
stop

; Try applying average shifts from outer four corners to entire cube
test1 = temp[0:280,0:150,*]
test2 = temp[400:699,0:200,*]
ref1 = test1[*,*,sz[2]/2]
ref2 = test2[*,*,sz[2]/2]
CALCULATE_SHIFTS, test1, ref1, shifts1
CALCULATE_SHIFTS, test2, ref2, shifts2
PLOT_SHIFTS, shifts1
PLOT_SHIFTS, shifts2
PLOT_SHIFTS, mean([ [[shifts1]], [[shifts2]] ], dimension=3)
im = image2(ref, layout=[1,2,1], margin=0.0)
im = image2(mask2, /current, layout=[1,2,2], margin=0.0)
im = image2(mask2*ref, layout=[1,1,1], margin=0.1)
; still bouncing around, but may need to start over.



end
