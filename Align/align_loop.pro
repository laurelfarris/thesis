;+
;- LAST MODIFIED:
;-   04 June 2018
;-    ... riveting.
;-
;-  05 May 2020
;-    • Quest : re-align data cube with images from the 2013-12-28 C3.0 flare,
;-      (5 hours of observations, processed to level 1.5 with aia_prep).
;-    •
;-    
;-
;- ROUTINE:
;-   align_loop.pro
;-      /is_procedure
;-
;- Calling sequence:
;-   ALIGN_LOOP, cube, ref, allshifts, display=display, buffer=buffer
;-
;- INPUT:
;-   CUBE = 3D data cube of images to align
;-   REF = 2D image to serve as 'reference' to which
;-     all other images will bow (align wrt...)
;-       Center one seems reasonable, minimizes the already long temporal
;-      gap between ref and the images on the start/end times, at zindex of
;-     [0] and [-1]. As the sun is quite dynamic (esp. during flares),
;-      observable features can change quite a bit over the course of a
;-   single observation run; the more an image differs from the REF, the harder
;-    it will be to align the two since the external functions that carry out
;-   these computations do so by locating distinguishing features that are
;-   recognizable on both images. They don't have  to be mirror images, but
;-   if something crazy happens like I dunno saturation and bleeding that gives
;-  the unmistakable impression of a heavenly orb hell-bent on stabbing the shit
;-   out of those who download the images and then wine about them constantly.
;-
;-
;- OUTPUT:
;-   ALLSHIFTS = variable defined locally by the procedure, passed back
;-    to named variable present as argument to align_loop
;-    though is not required if user has no need of it.
;-    Shifts can be useful for
;-
;-
;- PURPOSE:
;-   Run align_cube3 on a loop until standard deviation
;-   of shifts don't change by a significant amount.
;-   aligns data to reference image on a loop,
;-   using standard deviation of shifts as a breaking point
;-   (when it no longer decreases).
;-
;-     A description of what this routine does to obtain the eventual result(s)
;-     is not the same as the overall PURPOSE of the routine. Why are we
;-     aligning at all? Why was a new routine needed when standard procedure
;-    was already making use of THREE sepearate subroutines just to get back
;-    a cube that has weird edges?
;-     HINT: science
;-
;- EXTERNAL SUBROUTINES:
;-     alignoffset.pro
;-     shift_sub.pro
;-     align_cube3.pro
;-  NOTE: the author of the present routine, align_loop.pro is NOT the
;-    author of the external subroutines it utilizes. Please don't sue me.
;-
;-
;- Alignment steps (in general):
;-   1. read data
;-   2. image center and locate center coords (x0, y0)
;-   3. crop data to size 750x500 relative to center (for final dims=[500,330])
;-   4. Align
;-   5. save to '*aligned.sav' file
;- "In general" meaning, probably doesn't actually work? More a conceptual
;-   outline of what happens than what really happens? I'm so tired.
;- Note that running struc_aia is NOT required here (I just ran it out of habit).
;-
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
;-   "align_loop" procedure is duplicate of subroutine in "align_in_pieces";
;-   see top of "align_in_pieces.pro" for similar comments.
;-  (23 July 2019)
;-
;- TO DO:
;-   [] Find a way to define "instr" and "channel" without manually setting
;-       them all the time. Def. lines are (or were) in @parameters,
;-       but are commented..
;-       After attempt to run code, occurs to me that
;-       actually these aren't handled exactly the same,
;-       as a single "instr" is affiliated with multiple channels, and while
;-       instr can be safely defined as "aia" (assuming no other instrument is
;-       involved here, and also I'm hardcoding again... surely these values are
;-       in the original headers fer feck's sake, I just either never thought
;-       to pull them rather than defining on my own, or I was unable to ID the
;-       tagnames possessing the information I was looking for.
;-       After a 2nd attempt of .RUN align_loop, occurred to me that align
;-         routines operate one data set at a time .. so channel IS defined
;-         alongside instr..
;-              meh
;-   [] Copy plotting routine to separate subroutine called, e.g. "plot_shifts.pro"
;-      That way it can easily be called in the alignment loop AND after procedure is finished.
;-    05 May 2020 -- this box appears to have been checked off at some point...
;-        Go me!
;-   [] Do st with subroutine for plotting # sat pixels in Align/
;-        It's like I was conciously trying to make this as vague as possible...
;-        like maybe if a task is not well-defined, I'll feel better about myself
;-        for consistently putting it off.
;-
;+


pro ALIGN_LOOP, cube, ref, allshifts, display=display, buffer=buffer

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

        print, "stddev(X) = ", sdv[k-1], format='(F0.8)'
        ;- "Type conversion error: Unable to convert given STRING to Double"...
        ;-   Is this a problem?

        if k eq 10 then break
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )
    print, "End:  ", systime()
    print, format='(F0.2, " minutes")', (systime(/seconds)-start_time)/60.
end

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

buffer=1

@parameters

instr = 'aia'
channel = '1600'
;channel = '1700'


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

if buffer ne 0 then begin
    xstepper2, $
        CROP_DATA( cube, center=[475,250], dimensions=[200,200] ), $
        channel=channel, subscripts=[300:500], scale=2.00
        ;- Does this work while ssh-ed?? --> yes, but very slow.
endif
;save2, 'align_shifts'


;-
;--- § Save cube and shifts to .sav files.

path = '/solarstorm/laurel07/' + year + month + day + '/'
print, path
shifts_filename = path + instr + channel + 'shifts.sav'
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

cube_filename = path + instr + channel + 'aligned.sav'
print, cube_filename

;-
save, cube, filename=cube_filename

;restore, '../20131228/aia1600shifts.sav'
;help,  aia1600shifts
;for ii = 0, 5 do print, stddev( aia1600shifts[0,*,ii] )

end
