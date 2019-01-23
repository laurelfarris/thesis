;- 17 December 2018
;- Makes array of graphics across single window:
;-   one each for B, D, and A, where each phase in BDA has
;-   several start indices to cover time periods of interest.
;- (Also see bda_powermaps.pro, which generates a single image on which
;-   contours and polygons can be viewed in detail.)
;- At time of writing, powermap figures in article1 were generated from
;-   this routine.


;- 04 December 2018
goto, start

;restore, '../hmi_mag.sav'
;hmi = crop_data( cube )

common defaults

dz = 64

;--- Restore maps and multiply by saturation mask

@restore_maps
for cc = 0, 1 do begin

    data_mask = A[cc].data lt 15000.
    sz = size(data_mask, /dimensions)
    sz[2] = sz[2]-dz+1
    map_mask = fltarr(sz)

    for ii = 0, sz[2]-1 do $
        map_mask[*,*,ii] = product( data_mask[*,*,ii:ii+dz-1], 3 )

    A[cc].map = A[cc].map * map_mask
endfor
stop

start:;----------------------------------------------------------------------------------

;--- indices for before, during, and after flare.

;phase = "before"
;z_start = [0, 16, 27, 58, 80, 90, 147, 175, 196]
;phase = "during"
;z_start = [197, 200, 203, 216, 248, 265, 280, 291, 311]
phase = "after"
z_start = [ 387, 405, 450, 467, 475, 525, 625, 660, 685 ]


;--- Image power maps for indices defined above.

N = n_elements(z_start)
bda = fltarr(500, 330, N)
title = strarr(N*2)

rows = 3
cols = 3

for cc = 0, 1 do begin

    channel = A[cc].channel
    exptime=A[cc].exptime
    time = strmid(A[cc].time,0,5)

    foreach zz, z_start, ii do begin
        ;bda[*,*,ii] = A[cc].map[*,*,zz]
        title[ii] = time[zz] + '-' + time[zz+dz-1] + ' UT'
        ;title[ii] = " "
        ;c_data[*,*,ii] = hmi[*,*,zz+(dz/2)]
    endforeach
    bda = A[cc].map[*,*,z_start]

    ;- Separate variable for imdata to preserve data values.
    imdata = alog10(bda+0.1)

    dw
    resolve_routine, 'image3', /either
    ;- NOTE: image3 returns object array
    im = image3( $
        imdata, $
        buffer=1, $
        min_value=min(imdata), $
        max_value=max(imdata), $
        rgb_table=A[cc].ct, $
        title=title, $
        xshowtext=0, $
        yshowtext=0, $
        xgap=0.05, $
        ygap=0.05, $
        left=0.2, $
        right=1.0, $
        rows=rows, cols=cols )

;    for jj = 0, 5 do begin
;        c[jj] = CONTOUR( c_data[*,*,jj], overplot=im[jj], c_thick=0.5, $
;            c_label_show=0, c_value=c_value, c_color=c_color )
;    endfor

    title_color = ["white", "black"]
    foreach zz, z_start, ii do begin
        im[ii].title = " "
        ti = text( $
            0+20, sz[1]-5, $
            A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + ' UT', $
            /data, $
            target=im[ii], $
            font_size=fontsize, $
            alignment = 0.0, $
            vertical_alignment = 1.0, $
            color=title_color[cc] )
        ;ti = im[ii].title
        ;ti.position = ti.position - [0.0, 0.041, 0.0, 0.041]
        ;ti.font_size = fontsize
        ;ti.color = title_color[cc]
        ;ti.alignment = 0.0
        ;im[ii].title = A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + ' UT'
        txt = text( $
            sz[0]-20, sz[1]-5, $
            alph[ii], $
            target=im[ii], $
            /data, $
            font_size=fontsize, $
            alignment = 1.0, $
            vertical_alignment = 1.0, $
            color=title_color[cc]  )
    endforeach
    resolve_routine, 'colorbar2', /either
    ;cbar = colorbar3( target=im[2], title = 'mean intensity', tickformat='(I0)' )
    ;cbar = colorbar3( target=im[5], title='log 3-minute power' )
    cbar = colorbar2( target=im, title='log 3-minute power' )

    file = 'aia' + A[cc].channel + phase
    save2, file
endfor
end
