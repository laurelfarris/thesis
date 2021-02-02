;+
;- 02 February 2021 (Tuesday)
;-
;-
;- TO DO:
;-
;-  []  Find coords of 20141023 flare, save cube and index to .sav files:
;-            20141023_aia1600cube.sav
;-            20141023_aia1700cube.sav
;-    --> INCOMPLETE
;-
;-  []  ALIGN data
;-    --> INCOMPLETE
;-
;-  []  Image HMI alongside concurrent AIA obs; check relative AR position.
;-    --> INCOMPLETE
;-
;- [] copy today.pro to some Module generalized for running alignment
;-    on any group of level 1.5 fits files (or level 1.0, shouldn't matter)
;-    --> INCOMPLETE
;-
;


;+
;- Alignment -- broken down into detailed steps:
;-   • read level 1.5 (PREPPED) fits : index + data
;-   • crop to subset centered on AR
;-   • padded CUBE + INDEX -> fileame.sav
;-       (read_sdo takes too long and bogs system down to where nothing gets done
;-   • align cube to reference image (center of time series)
;-   • aligned_cube + INDEX -> filename2.sav
;-       index still the same, only data has changed...
;-


;+
;- Current collection in multiflare project:
;-   • C8.3 2013-08-30 T~02:04:00  (1)
;-   • M1.0 2014-11-07 T~10:13:00  (3)
;-   • M1.5 2013-08-12 T~10:21:00  (0)
;-   • C4.6 2014-10-23 T~13:20:00  (2)
;-  multiflare.(N) --> structure of structures
;-    current index order is as listed to the right of each flare
;-    (chronological order).
;-
;-

buffer = 1

;+
;- Read HMI level 1.5 fits
;- Image full disk, 6 panels like yesterday
;-    scale continuum and/or mag ... otherwise, just get white, washed out disk...
;- Eyeball center coords of AR
;- Extract subset with same center and dimensions as AIA, e.g. --> "M10_hmi_mag_cube.sav"
;-


instr = 'aia'
channel = 1600
;channel = 1700
;
AIA_LCT, r, g, b, wave=fix(channel)
rgb_table = [ [r], [g], [b] ]
;
;
flare_index = 0  ; M1.5
;flare_index = 1  ; C8.3
;flare_index = 2  ; C4.6
;-  2014-10-23 --> No center coords
;flare_index = 3  ; M1.0

;========================================================================================

@par2
;- defines structure of structures:
;;-   IDL>   multiflare = { m15:m15, c83:c83, c46:c46, m10:m10 }
;help, multiflare
;
flare = multiflare.(flare_index)


path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
fnames = strupcase(instr) + $
    flare.year + flare.month + flare.day + '*' + strtrim(channel,1) + '.fits'
fls = FILE_SEARCH( path + fnames )
help, fls

stop;-----------------------------------------------------------------------------


;---
READ_SDO, fls, index, /nodata
;- Read full header (no data yet).

spatial_scale = index[0].cdelt1
exptime = index[0].exptime

z_ind = intarr(6)
z_ind[0] = 0
z_ind[1] = (where( strmid( index.date_obs, 11, 5 ) eq flare.tstart ))[0]
;z_ind[2] = (where( strmid( index.date_obs, 11, 5 ) eq flare.tpeak ))[0]
z_ind[2] = z_ind[1]+25
;z_ind[3] = (where( strmid( index.date_obs, 11, 5 ) eq flare.tend ))[0]
z_ind[3] = z_ind[2]+25
z_ind[4] = n_elements(fls)/2
z_ind[5] = -1
;
;print, z_ind
;foreach zz, z_ind, ii do  print, index[zz].date_obs
;foreach zz, z_ind, ii do  print, fls[zz]

;---
READ_SDO, fls[ z_ind ], index, data
;--
z_ind2 = [ 300, 310, 320, 330, 340, 350 ] 
READ_SDO, fls[ z_ind2 ], index, data
;---


imdata = AIA_INTSCALE( $
    data, wave=fix(channel), exptime=exptime )

;data2 = data
;help, data2
;for ii = 0, 5 do begin
;    print, minmax( aia_intscale( data2[*,*,0], wave=fix(channel), exptime=exptime ) )
;    print, minmax( imdata[*,*,0] )
;endfor
;- intscale appears to have same effect on individual images as a 3D cube.

stop;-----------------------------------------------------------------------------


;print, flare.class, flare.year, flare.month, flare.day
;print, flare.xcen, flare.ycen
;

;=======

;+
;- IMAGING
;-

center=[2000, 1500]
dimensions=[700,700]
cube = CROP_DATA( data, center=center, dimensions=dimensions )


title = index.date_obs
foreach tt, title do print, tt

;
dw
wx = 8.5
wy = 11.0
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
im = objarr(n_elements(z_ind))
;
for ii = 0, n_elements(im)-1 do begin
    im[ii] = IMAGE2( $
        imdata[*,*,ii], $
        /current, $
        layout=[2,3,ii+1], $
        margin=0.075, $
;        min_value=0.0, $
;        max_value=2869, $
        title='(' + strtrim(ii+1,1) + ') ' + title[ii], $
        ;title=index[ii].date_obs, $
        rgb_table=rgb_table, $
        buffer=buffer $
    )
    ;save2, title[ii], /timestamp
endfor
;
class = strsplit( flare.class, '.', /extract )
filename = class[0] + class[1] + '_' + strlowcase(instr) + strtrim(channel,1) + '_fulldisk'
print, filename
;
save2, filename, /timestamp




;+
;-
;- IMAGE full disk & estimate AR center coords (pixels... not same as xcen, ycen of all
;-   the other flares. Crap....
;- For now, just define center directly instead of coverting to pixels from 
;-    xcen,ycen (different units, different point of reference).


;imdata = AIA_INTSCALE( data[*,*,z_ind], exptime=exptime, wave=channel )
;-   NOTE : need EXPTIME defined already in order to use AIA_INTSCALE...

;
;
;



;center = [  ,  ]


;=======



;
dimensions = [800,800]
;- "align_dimensions" in @parameters = [1000,800]... more padding than necessary?
;-    Alignment procedures take long enough as it is...
;-
center = (full_dimensions/2) + ([ flare.xcen, flare.ycen ] / spatial_scale)
print, center
center =  (half_dimensions)  +  ([ flare.xcen, flare.ycen ] / spatial_scale)
print, center


;([ flare.xcen, flare.ycen ] / spatial_scale)
;- [] get full disk pixel dimensions from headers instead of hard-coding. Also spatial scale.
;-
cube = CROP_DATA( data, dimensions=dimensions, center=center )
;help, cube
sz = size(cube, /dimensions)
;

stop;---------

;==========  End of notes from 07 Jan 2021  ==========;



;+
;- Alignment
;-


date = flare.year + flare.month + flare.day
path = '/solarstorm/laurel07/flares/' + date + '/'
print, path
;
savfile = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
print, savfile
;
restore, path + savfile
;


sz = size(cube, /dimensions)
ref = cube[*,*,sz[2]/2]
help, ref
;

display = 0 ;- need to refresh on what PLOT_SHIFTS does before using this.
;
resolve_routine, 'align_loop', /either


ALIGN_LOOP, cube, ref, allshifts=allshifts, display=display, buffer=buffer

fname = strsplit( flare.class, '.', /extract )
savfile = fname[0] + fname[1] + '_' +  $
    strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
print, savfile

stop;-----------------------------------------------------------------------------

save, cube, ref, allshifts, filename=savfile

;- REMEMBER : cube is MODIFIED when returned to caller! May want to make a
;-  second variable to duplicate the original, especially if full-disk data
;-  is undefined to free up memory. Otherwise, will have to start over with
;-  READ_SDO, crop data, blah blah blah.


;+
;- Power maps
;-


cadence = 24
dz = 64

print,  COMPUTE_POWERMAPS( /syntax )
;print, where( index.nsatpix ne 0 )

satlocs = where( index.nsatpix gt 0 )
help, satlocs

nsatpix = index.nsatpix
help, nsatpix

sz = size(cube2, /dimensions)

;-
z_start = [0:sz[2]-dz]

;- This z_start array is for full ts, which I don't need right now...
;z_start = (where( strmid(index.date_obs,11,5) eq flare.tstart ))[0]

print, z_start
print, z_start + dz -1
print, index[z_start].date_obs
print, flare.tstart
print, index[z_start+dz-1].date_obs
print, flare.tend


;====
map = COMPUTE_POWERMAPS( cube/exptime, cadence, dz=dz, z_start=z_start )
;====


save, map, map2, filename='M10_aia1600map.sav'


print, max(cube2) / (max( cube2/exptime) )
print, ( max(cube2) / (max( cube2/exptime) ) )^2

print, exptime^2

print, max(map) / max(map2)
;print, min(map) / min(map2)
;-  same factor whether min or max or in between, just like every pixel
;-   in data cubes differes
;-  by factor = exptime ... because one was divided by exptime... der.


;- ===>>>  NO LONGER setting threshold. Compute power for ALL pixels,
;-   Can easily compute MASK using threshold and original pixel values
;-    (where "original" pixel values are the ones used to compute the map
;-   in the first place).

maps = [ [[map]], [[map2]] ]

undefine, map
undefine, map2
   ;-  don't like these variable names anyway; espeically confusing when
   ;-   concurrent with "cube" and "cube2", but DO NOT correspond to each
   ;-  other AT ALL.


title = [ 'raw data', 'exptime-corrected' ]
;
im = objarr(2)
dw
win = window(/buffer)

imdata = maps
locs = where( imdata gt 950 and imdata lt 1000 )

help, array_indices( imdata, locs )
print, imdata[(array_indices( imdata, locs ))[*,0]]

print, imdata[ 228, 139, 0]

print, ''
print, min(imdata[*,*,0]), format=format
print, min(imdata[*,*,1]), format=format
print, max(imdata[*,*,0]), format=format
print, max(imdata[*,*,1]), format=format
print, ''
;

imdata = AIA_INTSCALE(maps, exptime=exptime, wave=channel )
print, imdata[ 228, 139, 0]

print, min(imdata[*,*,0]), format=format
print, min(imdata[*,*,1]), format=format
print, max(imdata[*,*,0]), format=format
print, max(imdata[*,*,1]), format=format
print, ''

for ii = 0, 1 do begin
    im[ii] = IMAGE2( $
        imdata[*,*,ii], $
        /current, $
        layout=[2, 1, ii+1], $
        margin=0.05, $
        title=title[ii], $
        rgb_table=rgb_table, $
        /buffer $
    )
endfor
;
save2, 'M10_aia1600map', /timestamp


print, ''
format='(e0.4)'
for ii = 0, 1 do begin
    print, min(maps[*,*,ii]), max(maps[*,*,ii]), format=format
    print, ''
endfor
print, ''


end
