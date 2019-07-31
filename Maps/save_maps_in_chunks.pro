
; Last modified:   12 July 2018 (changed threshold from hard-coded variable
;     to optional keyword
; Calculates power map
; Input:  data = 3D data cube for which to calculate power maps
;      z_start = array of START indices
;           dz = length over which to calculate FT (# images)
;      cadence = cadence of data (seconds)
; NOTES:     (May 11 2018) Added /NORM keyword to fourier2.
;            (May 13 2018) switched from TOTAL to MEAN power.

;; TO-DO:
;;   Make another level of subroutines for all the specifics below,
;;   one for several different situations. Each of them call the
;;   general routine above, and all return essentially the same thing.

; 15 June 2018
; Reading in data and creating maps first, without messing with
;  structures or dictionaries (yet). Do need to interpolate though!

; 23 September 2018
; Removing part that excludes saturation. Will take longer to compute,
;  but better to have extra information that can easily be excluded,
;  in this case, by using masks.

;- 19 October 2018
;- Now putting it back... only calculating four maps, which can be done
;- fast enough to test different threshold values.
;-   Added if statement to use code that manages saturated pixels
;-   only if threshold kw is set.

;-
;------------------------------------------------------------------------
;- 31 July 2019
;- ML code following definition of function "compute_powermaps".
;- Separated ML part into its own file.


ii = 0
map6 = MAKE_FEW_MAPS( A[ii].data, A[ii].time )
stop


; 2018-06-26
;   Restoring aligned data takes too long to run every time I run aia_power_maps
;   to correct minor errors. So pulled these lines back into main level.
;   Should be combined with interpolation routines somwhere (since interpolation
;   needs to be done before maps, but is never saved into .sav files).
; 2018-06-27
;   Really glad I commented this... I was about to put those lines back into
;   the subroutine :)

; Restore aligned data cube (not map yet)
channel = '1600'
restore, '../aia' + channel + 'aligned.sav'
cube = crop_data(cube)

; Interpolate to get missing data and corresponding timestamp.
; (pulled lines from prep.pro, but this should be separated).
; Don't need to read fits at all when interp isn't needed.
; This is just to get date_obs, used as test for missing data.
if channel eq '1700' then begin
    ;READ_MY_FITS, 'aia', channel, index, data, nodata=1, prepped=1
    READ_MY_FITS, index, data, inst='aia', channel=channel, nodata=1;, prepped=1
    time = strmid( index.date_obs,  11, 11 )
    jd = get_jd( index.date_obs + 'Z' )
    cadence = 24
    LINEAR_INTERP, cube, jd, cadence, time
endif

; 27 June 2018 - finishing map for AIA 1700 (indices z = 650:684)
; (after .reset_session), at ML.
; subroutine hiccup: case where restoring and continuing existing map...
; Copied code from AIA_POWER_MAPS and commented/modified as needed.

; 28 June 2017 - finishing map (norm=1) for AIA 1600
; step is for saving map every 50-th timestep...
;    don't need it for last 30 or so images (halted because i was out
;    of range, not because I lost ssh connection)

; Find z-index at which computation of power map stopped and set = start
; Notes from 27 June 2018
if 0 gt 1 then begin ; sneaky comment :)
    sz = size(map, /dimensions)
    map_total = fltarr(sz[2])
    for i = 0, sz[2]-1 do $
        map_total[i] = total(map[*,*,i])
    unfinished_ind = where(map_total eq 0.0)
    print, unfinished_ind[0]
    ;print, unfinished_ind - shift(unfinished_ind, 1)
    stop
endif

start = 250
file = 'aia' + channel + 'map_norm.sav'
AIA_MAPS, cube, channel, file, start=start, norm=1
stop


;----------------------------------------------------------------------------------
; another .reset_session

restore, 'aia1700map_final.sav'
map_final = map[*,*,0:649]
restore, '../aia1700map.sav'
map = map[*,*,0:649]

print, where( map_final ne map)

; output = -1, so we should be good!

restore, 'aia1700map_final.sav'
help, map
print, map[200,200,0]

channel = '1700'
save, map, filename='aia' + channel + 'map.sav'

restore, 'aia1700map.sav'
;start:
print, map[200,200,-1]

end
