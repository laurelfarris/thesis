
;- 19 November 2018

;- Aftering .run prep, .continue to restore power maps from .sav files (dz = 64).


goto, start
start:;----------------------------------------------------------------------------------

common defaults

;z_start = [ 16, 58, 196, 216, 248, 280, 314, 386, 450, 525, 600, 658 ]

;- Before


z_start = [ 16, 58, 196 ]
N = n_elements(z_start)
color = ['black', 'red', 'blue', 'green']
name = [ 'AR_1', 'AR_2', 'AR_3', 'background' ]

dz = 64

add_poly = 1

for cc = 0, 1 do begin

    channel = A[cc].channel
    file = 'aia' + A[cc].channel + phase
    exptime=A[cc].exptime
    time = strmid(A[cc].time,0,5)

    bda = fltarr(500, 330, N*2)
    title = strarr(N*2)

    foreach zz, z_start, ii do begin
        bda[*,*,ii] = mean( A[cc].data[*,*,zz:zz+dz-1], dim=3 )
        bda[*,*,ii+N] = A[cc].map[*,*,zz]
        title[ii] = time[z_start[ii]] + '-' + time[z_start[ii]+dz] + ' UT'
    endforeach

    ;- Separate variable for imdata to preserve data values.
    imdata = [ $
        [[ aia_intscale( bda[*,*,0:2], wave=fix(A[cc].channel), exptime=1.0 ) ]], $
        [[ alog10(bda[*,*,3:5]) ]] ]

    resolve_routine, 'image3', /either
    im = image3( $
        imdata, $
        xshowtext=0, $
        yshowtext=0, $
        rows=2, cols=3, $
        title=title, $
        rgb_table=A[cc].ct, $
        width = 2.3, $
        left = 0.5, $
        xgap = 0.2, $
        top = 0.25, $
        ygap = 0.25, $
        wy = 4.0 )

    ax = im[0].axes
    ax[1].showtext = 1
    ax[1].tickname = ' '
    ax[1].title = 'mean intensity'

    ax = im[3].axes
    ax[1].showtext = 1
    ax[1].tickname = ' '
    ax[1].title = '3-min power'

end
