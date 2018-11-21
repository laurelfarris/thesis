
;- 19 November 2018

;- Aftering .run prep, .continue to restore power maps from .sav files (dz = 64).



goto, start

restore, '../hmi_mag.sav'
hmi = crop_data( cube )


start:;----------------------------------------------------------------------------------
common defaults

;z_start = [ 16, 58, 196, 216, 248, 280, 314, 386, 450, 525, 600, 658 ]

phase = "before"
z_start = [ 16, 58, 196 ]

;phase = "during"
;z_start = [ 216, 248, 280 ]

;phase = "after1"
;z_start = [ 314, 386, 450 ]

;phase = "after2"
;z_start = [ 525, 600, 658 ]

stop

N = n_elements(z_start)
bda = fltarr(500, 330, N*2)
title = strarr(N*2)

dz = 64
rows = 2
cols = 3

for cc = 0, 1 do begin

    channel = A[cc].channel
    exptime=A[cc].exptime
    time = strmid(A[cc].time,0,5)

    foreach zz, z_start, ii do begin
        bda[*,*,ii] = mean( A[cc].data[*,*,zz:zz+dz-1], dim=3 )
        bda[*,*,ii+N] = A[cc].map[*,*,zz]
        title[ii] = time[zz] + '-' + time[zz+dz-1] + ' UT'
        ;c_data[*,*,ii] = hmi[*,*,zz+(dz/2)]
    endforeach

    ;- Separate variable for imdata to preserve data values.
    imdata = [ $
        [[ aia_intscale( bda[*,*,0:2], wave=fix(A[cc].channel), exptime=1.0 ) ]] , $
        [[ alog10(bda[*,*,3:5]) ]] ]

    resolve_routine, 'image3', /either
    im = image3( $
        imdata, $
        buffer=0, $
        rgb_table=A[cc].ct, $
        title=title, $
        xshowtext=0, $
        yshowtext=0, $
        xgap=0.1, $
        ygap=0.1, $
        left=0.2, $
        right=1.0, $
        rows=rows, cols=cols )


    ;- Maybe images and maps should be handled separately...
    for jj = 0, 2 do begin
        im[jj].min_value = min(imdata[*,*,0:2])
        im[jj].max_value = max(imdata[*,*,0:2])
    endfor
    for jj = 3, 5 do begin
        im[jj].min_value = min(imdata[*,*,3:5])
        im[jj].max_value = max(imdata[*,*,3:5])
    endfor
    for jj = 0, 5 do begin
        c[jj] = CONTOUR( $
            c_data[*,*,jj], $
            overplot=im[jj], $
            c_thick=0.5, $
            c_label_show=0, $
            c_value=c_value, $
            c_color=c_color )
    endfor


    resolve_routine, 'colorbar3', /either
    cbar = colorbar3( target=im[2], title = 'mean intensity', tickformat='(I0)' )
    cbar = colorbar3( target=im[5], title='log 3-minute power' )

    file = 'aia' + A[cc].channel + phase
    save2, file
endfor

end
