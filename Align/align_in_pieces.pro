;-
;- LAST MODIFIED:
;-   23 July 2019
;-
;- ROUTINE:
;-   align_in_pieces.pro
;-
;- PURPOSE:
;-   Align data cubes that need special attention due to saturation, or any
;-   other issues that don't allow a simple loop to get the job done.
;-
;- SUBROUTINES:
;-   alignoffset.pro, shift_sub.pro
;-     (from align_cube3.pro... not written by me)
;-   calculate_shifts.pro
;-   apply_shifts.pro
;-   align_loop.pro
;-
;+



pro ALIGN_IN_PIECES_1, cube, shifts=shifts, temp=temp
    ; If set, uses temp to determine shifts, then applies them to temp and cube.
    ; If not, just uses cube itself.
    ; Sets ref as center image in both cases.
    ; returns 3D array of shifts and aligned cube

        sz = size(cube, /dimensions)

        if keyword_set(temp) then begin
            ref = temp[*,*,sz[2]/2]
            ALIGN_LOOP, temp, ref, shifts
            for ii = 0, (size(shifts, /dimensions))[2]-1 do $
                APPLY_SHIFTS, cube, shifts[*,*,ii]
        endif else begin
            ref = cube[*,*,sz[2]/2]
            ALIGN_LOOP, cube, ref, shifts
        endelse
end

pro ALIGN_IN_PIECES_2, cube, shifts, temp=temp

    sz = size(cube, /dimensions)

    if n_elements(temp) ne 0 then begin
        ref = temp[*,*,sz[2]/2]
        ALIGN_CUBE3, temp, ref, shifts
        for i = 0, (size(shifts, /dimensions))[2]-1 do $
            APPLY_SHIFTS, cube, shifts[*,*,ii]
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
                cube2[*,*,ii] = $
                    SHIFT_SUB( cube2[*,*,ii], shifts[0,ii], shifts[1,ii] )
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


channel = '1600'
channel = '1700'

restore, 'aia' + channel + 'data.sav'
sz = size( data, /dimensions )
aligned_cube = fltarr(sz)

xstepper2, data, channel=channel


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
    cube = data[ *, *, z[ii]: z[ii+1]-1 ]

    if (ii eq 1) then temp = cube[ 500: * ,*,* ]
    if (ii eq 3) then temp = cube[ 250:425,*,* ]
    if (ii eq 5) then temp = cube[ 300: * ,*,* ]

    print, 'ii = ', strtrim(ii,1)
    jj = 1
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
            xdata=[z[ii]:z[ii+1]-1], $
            title='AIA ' + channel + '$\AA$ alignment run # ' + $
                strtrim(jj,1) )
        jj = jj + 1
        stop

        prompt = 'Press enter to repeat alignment: '
        read, repeatalign, prompt=prompt
    endrep until repeatalign ne '' AND repeatalign ne 'y'
    aligned_cube[ *, *, z[ii]: z[ii+1]-1 ] = cube
endforeach
xstepper, aligned_cube, xsize=500, ysize=500*(float(sz[1])/sz[0])

save, aligned_cube, filename='aia' + channel + 'aligned.sav'

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

sz = size( aligned_cube, /dimensions )
aligned_cube_2 = aligned_cube
ref = aligned_cube[*,*,446]

ind = [0,1,2,4,5,6]
foreach ii, ind do begin

    print, ii
    cube = aligned_cube[ *,*,z[ii]:z[ii+1]-1 ]
    allshifts = []
    repeatalign = ''

    repeat begin

        ; Determine shifts (offset) between first image in each subset
        ; and the reference image (in the middle subset).
        offset = ALIGNOFFSET(cube[*,*,0], ref)
        shifts = -offset

        ; Apply shifts to every image in subset i
        for j = 0, (size(cube, /dimensions))[2]-1 do $
            cube[*,*,j] = SHIFT_SUB( cube[*,*,jj], shifts[0], shifts[1] )

        allshifts = [ [allshifts], [shifts] ]
        print, allshifts

        prompt = 'Press enter to repeat alignment: '
        read, repeatalign, prompt=prompt

    endrep until repeatalign ne '' AND repeatalign ne 'y'

    aligned_cube_2[*,*,z[ii]: z[ii+1]-1 ] = cube
endforeach


;; xstepper on cube around discontinuities
for i = 1, 6 do begin
    dat = aligned_cube_2[ *,*, z[ii]-5: z[ii]+5-1 ]
    xstepper, dat>106<3845, xsize=750, ysize=500
endfor

; Save data with same dimensions as used to align,
;    then crop to 500x330 for each session.
; Center coords aren't always consistent, and
;    don't want to lose all this work!

cube = aligned_cube_2
save, cube, filename='aia' + channel + 'aligned.sav'


; Test that cube is the variable name and that it was saved.
;cube = !NULL
channel = ['1600','1700']
foreach cc, channel do begin
    aia_lct, wave=fix(cc), /load
    restore, 'aia' + cc + 'aligned.sav'
    im = image2(cube[*,*,-1])
endforeach

xstepper, cube[*,*,700:*], xsize=500, ysize=330

xstepper, aligned_cube, xsize=500, ysize=330



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


cube[*,*,-1] = data
save, cube, filename='aia' + channel + 'aligned.sav'

end
