;+
;- 01 February 2021 (Monday)
;-
;-
;- TO DO:
;-
;-  []  Restore "...cube.sav" for each flare and IMAGE first and last obs, and maybe peak.
;-      If possible, crop cube to smaller dimensions, i.e. if padding beyond AR boundaries is
;-      more than enough to account for edge effects in x-dir due to rotation over 5-hour window.
;-      Wouldn't matter, except restoring these files takes a non-trivial amount of time.
;-   --> COMPLETE
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

instr = 'aia'
;channel = 1600
channel = 1700

;instr = 'hmi'


flare_index = 0  ; M1.5
;flare_index = 1  ; C8.3
;flare_index = 2  ; C4.6
;-  2014-10-23 --> No center coords
;flare_index = 3  ; M1.0

;--------


@par2
;- defines structure of structures:
;;-   IDL>   multiflare = { m15:m15, c83:c83, c46:c46, m10:m10 }
;help, multiflare

flare = multiflare.(flare_index)
date = flare.year + flare.month + flare.day
print, date

;stop;---------------------------------------------------------------------------------------------

path = '/solarstorm/laurel07/flares/' + date + '/'
print, path


restorefile = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
print, restorefile

restore, path + restorefile

help, index
help, cube


spatial_scale = index[0].cdelt1
exptime = index[0].exptime

;+
;- IMAGING
;-
;- NOTE: for imaging, used a lot of code from 2021-01-22.pro (search for "image2")
;-
;-   • z-index('s)
;-   • aia_lct (UV channel std colors)
;-   • ref ( sz[2]/2 )
;-   •
;-



sz = size(cube, /dimensions)
;
z_indices = intarr(6)
z_indices[0] = 0
z_indices[1] = (where( strmid( index.date_obs, 11, 5 ) eq flare.tstart ))[0]
z_indices[2] = (where( strmid( index.date_obs, 11, 5 ) eq flare.tpeak ))[0]
z_indices[3] = (where( strmid( index.date_obs, 11, 5 ) eq flare.tend ))[0]
z_indices[4] = sz[2]/2
z_indices[5] = sz[2]-1
;
imdata = AIA_INTSCALE( $
    cube[*,*,z_indices], wave=fix(channel), exptime=exptime )
;


;----------

title = index[z_indices].date_obs
foreach tt, title do print, tt

AIA_LCT, r, g, b, wave=fix(channel)
rgb_table = [ [r], [g], [b] ]



imdata = AIA_INTSCALE( $
    cube[*,*,z_indices], wave=fix(channel), exptime=exptime )
    ;- [] compare to aia_intscale applied to each 2D image individually, not sure how 3D cube is handled.
help, imdata


title = index[z_indices].date_obs
;foreach tt, title do print, tt


stop;---------------------------------------------------------------------------------------------


wx = 8.5
wy = 11.0
;
im = objarr(n_elements(z_indices))

dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
;
for ii = 0, n_elements(im)-1 do begin
    im[ii] = IMAGE2( $
        imdata[*,*,ii], $
        /current, $
        layout=[2,3,ii+1], $
        margin=0.075, $
        title='(' + strtrim(ii+1,1) + ') ' + title[ii], $
        rgb_table=rgb_table, $
        buffer=buffer $
    )
    ;save2, title[ii], /timestamp
endfor
;
class = strsplit( flare.class, '.', /extract )
;help, class
filename = class[0] + class[1] + strlowcase(instr) + strtrim(channel,1) + 'images.pdf'
;print, filename
;
save2, filename, /timestamp



end
