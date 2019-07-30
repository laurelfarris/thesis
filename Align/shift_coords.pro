;+
;- LAST MODIFIED:
;-   16 August 2018
;-
;- ROUTINE:
;-   name_of_routine.pro
;-
;- PURPOSE:
;-   Align first and last image to see how far to shift pixels in
;-   x and y to get the correct physical coordinates in arcseconds
;-   when labeling images at various points throughout time series.
;-
;- USEAGE:
;-   result = routine_name( arg1, arg2, kw=kw )
;-
;- INPUT:
;-   arg1   e.g. input time series
;-   arg2   e.g. time separation (cadence)
;-
;- KEYWORDS (optional):
;-   kw     set <kw> to ...
;-
;- OUTPUT:
;-   result     blah
;-
;- TO DO:
;-   [] item 1
;-   [] item 2
;-   [] ...
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+


function SHIFT_COORDS, channel

    restore, '../aia' + channel + 'data.sav'

    sz = size(data, /dimensions)
    cube = [ [[data[*,*,0]]], [[data[*,*,-1]]] ]
    ;ref = data[*,*,sz[2]/2]
    ref = cube[*,*,-1]

    N = 5 ; number of times to run alignment

    average_shifts = fltarr(2,N)
    for i = 0, N-1 do begin
        ALIGN_CUBE3, cube, ref, shifts=shifts
        average_shifts[*,i] = shifts
    endfor
    average_shifts = mean(average_shifts, dimension=2)

    xs = ( findgen(sz[2])/sz[2] ) * average_shifts[0]
    ys = ( findgen(sz[2])/sz[2] ) * average_shifts[1]

    time_shifts = [ [xs], [ys] ]
    return, time_shifts
end


; test for the 'i-th' image, using AIA 1600 (A[0])
channel = '1600'
i = 200

test_image = A[0].data[*,*,i]

shifts = SHIFT_COORDS( channel )
help, shifts ; should be 2x749 array, with max value of shifts[0,*] around 70
                ; max value of shifts[1,*] should be pretty small

; Calculate pixel coordinates for the i-th image
X = A[0].X + shifts[0,i]
Y = A[0].Y + shifts[1,i]


end
