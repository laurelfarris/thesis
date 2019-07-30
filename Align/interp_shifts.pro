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


;22 May 2018 (ML code)

function INTERP_SHIFTS, shifts, cad
;- Uses IDL's INTERPOL routine

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
end
