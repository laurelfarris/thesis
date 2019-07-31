;-
;- LAST MODIFIED:
;-
;- ROUTINE(S):
;-   interp_shifts.pro
;-
;- PURPOSE:
;-
;- To do:
;-   [] Merge into one subroutine, with ML code as needed
;-
;+


;----------------------------------------------------------------------------------

;07 March 2018 (see Notes/2018-03-07.pro)

function INTERPOLATE_SHIFTS, shifts
    ;- Uses IDL's INTERPOL routine

    ; This is pretty close to 'inter' function in 2018-03-07.pro,
    ; except here I figured out how to calculate good shifts based on bad ones,
    ; rather than entering them manually.

    ;; number of shifts/images
    sz = size( shifts, /dimensions )
    N = fix(sz[1])

    ;; Initialize COMPLETE arrays (post-interpolation)
    cadence_inter = findgen(N)
    data_inter = fltarr( sz )

    ;; "Bad" indices of shifts that are definitely wrong (after first alignment)
    bad = []
    bad = [ bad, $
        [  7: 11], $
        [ 84:103], $
        [107:109], $
        [260:320], $
        [461:462], $
        [472:477], $
        [641:642], $
        [671:701], $
        [716:717] ]

    bad = []
    bad = [ bad, [5:13], [ 82:110], [660:710] ]
    ;bad = [ bad, [250:330], [460:500]];, [600:N-1] ]

    ;; "Good" indices.
    good = []
    for ii = 0, n_elements(cadence_inter)-1 do begin
        jj = where( bad eq ii )
        if jj eq -1 then good = [ good, ii ]
    endfor
    ;good = [ 0,[1:6],[12:83],[104:106],[110:259],[321:460],[463:471],[478:640],[643:670],[702:715],[718:N-1]]

    ;; Crop data to normal shifts ONLY
    cad = cadence_inter[good]
    data = shifts[ *, good ]


    data_inter[0,*] = interpol( data[0,*], cad, cadence_inter, /spline )
    data_inter[1,*] = interpol( data[1,*], cad, cadence_inter, /spline )

    return, data_inter

end



;----------------------------------------------------------------------------------

;30 July 2019
function INTERP_SHIFTS_MANUALLY, shifts, cad

    for ii = 0, 1 do begin
        d_shifts = $
            ( shifts[ii,cad[-1]+1] - shifts[ii,cad[0]-1] ) / (n_elements(cad)+1)
    endfor

end

;----------------------------------------------------------------------------------

;22 May 2018
function INTERP_SHIFTS, shifts, cad
;- Uses IDL's INTERPOL routine

    sz = size( shifts, /dimensions)
    cadence_inter = indgen(sz[1])
    new_shifts = fltarr(sz)

    for ii = 0, sz[0]-1 do begin
        data = shifts[ii,cad]
        data_inter = interpol( data, cad, cadence_inter );, /spline )
        new_shifts[ii,*] = data_inter
    endfor
    return, new_shifts
end

;----------------------------------------------------------------------------------

;22 May 2018 (ML code)

;path = '/solarstorm/laurel07/Data/AIA_prepped/'
;fls = file_search( path + '*1600*.fits' )
;read_sdo, fls, index, data

;- 28 July 2019
READ_MY_FITS, /syntax
READ_MY_FITS, index, data, fls, $
    instr='aia', channel='1600', prepped=1, $

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

;----------------------------------------------------------------------------------

;- 30 July 2019

@parameters
restore, '../' + year + month + day + '/' + instr + channel + 'shifts.sav'

sz = size(shifts, /dimensions)
new_shifts = fltarr(sz)
help, new_shifts


cad = [423:469]

good_indices = [0, [1:422], [470:sz[1]-1] ]
new_indices = indgen(sz[1])


xdata = indgen(sz[1])
for jj = 0, sz[2]-1 do begin
    for ii = 0, 1 do begin
        yy = reform(shifts[ii,good_indices,jj])
        new_shifts[ii,*,jj] = interpol( $
            yy, good_indices, new_indices) ;, $
            ;/spline )
            ;/lsquadratic )
            ;/quadratic )
    endfor
    ;plt = PLOT_SHIFTS( shifts[*,xdata,jj], xdata=xdata, buffer=0, location=[5,0]*dpi )
;    plt = PLOT_SHIFTS( $
;        new_shifts[*,xdata,jj], xdata=xdata, buffer=0, location=[5,5.5]*dpi, $
;        title="spline" )
;        title="LSquadratic" )
;        title="quadratic" )
endfor


plt = PLOT_SHIFTS( $
    new_shifts[*,xdata,3], xdata=xdata, buffer=0, location=[5,5.5]*dpi, $
    ;title="spline" )
    ;title="LSquadratic" )
    ;title="quadratic" )
    title="linear" )


;- INTERPOL test
xx = [ 0, [1:4], [7:9] ]
yy = (xx+1) * 10
new_yy = interpol( yy, xx, indgen(10) )




resolve_routine, 'apply_shifts', /either
APPLY_SHIFTS, cube, new_shifts


;imdata = CROP_DATA( /syntax )

rr = 200
center=[475,250]
dimensions=[rr,rr]
imdata = CROP_DATA(cube, center=center, dimensions=dimensions, z_ind=[375] )
help, imdata
if instr eq 'aia' then begin
    imdata = AIA_INTSCALE( imdata, wave=fix(channel), exptime=index[0].exptime )
    ct = AIA_COLORS(wave=fix(channel))
endif else $
if instr eq 'hmi' then begin
    imdata = ref
    ct = 0
endif else print, "variable instr must be 'hmi' or 'aia'."
dw
im = image2( imdata, buffer=0, layout=[1,1,1], margin=0.1, rgb_table=ct )


xstepper2, CROP_DATA( $
        cube, $
        ;z_ind=[370:500], $
        center=center, dimensions=dimensions ), $
    channel=channel, $
    subscripts=[370:500], $
    scale=3.0



end
