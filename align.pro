; Last modified:   04 June 2018
;
; ROUTINE:    align.pro
;
; PURPOSE:    For data cubes that need more attention than
;              running align_cube3.pro a few times...

;
; Alignment steps (in general):       
;   1. read data
;   2. image center and locate center coords (x0, y0)
;   3. crop data to size 750x500 relative to center
;   4. Align
;   5. save to '*aligned.sav' file
;-



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



pro PLOT_SHIFTS, shifts, _EXTRA=e
    ; Color axes on each side, and shift/scale differently?

    sz = size( shifts, /dimensions)
    cols = 1
    rows = sz[2]
    xdata = indgen(sz[1])
    names = ['horizontal shifts', 'vertical shifts' ]
    @colors
    p = objarr(2)
    w = window( dimensions=[1600, 500] )
    for j = 0, sz[2]-1 do begin
        graphic = plot2( $
            xdata, shifts[0,*,j], /nodata, /current, $
            layout=[cols,rows,j], $
            xtitle='image #', $
            ytitle='shifts', $
            _EXTRA=e $
            )
        for i = 0, sz[0]-1 do begin
            p[i] = plot2( $
                xdata, shifts[i,*,j], $
                /overplot, $
                symbol='circle', $
                sym_filled=1, $
                sym_size=0.5, $
                color=colors[i], $
                name=names[i] $
                )
        endfor
    endfor
    leg=legend( target=[p] )
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


pro ALIGN_DATA, cube, ref, allshifts
    ; aligns data to reference image on a loop,
    ; using standard deviation of shifts as a breaking point
    ; (when it no longer decreases).

    ; save shifts calculated for every iteration.
    sz = size(cube, /dimensions)
    allshifts = fltarr( 2, sz[2] )

    sdv = []
    print, "Start:  ", systime()
    start_time = systime(/seconds)
    repeat begin
        ALIGN_CUBE3, cube, ref, shifts=shifts
        allshifts = [ [[allshifts]], [[shifts]] ]
        sdv = [ sdv, stddev( shifts[0,*] ) ]
        k = n_elements(sdv)
        print, sdv[k-1]
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )
    print, "End:  ", systime()
    print, format='(F0.2, " minutes")', (systime(/seconds)-start_time)/60.
end

pro ALIGN_IN_PIECES, cube, shifts=shifts, temp=temp
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

goto, start
start:;------------------------------------------------------------------------------

aia_lct, wave=1600, /load
read_my_fits, 'aia', '1600', index, data, /prepped
sz = size( data, /dimensions )

x0 = 2410
y0 = 1660
xl = 750
yl = 500

; make sure center coords are correct
im = image2( crop_data(data[*,*,sz[2]/2], center=[x0,y0]))
stop

data = crop_data( data, center=[x0,y0], dimensions=[xl,yl] )
sz = size( data, /dimensions )
aligned_cube = fltarr(sz)
;ref = data[*,*,sz[2]/2]  ;; don't think this is needed.
xstepper, data, xsize=500, ysize=330
stop


; Indices where cube is to be split in separate alignments
z = [ $
    [ 0, 260 ], $
    [ 261, 349], $
    [ 350, 450 ], $
    [ 451, 499 ], $
    [ 500, 669 ], $
    [ 670, 695 ], $
    [ 696, sz[2]-1 ] $
    ]

ind = [ 6 ]
ind = indgen(7)
foreach i, ind do begin

    cube = data[ *, *, z[0,i]:z[1,i] ]
    ;cube = aligned_cube[ *, *, z[0,i]:z[1,i] ]
    ;xstepper, crop_data(cube), xsize=500, ysize=330

    print, i
    if (i mod 2) then begin
        ; Portions of cube to use for determining shifts.
        ; Non-flaring parts of AR; determined by eye (hardcoded).
        if i eq 1 then temp = cube[ 475: * ,*,* ]
        if i eq 3 then temp = cube[ 225:400,*,* ]
        if i eq 5 then temp = cube[ 275: * ,*,* ]

        print, 'temp: ', size(temp, /dimensions)
        ALIGN_IN_PIECES, cube, shifts=shifts, temp=temp
    endif else begin
        print, 'cube: ', size(cube, /dimensions)
        ALIGN_IN_PIECES, cube, shifts=shifts
    endelse
    ;xstepper, crop_data(cube), xsize=500, ysize=330

    aligned_cube[*,*,z[0,i]:z[1,i]] = cube

    ;plot_shifts, shifts
endforeach

xstepper, aligned_cube, string(indgen(745)), xsize=500, ysize=330
stop

;; Align each section

ref = aligned_cube[*,*,451]
im = image2( ref )
aligned_cube_2 = aligned_cube


ind = [0,1,2,4,5,6]
foreach i, ind do begin

    cube = aligned_cube[*,*,z[0,i]:z[1,i]]
    sdv = []
    repeat begin

        offset = ALIGNOFFSET(cube[*,*,0], ref)
        shifts = -offset
        sdv = [ sdv, shifts[0] ]
        for j = 0, (size(cube, /dimensions))[2]-1 do $
            cube[*,*,j] = SHIFT_SUB( cube[*,*,j], shifts[0], shifts[1] )

        k = n_elements(sdv)
        print, sdv[k-1]

    ; since only using one value for shifts, doesn't make sense to calculate
    ; standard deviation, so letting this run until the x shift is higher than
    ; the previous iteration.
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )

    aligned_cube_2[*,*,z[0,i]:z[1,i]] = cube
endforeach

xstepper, aligned_cube_2, xsize=500, ysize=330
stop

cube = aligned_cube_2

;save, cube, filename='aia1600aligned.sav'
;save, cube, filename='aia1700aligned.sav'

end
