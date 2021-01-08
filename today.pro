;+
;- 06 January 2021
;-
;- []  Align data
;-
;-      Steps:  
;-       • read level 1.5 (PREPPED) fits : index + data
;-       • crop to subset centered on AR
;-       • save to .sav file? If read_sdo takes forever...
;-       • align to center image
;-       • Def. save aligned data cube...
;-
;- [] copy today.pro to some Module generalized for running alingment
;-    on any group of level 1.5 fits files (or level 1.0, shouldn't matter)
;-




;-   C8.3 2013-08-30 T~02:04:00
;-   M1.0 2014-11-07 T~10:13:00
;-   M1.5 2013-08-12 T~10:21:00
;-   C4.6 2014-10-23 T~13:20:00
;-

buffer = 1

@par2
help, multiflare
flare = multiflare.m15

stop;-----------------------------------------------------------------------------

instr = 'aia'
channel = 1600
;channel = 1700
AIA_LCT, r, g, b, wave=fix(channel)
rgb_table = [ [r], [g], [b] ]

path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
fnames = strupcase(instr) + $
    flare.year + flare.month + flare.day + '*' + strtrim(channel,1) + '.fits'
fls = FILE_SEARCH( path + fnames )

stop;-----------------------------------------------------------------------------

READ_SDO, fls, index, data

;help, index
;help, data

tags = tag_names(index[0])
print, n_tags(index)
tags = tag_names(index)
print, n_tags(index)
;- same in both cases : tags is NOT duplicated 750 times...

print, where( tags eq 'EXPTIME' )
;print, where( index[0] eq 4096 )
;-  ==>> ERROR :
;-    can't search for structure values this way...
;-  How CAN you search for a particular value if tagname is unknown??
;-


spatial_scale = index[0].cdelt1
exptime = index[0].exptime
;

print, index[0].naxis1
print, index[0].naxis2
print, index[0].crpix1
print, index[0].crpix2

print, index[0].pixlunit

full_dimensions = [ index[0].naxis1, index[0].naxis2 ]
half_dimensions = [ index[0].crpix1, index[0].crpix2 ]
;- Which is more accurate??
;
AR_center = [ flare.xcen, flare.ycen ]
;
dimensions = [800,800]
;- "align_dimensions" in @parameters = [1000,800]... more padding than necessary?
;-    Alignment procedures take long enough as it is...
;-
center = (full_dimensions/2) + ([ flare.xcen, flare.ycen ] / spatial_scale)
print, center
center =  (half_dimensions)  +  ([ flare.xcen, flare.ycen ] / spatial_scale)
print, center


([ flare.xcen, flare.ycen ] / spatial_scale)
;- [] get full disk pixel dimensions from headers instead of hard-coding. Also spatial scale.
;-
cube = CROP_DATA( data, dimensions=dimensions, center=center )
;help, cube
sz = size(cube, /dimensions)
;
zz = intarr(6)
zz[0] = 0
zz[1] = (where( strmid( index.date_obs, 11, 5 ) eq m10.tstart ))[0]
zz[2] = (where( strmid( index.date_obs, 11, 5 ) eq m10.tpeak ))[0]
zz[3] = (where( strmid( index.date_obs, 11, 5 ) eq m10.tend ))[0]
zz[4] = sz[2]/2
zz[5] = sz[2]-1
;
imdata = AIA_INTSCALE( $
    cube[*,*,zz], wave=fix(channel), exptime=exptime )
;
title = index[zz].date_obs
;foreach tt, title do print, tt

stop;-----------------------------------------------------------------------------

;+
;- Image

im = objarr(n_elements(zz))
for ii = 0, n_elements(im)-1 do begin
    win = window(buffer=buffer)
    im[ii] = IMAGE2( $
        imdata[*,*,ii], $
        /current, $
        title='(' + strtrim(ii,1) + ') ' + title[ii], $
        rgb_table=rgb_table, $
        buffer=buffer $
    )
    save2, title[ii], /timestamp
    dw
endfor

stop;-----------------------------------------------------------------------------

;- If images look okay, free up some memory:
undefine, data


;+
;-
;- Alignment!!
;-

ref = cube[*,*,sz[2]/2]

display = 0 ;- need to refresh on what PLOT_SHIFTS does before using this.

resolve_routine, 'align_loop', /either
ALIGN_LOOP, cube, ref, allshifts=allshifts, display=display, buffer=buffer

fname = strsplit( flare.class, '.', /extract )
savfile = fname[0] + fname[1] + '_' +  $
    strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
print, savfile

stop;-----------------------------------------------------------------------------

save, cube, ref, allshifts, filename = ''

;- REMEMBER : cube is MODIFIED when returned to caller! May want to make a
;-  second variable to duplicate the original, especially if full-disk data
;-  is undefined to free up memory. Otherwise, will have to start over with
;-  READ_SDO, crop data, blah blah blah.



;=============================================================================


;+
;- Move ahead with one flare, align the rest later.
;-


;- 07 January 2021  ~19:20
;- IDL> .reset_session

;- Plot shifts from first alignment (M1.0)
restore, 'M10_aia1600aligned.sav'
help, cube
help, ref
help, allshifts

@par2

flare = multiflare.m10
;

fname = strsplit( flare.class, '.', /extract )
savfile = fname[0] + fname[1] + '_' +  $
    strlowcase(instr) + strtrim(channel,1) + 'shifts'
;
print, savfile


buffer = 1
color = [  'red', 'blue' ]
name = [ 'xshifts', 'yshifts'  ]
;
plt = objarr(2,9)


xdata = indgen( (size(allshifts, /dimensions))[1] )
help, xdata



wx = 8.0
wy = wx

;ind = [100:150]
ind = [120:130]

dw

dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
;
for jj = 0, 8 do begin
    for ii = 0, 1 do begin
        plt[ii,jj] = plot2( $
            xdata[ind], $
            allshifts[ii, ind, jj],  $
            /current, $
            layout = [3, 3, jj+1] , $
            margin = 0.12, $
            overplot = 1<ii , $
            color = color[ii], $
            name = name[ii], $
            buffer = buffer $
        )
    endfor
endfor
;
save2, savfile, /timestamp


;xstepper, cube
;- WAAAAAY too slow..


ind = [124:127]
foreach ii, ind do begin
    print, ii
endforeach

;READ_SDO, fls, index, /nodata
;exptime = index[0].exptime

ii = 124
title = strtrim(ii,1) + ' ' + index[ii].date_obs

dw
foreach ii, ind do begin
    im = image2( $
        AIA_INTSCALE(cube[*,*,ii], wave=channel, exptime=exptime ), $
        title = '[' + strtrim(ii,1) + ']  ' + index[ii].date_obs, $
        buffer=buffer $
    )
    save2, 'image-at-big-shift' + '_' + strtrim(ii,1)
endforeach

;+
;-

cube2 = CROP_DATA( cube, dimensions=[400,400] )

dw
imdata = AIA_INTSCALE( cube2[*,*,0], exptime=exptime, wave=channel )
im = image2( imdata, /buffer )
save2, 'cropped_cube_SCALED' + index[0].date_obs

dw
imdata = AIA_INTSCALE( cube2[*,*,-1], exptime=exptime, wave=channel )
im = image2( imdata, /buffer )
save2, 'cropped_cube_SCALED' + index[-1].date_obs



;+
;- Powermaps

channel_LONG = index.wavelnth
channel_STR  = index.wave_str

cadence = 24
dz = 64

print,  COMPUTE_POWERMAPS( /syntax )
;print, where( index.nsatpix ne 0 )

satlocs = where( index.nsatpix gt 0 )
help, satlocs

nsatpix = index.nsatpix
help, nsatpix

sz = size(cube2, /dimensions)
threshold = 15000

;-
z_start = [0:sz[2]-dz]
    ;- from new_powermaps.pro
    ;-  (tho probably defined z_start like this in other codes too..)
    ;-  Apparently by default, only computes ONE power map using range starting
    ;-   with [0] through [0] + dz ... or + dz -1 ... I dunno.
;print, z_start
;print, z_start[-1] + dz
;- NOTE : in compute_powermaps.pro, FT applied to range [ zz : zz+dz-1 ]
;-    So no need to subtract 1 here to ensure I don't get error of
;-     "subscript with <index> that is out of range"  or wtf ever.
;-

;- This z_start array is for full ts, which I don't need right now...
z_start = (where( strmid(index.date_obs,11,5) eq flare.tstart ))[0]

print, z_start
print, z_start + dz -1
print, index[z_start].date_obs
print, flare.tstart
print, index[z_start+dz-1].date_obs
print, flare.tend


map  = COMPUTE_POWERMAPS( cube2, cadence, dz=dz, z_start=z_start )
map2 = COMPUTE_POWERMAPS( cube2/exptime, cadence, dz=dz, z_start=z_start )


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
