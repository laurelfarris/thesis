;+
;- LAST MODIFIED:
;-   02 February 2021
;-
;- ROUTINE:
;-   align_loop.pro
;-
;- PURPOSE:
;-   Apply align_cube3 on data cube;
;-   repeat until stddev stops decreasing from one iteration to the next.
;-
;- Calling sequence:
;-   ALIGN_LOOP, cube, ref, allshifts, display=display, buffer=buffer
;-
;- INPUT:
;-   CUBE = 3D data cube of images to align to common reference image:
;-   REF = 2D image
;-
;- OUTPUT:
;-   ALLSHIFTS = optional named variable whose return value is a
;-     3D array with shifts in X and Y for each iteration of align_loop.
;-
;- EXTERNAL SUBROUTINES:
;-     alignoffset.pro
;-     shift_sub.pro
;-     align_cube3.pro
;-  (NOTE : I did not write these)
;-
;- Alignment steps (in general):
;-    1. read data/headers from level 1.5 data (processed with aia_prep.pro)
;-    2. extract subset centered on AR with dimensions padded with enough pixels beyond
;-       boundaries of AR to allow room for edge effects due to shifting
;-       (maximum shift most likely x-direction, ~70 pixels at the most for a 5-hr ts.
;-    3. SAVE subset (cube) + index from lvl 1.5 data to file.sav
;-    4. Align cube.
;-    5. save to '*aligned.sav' file, along with REF and SHIFTS.
;-  NOTE : steps 1-3 are now in a separate routine (see extract_subset.pro).
;-
;-
;- TO DO:
;-   [] Copy plotting routine to separate subroutine called, e.g. "plot_shifts.pro"
;-      That way it can easily be called in the alignment loop AND after procedure is finished.
;-      05 May 2020 -- this box appears to have been checked off at some point...
;-        Go me!
;-   [] Do st with subroutine for plotting # sat pixels in Align/
;-      It's like I was conciously trying to make this as vague as possible...
;-      like maybe if a task is not well-defined, I'll feel better about myself
;-      for consistently putting it off.
;-   [] "align_loop" procedure is duplicate of subroutine in "align_in_pieces";
;-      see top of "align_in_pieces.pro" for similar comments.
;-      And maybe consolidate... (23 July 2019)
;-   [] Move ML code to its own file?
;+


pro ALIGN_LOOP, cube, ref, allshifts=allshifts, display=display, buffer=buffer

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
        if keyword_set(display) then $
            plt = PLOT_SHIFTS( shifts, buffer=buffer )
        ;stop
          ;- may as well let code continue to run. If plots don't look right,
          ;-   can always stop code via ctrl+c at any time.

        allshifts = [ [[allshifts]], [[shifts]] ]
        sdv = [ sdv, stddev( shifts[0,*] ) ]
        k = n_elements(sdv)

;        print, "stddev(X) = ", sdv[k-1], format='(F0.8)'
        ;- "Type conversion error: Unable to convert given STRING to Double"...
        ;-   Is this a problem?
        ;-
        ;- 13 January 2021 -- Error caused by print having TWO arguments... Quick fix:
;        print, "stddev(X) = "
;        print, sdv[k-1], format='(F0.8)'
        ;----
        ;- OR, could get fancy :
        ;-
        ;- Example from IDL reference pages:
;        stars = 3
;        print, FORMAT='("Detected ", I2, " stars")', stars
        ;- My attempt to reproduce this syntax with my own values:
        print, FORMAT='("stddev(X) = ", F0.8 )', sdv[k-1]
        ;-
        ;----


        if k eq 10 then break
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )
    print, "End:  ", systime()
    print, format='(F0.2, " minutes")', (systime(/seconds)-start_time)/60.
end



;== OLD
;;flare_index = 0 ; M1.5  2013-08-12
;flare_index = 1 ; C8.3  2013-08-30
;;;;flare_index = 2 ; C4.6  2014-10-23
;;flare_index = 3 ; M1.0  2014-11-07
;@par2
;flare = multiflare.(flare_index)
;date = flare.year + flare.month + flare.day
;  main.pro does this


;== NEW (general variables defined in one script):
@main


;channel = '1600'
channel = '1700'


;path = '/solarstorm/laurel07/flares/' + date + '/'
flare_path = '/solarstorm/laurel07/flares/' + class + '/'
filename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
newfilename = date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'

restore, flare_path + filename
oldcube = cube
restore, flare_path + newfilename


;-  COMPARE after alignment runs..

;sz = size(cube, /dimensions)
;ref = cube[*,*,sz[2]/2]
;help, ref
;ALIGN_LOOP, cube, ref, allshifts=allshifts, display=display, buffer=buffer


locs = where( cube ne oldcube )
help, locs

plot, allshifts[0,*,0]
oplot, allshifts[1,*,0]

;+
;- AFTER confirming successful alignment:
;-
SAVE, cube, index, ref, allshifts, filename=newfilename



stop

;;im = image2( sqrt(oldcube[*,*,0]), buffer=buffer )
;im = image2( oldcube[*,*,200], max_value=1000, buffer=buffer )
;save2, 'test1'
;dw
;;im = image2( sqrt(cube[*,*,0]), buffer=buffer )
;im = image2( cube[*,*,200], max_value=1000, buffer=buffer )
;save2, 'test2'
;dw






stop;=====================================================================================


;-
;--- § Read index and data from PREPPED fits files

resolve_routine, 'read_my_fits', /either
READ_MY_FITS, index, data, fls, $
    instr=instr, $
    channel=channel, $
    ;ind=[0], $
    nodata=0, $
    prepped=1

help, data
help, index[0].wave_str
help, index[0].lvl_num
print, index[0].date_obs
print, index[-1].date_obs



;-
;--- § Extract subset centered on AR from full disk images by cropping x and y pixels

resolve_routine, 'crop_data', /either
cube = CROP_DATA( $
    data, $
    center=center, $ ;- defined in @parameters
    dimensions=[700,500] )
    ;- NOTE: kw "dimensions"=[500,330] (default set in crop_data.pro)
    ;- NOTE ALSO: @parameters defines "align_dimensions=[1000,800]" ...
    ;-   doesn't need to be hardcoded here.
help, cube



;-
;--- § Set reference image to center of time series, and display

sz = size(cube, /dimensions)
print, sz
print, sz[2]/2  ;- make sure this is center of ts
print, strmid(index[sz[2]/2].date_obs,11,11)
ref = cube[*,*,sz[2]/2]
help, ref


if instr eq 'aia' then begin
    imdata = AIA_INTSCALE( $
        ref, wave=fix(channel), exptime=index[0].exptime )
    ct = AIA_GCT(wave=fix(channel))
endif else $
if instr eq 'hmi' then begin
    imdata = ref
    ct = 0
endif else print, "variable instr must be 'hmi' or 'aia'."
im = IMAGE2( imdata, rgb_table=ct, buffer=buffer )
save2, 'test_cropped_image'

undefine, data

stop

;-
;--- § Align data

;-
;- Run ALIGN_CUBE3 on a loop until stddev stops decreasing
ALIGN_LOOP, cube, ref, $
    shifts, $
    ;/display, $
    buffer=buffer

;----------------


;-
;- Check values by showing movie in xstpper, plotting shifts, and/or
;-   printing max values (should be ≤ 1 after first loop).
help, shifts
print, max( shifts[*,*,0] )
;print, max( shifts[*,*,7] )
;-  Hardcoded indices? shifts variable builds on itself with each iteration, so
;-    attempting to access index '7' is pretty much guaranteed to thrrow errors.
;-   Procedure would be finished looping by now, as this code is below the call
;-   to align_loop and shifts variable just might have index 7 in the 3rd position.
;-    But not necessarily.. sometimes maximum alignent is achieved after only
;-    2 or 3 runs... STOP HARDCODING!!
;- (05 May 2020)


xstepper2, $
    CROP_DATA( cube, center=[475,250], dimensions=[200,200] ), $
    channel=channel, subscripts=[300:500], scale=2.00
    ;- NOTE: xstepper is extremely slow when ssh-ed ...
;save2, 'align_shifts'


;-
;--- § Save cube and shifts to .sav files.

;path = '/solarstorm/laurel07/' + year + month + day + '/'
   ; already defined path in this file... must have merged codes, or just forgot.
   ; FWI renamed path as flare_path since path is variable name of primary path to my ss dir.
shifts_filename = flare_path + instr + channel + 'shifts.sav'
print, shifts_filename
;-
save, shifts, filename=shifts_filename



;-
;- 30 July 2019
;-
;- 1700Å images appear to align successfully w/o interpolating
;-   shifts prior to using them for alignemnt (30 July 2019)
;save, shifts, filename=shifts_filename

;- 1600Å : aligned using interpolated shifts (new_shifts),
;-  Replaced cube in .sav file (see interp_shifts.pro for details).
;- 
;save, new_shifts, filename = path + instr + channel + 'new_shifts.sav'

;cube_filename = path + instr + channel + 'aligned.sav'
cube_filename = flare_path + instr + channel + 'aligned.sav'
print, cube_filename
;-
save, cube, filename=cube_filename

;restore, '../20131228/aia1600shifts.sav'
;help,  aia1600shifts
;for ii = 0, 5 do print, stddev( aia1600shifts[0,*,ii] )

end
