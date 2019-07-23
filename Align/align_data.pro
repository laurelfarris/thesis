;- 23 July 2019
;- --> "align_data" procedure is exact duplicate of the subroutine by the
;-        same name in "align_in_pieces".
;-   See top of "align_in_pieces.pro" for similar comments.
;-
;-
;-
;
; Last modified:   04 June 2018
;
; ROUTINE:    align_data.pro
;
; PURPOSE:    Run align_cube3 on a loop until standard deviation
;              of shifts don't change by a significant amount.
;
; SUBROUTINES:  alignoffset.pro
;               shift_sub.pro
;               align_cube3.pro
;
; Alignment steps (in general):
;   1. read data
;   2. image center and locate center coords (x0, y0)
;   3. crop data to size 750x500 relative to center
;   4. Align
;   5. save to '*aligned.sav' file
;
;- 22 April 2019
;- Is there any benefit to have this in a subroutine?
;-
;-
;- TEST: check n_elements(fls) and TIME portion of each filename.
;-    596 for AIA 1600
;-    594 for AIA 1700
;-    1195 for AIA 1700


pro ALIGN_DATA, cube, ref, allshifts
    ; aligns data to reference image on a loop,
    ; using standard deviation of shifts as a breaking point
    ; (when it no longer decreases).

    ; save shifts calculated for every iteration.
    sz = size(cube, /dimensions)
    ;allshifts = fltarr( 2, sz[2] )
    allshifts = []

    sdv = []
    print, "Start:  ", systime()
    start_time = systime(/seconds)
    repeat begin
        ALIGN_CUBE3, cube, ref, shifts=shifts
        allshifts = [ [[allshifts]], [[shifts]] ]
        sdv = [ sdv, stddev( shifts[0,*] ) ]
        k = n_elements(sdv)
        print, sdv[k-1]
        if k eq 10 then break
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )
    print, "End:  ", systime()
    print, format='(F0.2, " minutes")', (systime(/seconds)-start_time)/60.
end

goto, start

@parameters
instr='aia'
channel='304'


;--- § Read PREPPED fits files

;- Memory issues: Read subsets of data and crop individually.
;-   start_ind = [0:nn]
;-     nn needs to be based on FULL size of fls (no subsets).
;-   Append each cropped subset to cube.
;-  Last: comment "ind" again, set nodata=1, and re-read to get full index back.
;- (Add loop later).

cube = []
;nodata = 0
nodata = 1
;ind = [0:999]
;ind = [1000:1194]
ind = [0:1194]

resolve_routine, 'read_my_fits', /either
READ_MY_FITS, index, data, fls, $
    instr=instr, $
    channel=channel, $
    ind=ind, $
    nodata=nodata, $
    prepped=1, $
    year=year, $
    month=month, $
    day=day

;print, n_elements(fls)
;print, index[0].wave_str
;print, index[0].lvl_num
;print, index[0].date_obs
;print, index[-1].date_obs


;- § Crop to subset centered on AR,
resolve_routine, 'crop_data', /either
data = CROP_DATA( $
    data, $
    center=center, $
    dimensions=dimensions )
;- NOTE: if kw "dimensions" isn't set, defaults to [500,330] in crop_data.pro


;--- § Align prepped, cropped data

;- Use image in center of time series as reference.
sz = size(cube, /dimensions)
ref = cube[*,*,sz[2]/2]

;- Loop through ALIGN_CUBE3 until stddev stops decreasing
ALIGN_DATA, cube, ref, shifts
stop

;- Check values and plot shifts.
;print, max( all_shifts[0,*,0] )
;print, max( all_shifts[0,*,5] )
;plt = plot2( shifts[0,*], color='red' )
;plt = plot2( shifts[1,*], color='blue', overplot=1 )


;- Make sure images don't jump around all willy nilly.
xstepper2, cube, channel=channel, scale=0.75
stop

start:;-------------------------------------------------------------------------

channel = '304'

;- Save cube and shifts to .sav files.

;path = '/solarstorm/laurel07/20131228/'
path = '/solarstorm/laurel07/' + year + month + day + '/'

save, shifts, filename = path + instr + channel + 'shifts.sav'
save, cube, filename = path + instr + channel + 'aligned.sav'


end
