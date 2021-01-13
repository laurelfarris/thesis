;+
;-
;- 13 January 2021
;-
;- Tasks for today:
;-
;-   []  Run AIA_PREP on HMI data for all four flares
;-    ---> COMPLETE
;-
;-   []  Align AIA data (without help from HMI images --> need power maps by Friday, 1/15 !)
;-    --> INCOMPLETE
;-
;- [] copy today.pro to some Module generalized for running alingment
;-    on any group of level 1.5 fits files (or level 1.0, shouldn't matter)
;-
;===================================================================================
;- "tomorrow.pro" :
;-
;- 14 May 2020
;-
;-
;- [] Prep for new science by commenting and outlining potential codes,
;-      new analysis methods, re-structure old methods (not just the science
;-      part, but also improve genearality of subroutines (can use for any flare),
;-      sort stand-alone bits into (or out of) subroutines, depending on
;-      computational efficiency, memory useage, and most importantly,
;-     ease with which poor simple-minded user (me) is able to ascertain the
;-     purpose, input/output, calling syntax, etc. VERY quickly and can use
;-     it immediately after a long hiatus, preferably with no errors due to
;-     use of variable names/types or filenames that have since been changed,
;-     calls to routines that don't even exist anymore or were absorbed into
;-     another file, kws/args added or taken away, pros changed to funcs or
;-     vice versa... always something.
;-     -
;-     -
;-
;-  What TYPE of results do I want to show for next research article?
;-  Depends on what I'm trying to accomplish, or what science questions
;-  I want to answer. So sort that out, THEN decide what figures to make at first.
;-  Answer the following questions (maybe a writing prompt or two?):
;-    • How will the science Qs posed in this study (and thesis in general)
;-      be answered by the values derived, relationships revealed in plots,
;-      or patterns displayed over images?
;-    •
;-    •
;-
;- TO DO:
;-  [] see @Lit for tons of ideas
;-  [] Enote with collection of figure screenshots from variety of @Lit:
;-     can be relevant to my research/methods or just nice graphics.
;-  [] Codes/ATT/, other Figure ideas written in Enote, Greenie, wherever,
;-     then generate as MANY as possible with sense of urgency.
;-     GOAL is to have ugly-ass graphics plagued by IDL's horrendous defaults,
;-       ~ podcast about forcing yourself NOT to run farther than the edge
;-          of your lawn if you're one of those all-or-nothing perfectionists.
;-
;===================================================================================



;+
;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;
;
;    AIA
;      UNprepped fits (level 1.0):
;        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;
;      PREPPED fits (level 1.5):
;        'AIA20131228_100000_1600.fits'
;        'AIA20131228_100000_0304.fits'
;
;
;    HMI
;      UNprepped (level 1.0):
;        'hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits'
;        'hmi.m_720s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;        'hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;        'hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits'
;
;      PREPPED fits (level 1.5)
;        'HMIyyyymmdd_hhmmss_cont.fits'
;        'HMIyyyymmdd_hhmmss_*?*.fits'
;        'HMIyyyymmdd_hhmmss_mag.fits'
;        'HMIyyyymmdd_hhmmss_dop.fits'
;
;
;---
;-



;+
;- Alignment -- broken down into detailed steps:
;-   • read level 1.5 (PREPPED) fits : index + data
;-   • crop to subset centered on AR
;-   • save to .sav file? If read_sdo takes forever...
;-   • align to center image
;-   • Def. save aligned data cube...


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




;----------------------------------------------------
buffer = 1

instr = 'aia'
channel = 1600
;channel = 1700

flare_index = 0  ; M1.5
;flare_index = 1  ; C8.3
;flare_index = 2  ; C4.6
;flare_index = 3  ; M1.0

;----------------------------------------------------

;for ii = 0, 3 do print, multiflare.(ii).year, multiflare.(ii).month, multiflare.(ii).day

@par2
;- defines structure of structures:
;;-   IDL>   multiflare = { m15:m15, c83:c83, c46:c46, m10:m10 }
;help, multiflare
;help, multiflare.m15
;help, multiflare.c83
;help, multiflare.c46
;help, multiflare.m10


;flare = multiflare.m15
;flare = multiflare.(0)
flare = multiflare.(flare_index)


date = flare.year + flare.month + flare.day
print, date

;- 'AIAyyyymmdd_hhmmss_wave.fits'

path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
fnames = strupcase(instr) + $
    ;flare.year + flare.month + flare.day + $
    date + $
    '*' + strtrim(channel,1) + '.fits'


fls = FILE_SEARCH( path + fnames )

help, fls


stop;---------------------------------------------------------------------------------------------



mem = memory( $
    /current $
    /highwater $
    /num_alloc $
    /num_free $
    /structure $
    ;/L64 $
)
;- kws are all mutually exclusive



ind = [   0:199 ]

start_time = systime()
;READ_SDO, fls, index, data
READ_SDO, fls[ind], index, data
print, "Started at ", start_time
print, "Finished at ",  systime()
;undefine, data



;---
print, array_equal( index.exptime, index[0].exptime )
;-


spatial_scale = index[0].cdelt1
exptime = index[0].exptime

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


;([ flare.xcen, flare.ycen ] / spatial_scale)
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
;- Image data
;-


AIA_LCT, r, g, b, wave=fix(channel)
rgb_table = [ [r], [g], [b] ]


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
