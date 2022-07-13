;+
;- 24 February 2021 (Thursday)
;-


;===
;==========================================================================
;=
;=  fits filenames for, e.g. AIA 1600\AA{}
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
;-  []  Power maps "during"
;-
;-  []  Find coords of 20141023 flare, save cube and index to .sav files:
;-            20141023_aia1600cube.sav
;-            20141023_aia1700cube.sav
;-
;-  []  Image HMI alongside concurrent AIA obs; check relative AR position.
;-          Read HMI level 1.5 fits
;-           Image full disk, 6 panels like yesterday
;-              scale continuum and/or mag ... otherwise, just get white, washed out disk...
;-           Eyeball center coords of AR
;-           Extract subset with same center and dimensions as AIA, e.g. --> "M10_hmi_mag_cube.sav"
;-
;- [] copy today.pro to some Module generalized for running alignment
;-    on any group of level 1.5 fits files (or level 1.0, shouldn't matter)
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

flare_index = 0  ; M1.5
;flare_index = 1  ; C8.3
;flare_index = 2  ; C4.6 ==>> No center coords (xcen,ycen)!!
;flare_index = 3  ; M1.0
;-


buffer = 1

instr = 'aia'
;channel = 1600
channel = 1700


@par2
;- multiflare = { m15:m15, c83:c83, c46:c46, m10:m10 }
;help, multiflare
flare = multiflare.(flare_index)

date = flare.year + flare.month + flare.day
path = '/solarstorm/laurel07/flares/' + date + '/'
print, path

;filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
class = strsplit(flare.class, '.', /extract)


;filename1 = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
;restore, path + filename1
;im = image2( sqrt(cube[*,*,0]), buffer=buffer )
;save2, 'test1'
;dw
;undefine, cube
;;
;filename2 = class[0] + class[1] + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;restore, path + filename1
;im = image2( sqrt(cube[*,*,0]), buffer=buffer )
;save2, 'test2'
;dw
;






;+
;========================================================================================
;== Power maps
;-

cadence = 24
dz = 64


filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
restore, filename

oldcube = cube
cube = crop_data( oldcube, dimensions=[400,400], center=[ 400, 400 ] )

;print, array_equal( index.exptime, index[0].exptime )
exptime = 1.0
sz = size(cube, /dimensions)

;satlocs = where( index.nsatpix gt 0 )
;print, index[satlocs].nsatpix


time = strmid(index.date_obs, 11, 8)
print, time[0]

;-
;z_start = [0:sz[2]-dz]
;-  indices for full ts, which I don't need right now...

;- indices to compute power map from time series of length dz, starting at flare start.
z_start = (where( strmid(index.date_obs,11,5) eq flare.tstart ))[0]
;
print, z_start
print, z_start + dz -1
print, index[z_start].date_obs
print, flare.tstart
print, index[z_start+dz-1].date_obs
print, flare.tend

;aia_lct, rr, gg, bb, wavelnth=channel, /load
rgb_table=AIA_GCT( wave=channel )

dw
;imdata = cube[*,*,z_start]

z_peak = (where( strmid(index.date_obs,11,5) eq flare.tpeak ))[0]
print, z_start
print, z_peak

;====
;print,  COMPUTE_POWERMAPS( /syntax )
map = COMPUTE_POWERMAPS( cube/exptime, cadence, dz=dz, z_start=z_start )
;====

imdata = [ $
    [[ AIA_INTSCALE( cube[*,*,z_peak], wave=channel, exptime=exptime ) ]], $
    [[ AIA_INTSCALE( map, wave=channel, exptime=exptime ) ]] $
]



title = flare.class + '  ' + flare.year + '-' + flare.month + '-' + flare.day + '  '  $
    + [ time[z_peak]+ ' (intensity) ' , time[z_start] + '-' + time[z_start+dz-1] + ' (power map)' ]
;

dw
wx = 8.5
wy = wx/2
win=window( dimensions=[wx,wy]*dpi, buffer=buffer )
im = objarr(2)
for ii = 0, 1 do begin
    im[ii] = image2( $
        imdata[*,*,ii], $
        /current, $
        layout=[2,1,ii+1], $
        margin=0.10, $
        title=title[ii], $
        rgb_table=rgb_table, $
        buffer=buffer $
    )
endfor
save2, 'test'


stop;---------------------



;save, map, map2, filename='M10_aia1600map.sav'
;save, map, filename='M10_aia1600map.sav'

filename = class + '_' + date + '_' + strlowcase(instr) + strtrim(channel,1)  + 'map.sav'
print, filename

save, map, filename=filename







;-
;==
;============================================================================================


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
