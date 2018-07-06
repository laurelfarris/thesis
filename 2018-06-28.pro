

goto, start

; 10 June (ish)

z = [261:349]

cube = data[*,*,z]


;temp = cube[500:*,*,*]
;temp2 = cube[]

x = 185
y = 200

xstepper, aligned_cube>106<3845, xsize=500, ysize=330

; 27 June 2018

channel = '1700'

restore, '../aia' + channel + 'map.sav'

help, map
; FLOAT = Array[500, 330, 685] for both channels

print, map[200,200,-1]
; NOTE: nothing special about coords at 200,200. Just picked a random location
; somewhere toward the center of the array.

; = ~0.20 for AIA 1600
; =  0.00 for AIA 1700 (still need to finish this map).

; First try to locate saturated values in maps.
; Mainly need to see if aia_prep messed with values at all.

test = map[200,200,*]
print, where( test eq 0.0 )

;START:
locs =  where( test eq 0.0 )
print, locs-shift(locs,1)
print, n_elements(locs)
print, min(map[*,*,9])
print, max(map[*,*,0])

;START:
; detour - develop better subroutine to convert between pixels and arcseconds

; center of AR11158
x0 = 2400
y0 = 1650
x = (x0 - (500./2) - index.crpix1) * index.cdelt1
y = (y0 - (330./2) - index.crpix2) * index.cdelt2

; after eyeballing AR image, final values should be close to (50, -350)
print, x
print, y
stop
; actually (60.9, -338.1)... close enough :)

; roughly center of map around peak flare time:
print, map[225:275, 110:160, 270]

;----------------------------------------------------------------------------------
; Figure out z-index at which calculation of AIA 1700 power map stopped,
;   and finish it. Will have to interpolate data cube again.
; Last night: error at test in power_maps.pro,
;   before loop that does actual map calculations (yay test codes!)
;   at i = 30-something.

;channel = '1600'
channel = '1700'

restore, '../aia' + channel + 'map.sav'

print, channel

sz = size(map, /dimensions)
map_total = fltarr(sz[2])
for i = 0, sz[2]-1 do $
    map_total[i] = total(map[*,*,i])

unfinished_ind = where(map_total eq 0.0)
START:
print, unfinished_ind[0]
stop
print, unfinished_ind - shift(unfinished_ind, 1)

; run power_maps for AIA 1700 from i = 650 --> 684 (-1)
; see ML code in power_maps.pro for code and comments.
;   28 June 2018 - maybe... rewrote a lot of this to make a general routine.

; Appears that AIA 1700 map has been successfully completed.
; but don't want to risk overwriting first map, hence:
;save, map, filename='aia' + channel + 'map_final.sav'


;----------------------------------------------------------------------------------
; Now checking on saturation values before and after aia_prep

; 28 June 2018 - changed prepped kw to 1 by default
;read_my_fits, 'aia', 1600, aia1600index, nodata=1, prepped=1
;read_my_fits, 'aia', 1700, aia1700index, nodata=1, prepped=1
read_my_fits, aia1600index, data, inst='aia', channel=1600, nodata=1;, prepped=1
read_my_fits, aia1700index, data, inst='aia', channel=1700, nodata=1;, prepped=1

for i = 0, 1 do begin
    READ_MY_FITS, index, data, inst='aia', channel=1600, $
        ind=[275], nodata=1, prepped=i
    ;print, index.datamin
    ;print, index.datamax
    ;print, index.datamax - index.datamin

endfor



;read_my_fits, 'aia', 1600, aia1600index_old, nodata=1, prepped=0
;read_my_fits, 'aia', 1700, aia1700index_old, nodata=1, prepped=0
read_my_fits, aia1600index_old, data, inst='aia', channel=1600, nodata=1, prepped=0
read_my_fits, aia1700index_old, data, inst='aia', channel=1700, nodata=1, prepped=0

;aia1600sat = aia1600index.nsatpix
aia1700sat = aia1700index.nsatpix

;aia1600sat_old = aia1600index_old.nsatpix
aia1700sat_old = aia1700index_old.nsatpix

; Make sure I'm actually reading from unprepped and prepped index:
;print, aia1600index_old[0].lvl_num
;print, aia1600index[0].lvl_num
print, aia1700index_old[0].lvl_num
print, aia1700index[0].lvl_num

; Compare nsatpix of each image for prepped and unprepped:
;diff = aia1600sat_old - aia1600sat
diff = aia1700sat_old - aia1700sat
print, where(diff ne 0)

; It appears that aia_prep does NOT affect which pixels are saturated.
; That would have suuuucked.

; trying one more thing, in case nsatpix tag just doesn't get updated.

restore, '../aia1600aligned.sav'
a6 = cube
restore, '../aia1700aligned.sav'
a7 = cube
help, cube

a6sat = where( a6 ge 15000 )
a7sat = where( a7 ge 15000 )

restore, '~/Data/aia_1600_aligned.sav'

help, a6
help, cube

cube = crop_data(cube)
help, cube

a6sat = where( a6 ge 15000 )
a6sat_old = where( cube ge 15000 )

print, n_elements(where( a6sat ne a6sat_old ))

;START:

print, max(cube[*,*,90])
print, max(a6[*,*,90])




end
