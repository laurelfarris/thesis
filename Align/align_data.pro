;
; Last modified:   04 June 2018
;
; ROUTINE:    align_data.pro
;
; PURPOSE:    Run align_cube3 on a loop until standard deviation
;              of shifts don't change by a significant amount.
    ; aligns data to reference image on a loop,
    ; using standard deviation of shifts as a breaking point
    ; (when it no longer decreases).
;
; SUBROUTINES:  alignoffset.pro
;               shift_sub.pro
;               align_cube3.pro
;
; Alignment steps (in general):
;   1. read data
;   2. image center and locate center coords (x0, y0)
;   3. crop data to size 750x500 relative to center (for final dims=[500,330])
;   4. Align
;   5. save to '*aligned.sav' file
;
;- 22 April 2019
;- Is there any benefit to have this in a subroutine?
;-   Cleans it up a bit, easier to remind myself what the routine does
;-   if I haven't looked at it in a while (25 July 2019)
;-
;- TEST: check n_elements(fls) and TIME portion of each filename.
;-    596 for AIA 1600
;-    594 for AIA 1700
;-    1195 for AIA 1700
;-  NOTE: previous 3 lines are for a specific event.. don't remember which one
;-   (25 July 2019)
;-
;- NOTE:
;-   "align_data" procedure is duplicate of subroutine in "align_in_pieces";
;-   see top of "align_in_pieces.pro" for similar comments.
;-  (23 July 2019)
;-
;- TO DO:
;-   [] Copy plotting routine to separate subroutine called, e.g. "plot_shifts.pro"
;-      That way it can easily be called in the alignment loop AND after procedure is finished.
;-   [] Do st with subroutine for plotting # sat pixels in Align/
;-
;+


pro ALIGN_DATA, cube, ref, allshifts, display=display

    ; save shifts calculated for every iteration.
    sz = size(cube, /dimensions)
    ;allshifts = fltarr( 2, sz[2] )
    allshifts = []

    sdv = []
    print, "Start:  ", systime()
    start_time = systime(/seconds)
    repeat begin
        ALIGN_CUBE3, cube, ref, shifts=shifts

        ;- 25 July 2019
        ;-   Plot shifts to make sure alignment doesn't need extra care.
        if keyword_set(display) then begin
            plt = objarr(2)
            plt[0] = plot2( shifts[0,*], color= 'red', name="X shifts", buffer=1 )
            plt[1] = plot2( shifts[1,*], color='blue', name="Y shifts", overplot=1, buffer=1 )
            leg = legend2( target=plt, /upperright )
            save2, 'align_shifts'
            ;stop -- may as well let code continue to run. If plots don't look right,
            ;         can always stop code via ctrl+c at any time.
        endif

        allshifts = [ [[allshifts]], [[shifts]] ]
        sdv = [ sdv, stddev( shifts[0,*] ) ]
        k = n_elements(sdv)

        print, "stddev(X) = ", sdv[k-1], format='(F0.4)'
            ;- 25 July 2019
            ;-   displaying number not helpful if user doesn't know what it means.

        if k eq 10 then break
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )
    print, "End:  ", systime()
    print, format='(F0.2, " minutes")', (systime(/seconds)-start_time)/60.
end

@parameters
instr='aia'
;channel='304'
;channel='1600'
channel='1700'
print, ''
print, 'channel = ', channel
print, ''


;--- § Read PREPPED fits files

;- Memory issues: Read subsets of data and crop individually.
;-   start_ind = [0:nn]
;-     nn needs to be based on FULL size of fls (no subsets).
;-   Append each cropped subset to cube.
;-  Last: comment "ind" again, set nodata=1, and re-read to get full index back.
;- (Add loop later).
;-
;- Passing huge data cube to crop_data.pro and having a
;-  (slightly less huge) subset passed back
;-  may be much slower than cropping right here at ML...
;-

;cube = []
;ind = [0:999]
;ind = [1000:1194]
;ind = [0:1194]

;start_ind = [0, 150, 300, 450, 700]
; OR
;start_ind = [ $
;    [  0:299], $
;    [300:599], $
;    [600:749] $
;    ]

; foreach ii, start_ind do begin
;    read_my_fits, index, data, fls, $
;        ind=[ii:ii+149]
; endforeach





resolve_routine, 'read_my_fits', /either
READ_MY_FITS, index, data, fls, $
    instr=instr, $
    channel=channel, $
    ;ind=ind, $
    nodata=0, $
    prepped=1, $
    year=year, $
    month=month, $
    day=day

;- Make sure PREPPED fits files were read:
print, index[0].lvl_num
help, data

;print, n_elements(fls)
;print, index[0].wave_str
;print, index[0].lvl_num
;print, index[0].date_obs
;print, index[-1].date_obs


;-
;--- § Crop to subset centered on AR,

help, data
resolve_routine, 'crop_data', /either
cube = CROP_DATA( $
    data, $
    center=center, $ ;- defined in @parameters
    dimensions=[700,500] )
help, cube

;- NOTE: if kw "dimensions" isn't set, defaults to [500,330] in crop_data.pro


;-
;--- § Align prepped, cropped data

;- Use image in center of time series as reference.
sz = size(cube, /dimensions)
ref = cube[*,*,sz[2]/2]
print, sz[2]/2  ;- make sure this is center of ts
print, index[sz[2]/2].date_obs
help, ref

im = image2( $
    AIA_INTSCALE( ref, wave=fix(channel), exptime=index[0].exptime ), $
    buffer=1, rgb_table=AIA_COLORS(wave=fix(channel)) $
)

;if buffer eq 1 then save2, 'figure_name'
;- Only need to save figures when working remotely (or actually want to save the figure..)
save2, 'test_cropped_image'

;- If image looks to be centered and cropped nicely, don't need data variable anymore.
undefine, data



;- Loop through ALIGN_CUBE3 until stddev stops decreasing
ALIGN_DATA, cube, ref, shifts
help, shifts


;- Check values.
print, max( shifts[0,*,0] )
print, max( shifts[0,*,4] )

;- Plot x and y shifts (# pixels) as function of z-index.
;-  (both should = 0 for ref).
plt = objarr(2)
plt[0] = plot2( shifts[0,*], buffer=1, color='red' )
plt[1] = plot2( shifts[1,*], buffer=1, color='blue', overplot=1 )
leg = legend2( target=plt, /upperright )
save2, 'align_shifts'


;- Make sure images don't jump around all willy nilly.
xstepper2, cube, channel=channel, scale=0.75
    ;- Does this work while ssh-ed??

;-
;--- § Save cube and shifts to .sav files.

;path = '/solarstorm/laurel07/20131228/'
path = '/solarstorm/laurel07/' + year + month + day + '/'
print, path

save, shifts, filename = path + instr + channel + 'shifts.sav'
cube = data
save, cube, filename = path + instr + channel + 'aligned.sav'




;restore, '../20131228/aia1600shifts.sav'
;help,  aia1600shifts
;for ii = 0, 5 do print, stddev( aia1600shifts[0,*,ii] )



end
