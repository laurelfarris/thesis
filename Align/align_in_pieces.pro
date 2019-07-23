;-
;- 23 July 2019
;- --> "align_data" procedure below is exact duplicate of the subroutine by the
;-        same name in "align_data.pro", a routine that loops through align_cube3
;-        without dealing with saturation problems. BOTH situations require running
;-        align_data, so it should probably go in its own file...
;-   See top of "align_data.pro" for similar comments.
;-
;-
; Last modified:   04 June 2018
;
; ROUTINE:    align.pro
;
; PURPOSE:    For data cubes that need more attention than
;              running align_cube3.pro a few times...
;
; SUBROUTINES:  alignoffset.pro
;               shift_sub.pro
;
; Alignment steps (in general):
;   1. read data
;   2. image center and locate center coords (x0, y0)
;   3. crop data to size 750x500 relative to center
;   4. Align
;   5. save to '*aligned.sav' file
;-



function PLOT_SHIFTS, shifts, xdata=xdata, _EXTRA=e
    ; Color axes on each side, and shift/scale differently?

    common defaults
    sz = size( shifts, /dimensions)
    cols = 1
    if n_elements(sz) eq 3 then rows = sz[2] else rows = 1
    if n_elements(xdata) eq 0 then xdata = indgen(sz[1])
    names = ['horizontal shifts', 'vertical shifts' ]
    @colors
    p = objarr(2)

    margin=[1.0, 0.5, 2.0, 0.5]*dpi
    wx = 11.0
    wy = 5.0
    w = window( dimensions=[wx,wy]*dpi, location=[500,0] )
    xticklen = 0.02
    yticklen = xticklen * (wy-margin[1]-margin[3])/(wx-margin[0]-margin[2])

    for i = 0, sz[0]-1 do begin
        p[i] = plot2( $
            xdata, shifts[i,*], $
            /current, $
            overplot=i<1, $
            /device, $
            layout=[cols,rows,i+1], $
            margin=margin, $
            xticklen=xticklen, $
            yticklen=yticklen, $
            xtitle='image #', $
            ytitle='shifts', $
            symbol='circle', $
            sym_filled=1, $
            sym_size=0.5, $
            color=colors[i], $
            name=names[i], $
            _EXTRA=e $
            )
    endfor
    leg=legend2( $
        target=[p], $
        /device, $
        position=([wx,wy-0.5])*dpi, $
        auto_text_color=1 $
        )
    return, p
end


function INTERP_SHIFTS, shifts, cad

    ; 22 May 2018
    ; Main level:
    path = '/solarstorm/laurel07/Data/AIA_prepped/'
    fls = file_search( path + '*1600*.fits' )
    read_sdo, fls, index, data
    ; crop data to cube slightly bigger than ROI for alignment.
    x1 = 2160
    x2 = x1 + 500 - 1
    y1 = 1500
    y2 = y1 + 330 - 1
    dx = 100 ; = 500 * 0.2
    dy = 66  ; = 330 * 0.2
    temp = data[ x1-dx : x2+dx, y1-dy : y2+dy, * ]
    sz = size(temp, /dimensions)
    ref = temp[*,*,sz[2]/2]
    CALCULATE_SHIFTS, temp, ref, shifts
    cad = [ $
        [0:82], $
        [104:106], $
        [110:264], $
        [330:460], $
        [464:470], $
        [479:640], $
        [644:670], $
        [702:715], $
        [718:747], $
        748 ]

    ; interp_shifts function:
    sz = size( shifts, /dimensions)
    cadence_inter = indgen(sz[1])
    new_shifts = fltarr(sz)

    for i = 0, sz[0]-1 do begin
        data = shifts[i,cad]
        data_inter = interpol( data, cad, cadence_inter );, /spline )
        new_shifts[i,*] = data_inter
    endfor
    return, new_shifts
end


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


pro CALCULATE_SHIFTS, cube, ref, shifts
    ; Calculate shifts WITHOUT actually shifting data cube
    ; input: cube, ref
    ; output: shifts

    sz = size(cube, /dimensions)
    shifts = fltarr( 2, sz[2] )

    for i = 0, sz[2]-1 do begin
        offset = ALIGNOFFSET( cube[*,*,i], ref )
        shifts[*,i] = -offset
    endfor
end


pro APPLY_SHIFTS, cube, shifts
    ; Apply shifts (2xN) to cube
    ; input: shifts
    ; output: cube

    sz = size(cube, /dimensions)
    for i = 0, sz[2]-1 do $
        cube[*,*,i] = SHIFT_SUB( cube[*,*,i], shifts[0,i], shifts[1,i] )
end


pro ALIGN_IN_PIECES_1, cube, shifts=shifts, temp=temp
    ; If set, uses temp to determine shifts, then applies them to temp and cube.
    ; If not, just uses cube itself.
    ; Sets ref as center image in both cases.
    ; returns 3D array of shifts and aligned cube

        sz = size(cube, /dimensions)

        if keyword_set(temp) then begin
            ref = temp[*,*,sz[2]/2]
            ALIGN_DATA, temp, ref, shifts
            for ii = 0, (size(shifts, /dimensions))[2]-1 do $
                APPLY_SHIFTS, cube, shifts[*,*,ii]
        endif else begin
            ref = cube[*,*,sz[2]/2]
            ALIGN_DATA, cube, ref, shifts
        endelse
end

pro ALIGN_IN_PIECES_2, cube, shifts, temp=temp

    sz = size(cube, /dimensions)

    if n_elements(temp) ne 0 then begin
        ref = temp[*,*,sz[2]/2]
        ALIGN_CUBE3, temp, ref, shifts
        for i = 0, (size(shifts, /dimensions))[2]-1 do $
            APPLY_SHIFTS, cube, shifts[*,*,i]
    endif else begin
        ref = cube[*,*,sz[2]/2]
        ALIGN_CUBE3, cube, ref, shifts
    endelse

    PLOT_SHIFTS, shifts, _EXTRA=e
    question = 'Repeat alignment?'
    read, repeatalign, question
end


pro ALIGN_IN_PIECES, cube, cube2, shifts=shifts

    sz = size(cube, /dimensions)
    ref = cube[*,*,sz[2]/2]

    ;repeat begin
        ALIGN_CUBE3, cube, ref, shifts=shifts

        if n_elements(cube2) ne 0 then begin

            ; TEST:
            if sz[2] ne (size(shifts, /dimensions))[1] then begin
                print, '3rd dimension of input cubes do not match.'
                return

            endif else for i = 0, sz[2]-1 do $
                cube2[*,*,i] = SHIFT_SUB( cube2[*,*,i], shifts[0,i], shifts[1,i] )
        endif

        ; Don't redo alignment just because PLOT_SHIFTS had an error!!!
        ; Kind of needs to be in the same routine, so need to find a command
        ; that will let me restart right here, or skip plotting and continue
        ; with another iteration, as long as it re-compiles plot_shifts and
        ; runs the correct version on the next iteration
        ; (which supposedly IDL will do... but it doesn't seem to behave this way).
        ;
        ; Should just return shifts and aligned data after EACH iteration
        ; (like what align_cube3 does already...)
end

goto, start

channel = '1600'
channel = '1700'

restore, 'aia' + channel + 'data.sav'
sz = size( data, /dimensions )
aligned_cube = fltarr(sz)
stop

xstepper2, data, channel=channel
stop
;; Step 1: Align subsets separately


z = [ 0, 255, 350, 446, 500, 665, 710, sz[2] ]

; No flares
;foreach i, [0,2,4,6] do begin

; Pain in my ass:
; Portions of cube to use for determining shifts.
; Non-flaring parts of AR; determined by eye (hardcoded).
; At least these subsets are smaller, so routine runs faster.
foreach i, [1,3,5] do begin

;foreach i, [3] do begin
; NOTE: Had to re-do i=3 because pressed 'y' instead of enter.
; But I think I wrote this in a way that it won't be a problem :)

;foreach i, [6] do begin
; NOTE: Had to redo i=6 because last image wasn't included.

    dw
    allshifts = []
    repeatalign = ''
    cube = data[ *, *, z[i]: z[i+1]-1 ]

    if (i eq 1) then temp = cube[ 500: * ,*,* ]
    if (i eq 3) then temp = cube[ 250:425,*,* ]
    if (i eq 5) then temp = cube[ 300: * ,*,* ]

    print, 'i = ', strtrim(i,1)
    j = 1
    repeat begin
        print, 'aligning ', strtrim( (size(cube,/dimensions))[2], 1 ), ' images.'
        ;ALIGN_IN_PIECES, cube, shifts=shifts
        ALIGN_IN_PIECES, temp, cube, shifts=shifts
        allshifts = [ $
            [ allshifts ], $
            [ max(abs(shifts[0,*])), max(abs(shifts[1,*])) ] ]
        print, allshifts;, format='(F12.8)'

        p = PLOT_SHIFTS( $
            shifts, $
            xdata=[z[i]:z[i+1]-1], $
            title='AIA ' + channel + '$\AA$ alignment run # ' + $
                strtrim(j,1) )
        j = j + 1
        stop

        prompt = 'Press enter to repeat alignment: '
        read, repeatalign, prompt=prompt
    endrep until repeatalign ne '' AND repeatalign ne 'y'
    aligned_cube[ *, *, z[i]: z[i+1]-1 ] = cube
endforeach
xstepper, aligned_cube, xsize=500, ysize=500*(float(sz[1])/sz[0])
stop

save, aligned_cube, filename='aia' + channel + 'aligned.sav'
stop

;; ------------------------------------------------------------------------
;; Step 2: Align subsets with each other (to 3, middle of 7 total)
;;   Much faster than step 1.
;; This could probably just
;; loop until absolute value of x OR y shift is less than 0.001

channel = '1600'
;channel = '1700'
restore, 'aia' + channel + 'aligned.sav'

aia_lct, wave=fix(channel), /load
xstepper, aligned_cube, xsize=750/2, ysize=500/2
stop

sz = size( aligned_cube, /dimensions )
aligned_cube_2 = aligned_cube
ref = aligned_cube[*,*,446]

ind = [0,1,2,4,5,6]
foreach i, ind do begin

    print, i
    cube = aligned_cube[ *,*,z[i]:z[i+1]-1 ]
    allshifts = []
    repeatalign = ''

    repeat begin

        ; Determine shifts (offset) between first image in each subset
        ; and the reference image (in the middle subset).
        offset = ALIGNOFFSET(cube[*,*,0], ref)
        shifts = -offset

        ; Apply shifts to every image in subset i
        for j = 0, (size(cube, /dimensions))[2]-1 do $
            cube[*,*,j] = SHIFT_SUB( cube[*,*,j], shifts[0], shifts[1] )

        allshifts = [ [allshifts], [shifts] ]
        print, allshifts

        prompt = 'Press enter to repeat alignment: '
        read, repeatalign, prompt=prompt

    endrep until repeatalign ne '' AND repeatalign ne 'y'

    aligned_cube_2[*,*,z[i]: z[i+1]-1 ] = cube
endforeach
stop


;; xstepper on cube around discontinuities
for i = 1, 6 do begin
    dat = aligned_cube_2[ *,*, z[i]-5: z[i]+5-1 ]
    xstepper, dat>106<3845, xsize=750, ysize=500
endfor
stop

; Save data with same dimensions as used to align,
;    then crop to 500x330 for each session.
; Center coords aren't always consistent, and
;    don't want to lose all this work!

cube = aligned_cube_2
save, cube, filename='aia' + channel + 'aligned.sav'
stop


; Test that cube is the variable name and that it was saved.
;cube = !NULL
channel = ['1600','1700']
for i = 0, 0 do begin
    aia_lct, wave=fix(channel[i]), /load
    restore, 'aia' + channel[i] + 'aligned.sav'
    im = image2(cube[*,*,-1])
endfor

start:;------------------------------------------------------------------------------
xstepper, cube[*,*,700:*], xsize=500, ysize=330
stop

xstepper, aligned_cube, xsize=500, ysize=330
stop



;; Hacky way to get last image in 1600 data cube so I can finally
;; move on!!!!!!!!!



channel = '1600'

; data (last image only)
restore, 'aia' + channel + 'data.sav'
data = data[*,*,-1]

; cube
;restore, 'aia' + channel + 'aligned.sav'

; same index used for ref in step 2, but of course want to use aligned
;     cube, and align the last data image to that.
ref = cube[*,*,446]


offset = ALIGNOFFSET(data, ref)
shifts = -offset

; Apply shifts to data

data = SHIFT_SUB( data, shifts[0], shifts[1] )
print, shifts

stop


cube[*,*,-1] = data
save, cube, filename='aia' + channel + 'aligned.sav'

end
