;; Last modified:   24 May 2018 14:25:16



; ROUTINE:    align_cube3
;
; PURPOSE:    align a series of images in a data cube to
;             the first image
;
; USEAGE:     align_cube3, cube
;
; INPUT:      cube = array of images (x,y,t)
;
; OUTPUT:     cube = data aligned to the first image

; Example:
;
; AUTHOR:     Peter T. Gallagher, July 2001
;             Altered by James McAteer March 2002 with ref optional
;                input
;             Altered by Shaun Bloomfield April 2009 with optional
;                output of calculated shifts
;
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



PRO ALIGN_CUBE4, quiet, cube, ref, shifts=shifts

    ; align using shifts determined by different region
    ; (probably not the best way to do this...)
    sz = size(cube, /dimensions)
    shifts = fltarr( 2, sz[2] )
    FOR i = 0, sz[2]-1 DO BEGIN
        ; determine shift values
        offset = ALIGNOFFSET( quiet[*, *, i], ref )
        quiet[*,*,i] = SHIFT_SUB( quiet[*, *, i], -offset[0], -offset[1] )
        cube[*,*,i] = SHIFT_SUB( cube[*, *, i], -offset[0], -offset[1] )
        shifts[*,i] = -offset
    ENDFOR
END


pro CALCULATE_SHIFTS, cube, ref, shifts

    ; Calculate shifts WITHOUT actually shifting data cube,
    ; which is the part that takes a long time to run.
    ; input: cube, ref
    ; output: shifts

    sz = size(cube, /dimensions)
    shifts = fltarr( 2, sz[2] )

    xs = findgen(sz[2])
    xs = ((xs/max(xs)) * 70 ) - 35
    xs = reverse(xs)
     
    for i = 0, sz[2]-1 do begin
        offset = ALIGNOFFSET( cube[*,*,i], ref )
;        if (abs(offset[0,0]) - abs(xs[i]) gt 10) then offset = [0.0,0.0]
        shifts[*,i] = -offset
    endfor
end


pro APPLY_SHIFTS, cube, shifts

    ; Apply (corrected) shifts (2xN) to cube
    ; input: shifts
    ; output: cube

    sz = size(cube, /dimensions)
    for i = 0, sz[2]-1 do begin
        ;cube[*,*,i] = SHIFT_SUB( cube[*,*,i], shifts[0,i], shifts[1,i] )
        cube[*,*,i] = SHIFT_SUB( cube[*,*,i], shifts[0], shifts[1] )
    endfor
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


pro ALIGN_IN_PIECES, cube, shifts=shifts, temp=temp

    ; returns 3D shifts array and aligned cube

        ;xstepper, cube<3933
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

;channel = '1600'
channel = '1700'
; Read raw data from fits files and
; crop for alignment (pad with 100x66 pixels on all sides)
;READ_MY_FITS, index, data, /hmi
READ_MY_FITS, index, data, channel=channel, /aia
data = crop_data( data, dimensions=[700,462], center=[2420,1665] )
sz = size(data, /dimensions)
im = image2( data[*,*,sz[2]/2] )
stop

start:;--------------------------------------------------------------------

timestr = index.date_obs + 'Z'
jd = get_jd(timestr)

stop


; Indices where cube is to be split in separate alignments
z = [ $
    [ 0, 260 ], $
    [ 261, 349], $
    [ 350, 450 ], $
    [ 451, 499 ], $
    [ 500, 669 ], $
    [ 670, 695 ], $
    [ 696, 748 ] $
    ]


aligned_cube = fltarr(sz)


for i = 2, (size(z, /dimensions))[1]-1 do begin

    ;cube = data[ 0:10, 0:10, z[0,i]:z[1,i] ]
    cube = data[ *, *, z[0,i]:z[1,i] ]

    ;if ( i eq 1 OR i eq 3 OR i eq 5 ) then begin
    if ( i mod 2) then begin
        ; Portions of cube to use for determining shifts.
        ; Non-flaring parts of AR; determined by eye (hardcoded).
        if i eq 1 then temp = cube[ 475: * ,*,* ]
        if i eq 3 then temp = cube[ 225:400,*,* ]
        if i eq 5 then temp = cube[ 275: * ,*,* ]

        print, i, size(temp, /dimensions)
        ALIGN_IN_PIECES, cube, shifts=shifts, temp=temp
    endif else begin
        print, i, sz
        ALIGN_IN_PIECES, cube, shifts=shifts
    endelse

    aligned_cube[*,*,z[0,i]:z[1,i]] = cube

    ;plot_shifts, shifts
endfor
stop



;; Align each section

ind = [0,2,3,4,5,6]
ref = aligned_cube[*,*,393]

temp_ref = ref[475:*,*]
sztemp = size(temp_ref, /dimensions)
;temp = fltarr( sztemp[0], sztemp[1], 7 )
;temp[*,*,1] = temp_ref

temp = []

foreach i, ind do begin

    temp = aligned_cube[475:*,*,z[0,i]]
    temp = reform(temp, 225,462,1)
    ;temp[*,*,i] = aligned_cube[475:*,*,z[0,i]]

    cube2 = aligned_cube[*,*,z[0,i]:z[1,i]]

    for j = 0, 9 do begin

        align_cube3, temp, temp_ref, shifts=shifts
        apply_shifts, cube2, shifts

    endfor
    aligned_cube[*,*,z[0,i]:z[1,i]] = cube2
endforeach






cube = data[ *, *, 0:sz[2]/2 ]
ref  = data[ *, *,   sz[2]/4 ]
temp = cube[ 475:*, *, * ]
temp_ref = ref[ 475:*, * ]

stop

ALIGN_CUBE3, temp, temp_ref, shifts=shifts
APPLY_SHIFTS, cube, shifts


; scale aligned cube for nicer viewing.
maxvalues = []
minvalues = []
for j = 0, 375-1 do begin
    maxvalues = [maxvalues, max(cube[*,*,j])] 
    minvalues = [minvalues, min(cube[*,*,j])]
endfor
xstepper, cube<min(maxvalues)>max(minvalues)



;save, cube, filename='aia1600aligned.sav'
;save, cube, filename='aia1700aligned.sav'

end
