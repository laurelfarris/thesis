
;- 20 November 2018

;- "saturates at +/- 1500 Mx cm^{-1}" -Schrijver2011


goto, start





;- HMI B_LOS contours
channel = 'mag'

;- Returns "cube" [750, 500, 398]
restore, '../hmi_' + channel + '.sav'
file = 'HMI_BLOS.pdf'

hmi = crop_data( cube ) ; default dimensions = [500,330]

sz = size(hmi, /dimensions)


READ_MY_FITS, index, instr='hmi', channel='mag', $
    ;ind=[z_start-(dz/2)], $
    nodata=1, $
    prepped=1




;- hmi line through middle of two sunspots (pos/neg)
p = plot2( hmi[*,175,0] )
stop


hmi_time = strmid( index.date_obs, 11, 5 )

start:;----------------------------------------------------------------------------------
c_data = fltarr(sz[0], sz[1], n_elements(z_start)*2 )
foreach zz, z_start, ii do begin
    ind = (where( hmi_time eq time[zz] ))[0]
    c_data[*,*,ii] = hmi[*,*,ind+(dz/2)]
    c_data[*,*,ii+3] = hmi[*,*,ind+(dz/2)]
endforeach
stop

nn = n_elements(im)

;c_value = [ -reverse(c_value), c_value ]
c_value = [-300, 300 ]
c_color = ['black', 'white']

c = objarr(nn)

foreach jj, [0:nn-1], ii do begin
    c[ii] = CONTOUR( $
        c_data[*,*,ii], $
        overplot=im[jj], $
        c_thick=0.5, $
        c_label_show=0, $
        c_value=c_value, $
        c_color=c_color )
endforeach

;file = 'HMI_BLOS_contours.pdf'
;save2, file
;c.delete
end
