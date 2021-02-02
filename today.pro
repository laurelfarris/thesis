;+
;- 02 February 2021 (Tuesday)
;-   Part 2: align only. Remove clutter code.
;-


;===
;==========================================================================
;=
;= FIRST : Naming convention of fits files for, e.g. AIA 1600\AA{}
;=  (tired of looking this up all the time...)
;=
;=
;=    AIA
;=      UNprepped fits (level 1.0):
;=        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;=        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;=
;=      PREPPED fits (level 1.5):
;=        'AIA20131228_100000_1600.fits'
;=        'AIA20131228_100000_0304.fits'
;=
;=
;=    HMI
;=      UNprepped (level 1.0):
;=        'hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits'
;=        'hmi.m_720s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;=        'hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;=        'hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits'
;=
;=      PREPPED fits (level 1.5)
;=        'HMIyyyymmdd_hhmmss_cont.fits'
;=        'HMIyyyymmdd_hhmmss_*?*.fits'
;=        'HMIyyyymmdd_hhmmss_mag.fits'
;=        'HMIyyyymmdd_hhmmss_dop.fits'
;=
;=
;==========================================================================
;===


;+
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
;-          Read HMI level 1.5 fits
;-           Image full disk, 6 panels like yesterday
;-              scale continuum and/or mag ... otherwise, just get white, washed out disk...
;-           Eyeball center coords of AR
;-           Extract subset with same center and dimensions as AIA, e.g. --> "M10_hmi_mag_cube.sav"
;-
;- [] copy today.pro to some Module generalized for running alignment
;-    on any group of level 1.5 fits files (or level 1.0, shouldn't matter)
;-    --> INCOMPLETE
;-


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
;flare_index = 0  ; M1.5
flare_index = 1  ; C8.3
;flare_index = 2  ; C4.6 ==>> No center coords (xcen,ycen)!!
;flare_index = 3  ; M1.0
;-


buffer = 1

instr = 'aia'
;channel = 1600
channel = 1700

;

@par2
;- multiflare = { m15:m15, c83:c83, c46:c46, m10:m10 }
;help, multiflare
flare = multiflare.(flare_index)

date = flare.year + flare.month + flare.day
path = '/solarstorm/laurel07/flares/' + date + '/'
print, path



;+
;========================================================================================
;== Alignment
;-

filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
print, filename
restore, path + filename


stop


sz = size(cube, /dimensions)
ref = cube[*,*,sz[2]/2]
help, ref


display = 0 ;- need to refresh on what PLOT_SHIFTS does before using this.
;
resolve_routine, 'align_loop', /either
ALIGN_LOOP, cube, ref, allshifts=allshifts, display=display, buffer=buffer

fname = strsplit( flare.class, '.', /extract )
savfile = fname[0] + fname[1] + '_' +  $
    strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
print, savfile


SAVE, cube, ref, allshifts, filename=savfile
;-  [] include INDEX in saved variables?


;- REMEMBER : cube is MODIFIED when returned to caller! May want to make a
;-  second variable to duplicate the original, especially if full-disk data
;-  is undefined to free up memory. Otherwise, will have to start over with
;-  READ_SDO, crop data, blah blah blah.


;+
;========================================================================================
;== Power maps
;-


path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
fnames = strupcase(instr) + date + '*' + strtrim(channel,1) + '.fits'
fls = FILE_SEARCH( path + fnames )
help, fls

READ_SDO, fls, index, data, /nodata

SAVE, cube, ref, allshifts, filename=savfile


stop;-----

;- --> restore .sav file that was WRITTEN just before this step (like 20 lines up)
;filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
class = strsplit(flare.class, '.', /extract)
filename = class[0] + class[1] + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
print, path + filename
;restore, path + filename

print,  COMPUTE_POWERMAPS( /syntax )

cadence = 24
dz = 64


;print, where( index.nsatpix ne 0 )
;satlocs = where( index.nsatpix gt 0 )


sz = size(cube, /dimensions)

;-
;z_start = [0:sz[2]-dz]
;-  indices for full ts, which I don't need right now...

;- indices to compute power map from time series of length dz, starting at flare start.
z_start = (where( strmid(index.date_obs,11,5) eq flare.tstart ))[0]

print, z_start
print, z_start + dz -1
print, index[z_start].date_obs
print, flare.tstart
print, index[z_start+dz-1].date_obs
print, flare.tend

;====
map = COMPUTE_POWERMAPS( cube/exptime, cadence, dz=dz, z_start=z_start )
;====


;save, map, map2, filename='M10_aia1600map.sav'
save, map, filename='M10_aia1600map.sav'


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
