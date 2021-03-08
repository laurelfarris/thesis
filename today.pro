;+
;- 04 March 2021
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
;-  []  Full power map cube for ONE flare (no saturation, proper alignment)
;-

@par2

;- C8.3 2013-08-30 T~02:04:00  (1)

;flare_index = 1  ; C8.3
;flare = multiflare.(flare_index)
;-
;- OR, since flare_index is not used anywhere else, just use the TAGNAME:
flare = multiflare.C83
;-




buffer = 1
;
instr = 'aia'
;channel = 1600
channel = 1700
;
date = flare.year + flare.month + flare.day
class = strsplit(flare.class, '.', /extract)

;-------------------------------------------------------------------------------
;- 04 March 2021 : re-saving align.sav with "index" included.

path = '/solarstorm/laurel07/flares/' + date + '/'
filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;
restore, path + filename
;
help, index
  ;-  not saved in aligned.sav files..
help, cube
help, allshifts

stop

;- temporary cube to preserve ALIGNED cube
cube2 = cube

filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
restore, path + filename

;- confirm that cube and cube2 are not the same anymore, cube restored from
;-    cube.sav files is same size, but pre-alignment.
print, cube[0,0,0]
print, cube2[0,0,0]

;- return ALIGNED cube values to cube variable and get rid of backup.
cube = cube2
undefine, cube2


filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
save, index, cube, allshifts, filename=filename


stop;--------------------------------------------------------------------------

;- new idl session, restore .sav file I just made and make sure all variables are there
filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
restore, filename
help, cube
help, index
help, allshifts




;
cadence = 24
dz = 64
;
oldcube = cube
cube = crop_data( oldcube, dimensions=[400,400], center=[ 400, 400 ] )
help, cube

undefine, oldcube

;
;print, array_equal( index.exptime, index[0].exptime )
;
;print, where( index.exptime le 2.90 )
;print, where( index.exptime ge 2.91 )
;-  -1 in both cases (04 March 2021)
;exptime = 1.0
exptime = index[0].exptime
;print, exptime
;
sz = size(cube, /dimensions)
;
;satlocs = where( index.nsatpix gt 0 )
;print, index[satlocs].nsatpix
;
;
time = strmid(index.date_obs, 11, 8)
;print, time[0]


;============================================================

;-
z_start = [0:sz[2]-dz]
;-  indices for full ts

;- indices to compute power map from time series of length dz, starting at flare start.
;z_start = (where( strmid(index.date_obs,11,5) eq flare.tstart ))[0]

print, z_start[-1]
print, z_start[-1] + dz -1

;print, index[z_start].date_obs
print, flare.tstart
print, index[z_start[-1]+dz-1].date_obs
print, flare.tend

;aia_lct, rr, gg, bb, wavelnth=channel, /load
;rgb_table=AIA_GCT( wave=channel )
;
;dw
;imdata = cube[*,*,z_start]

;z_peak = (where( strmid(index.date_obs,11,5) eq flare.tpeak ))[0]
;print, z_start
;print, z_peak


STOP


;====
;print,  COMPUTE_POWERMAPS( /syntax )
map = COMPUTE_POWERMAPS( cube/exptime, cadence, dz=dz, z_start=z_start )
save, map, filename='1700map.sav'
;-  started 23:58 04 March (Eastern time) for 1600Å, 2:52 05 March for 1700Å
;-    Only put in "save" command for the latter... hopefully won't crash
;-    before I get a chance to save 1600 map..
;====


print, '===---'
;
start_time = systime(/seconds)
wait, 5.5
minutes = (systime(/seconds) - start_time)/60
hours = (systime(/seconds) - start_time)/3660
format='( "Power maps calculated in ~", F0.2, " minutes (", F0.4, " hours)" )'
print, format=format, minutes, hours
;print, format='( "Power maps calculated in ~", F0.2, " minutes (", F0.4, " hours)" )', minutes, hours
;print, format='( "    (", F0.4, " hours)." )', hours
;
print, '===---'


;+
;- IMAGE power maps
;-

impulsive_phase = (where( strmid(time,0,5) eq flare.tpeak ))[0] - dz
decay_phase = impulsive_phase + dz

;before = impulsive_phase - 
before = (where( strmid(time,0,5) eq flare.tstart ))[0] - dz
print, time[before]


z_ind = [ $
    (where( strmid(time,0,5) eq flare.tpeak ))[0], $
]
print, z_ind
print, time[z_ind]
print, flare.tpeak

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
