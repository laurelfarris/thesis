
;- 28 November 2018

function POLYGON_SUBREGIONS, center, target=target, width=width, color=color
    ;- Polygon around enhanced regions
    ;- Lots of polygons on the same image...

    nn = (size(center,/dimensions))[1]
    pol = objarr(nn)
    resolve_routine, 'polygon2', /either

    for ii = 0, nn-1 do begin

        pol[ii] = polygon2( $
            target=im, center=center[*,ii], dimensions=[width,width],  $
            color=color[ii], $
            ;name='AR_' + strtrim(ii+1,1), $
            thick=2.0 )

        txt = text( $
            center[0,ii], center[1,ii] + width/2 + 1, $
            strtrim(ii+1,1), $
            /data, target=im, font_size=fontsize )
    endfor
    return, pol
end

goto, start

;map = crop_data( A[0].map, center=[365, 215], dimensions=[150,150] )
;dat = crop_data( A[0].data, center=[365, 215], dimensions=[150,150] )

dz = 64

; South SS pair
;center = [ $
;    [130, 143], $
;    [160, 153], $
;    [185, 145], $
;    [255, 159], $
;    [230, 140] ]

; North SS pair
center = [ $
    [255, 215], $
    [272, 193], $
    [265, 200], $
    [382, 193] ]
nn = (size(center,/dimensions))[1]

z_start = [ $
    16, 58, 196, $
    216, 248, 280, $
    314, 386, 450, $
    525, 600, 658 ]

zz = 200
imdata = alog10(A[0].map[*,*,zz])
wx = 15.0
wy = wx * (330./500.)
win = window(dimensions=[wx,wy]*dpi, location=[500,0])
im = image2( $
    imdata, $
    /current, $
    margin=0.1, $
    title=A[0].name + ' @5.6 mHz (' + A[0].time[zz] + ' UT)', $
    rgb_table=A[0].ct )

time = strmid(A[0].time,0,5)

;- HMI contours
resolve_routine, 'get_hmi', /either
c_data = GET_HMI( time[zz+(dz/2)], channel='mag' )
resolve_routine, 'contours', /either
c = CONTOURS( c_data, target=im, channel='mag' )


start:;---------------------------------------------------------------------------------
;- Polygons around ROIs.
r = 10
pol = POLYGON_SUBREGIONS( center, target=im, width=r, color=color )

;- Plotting

ind = [0:259] ;- "Before"

plt = objarr(nn)
buffer = 0
@batch_graphics

for ii = 0, nn-1 do begin
    x0 = center[0,ii]
    y0 = center[1,ii]
    
    ;ydata = (mean(mean(A[0].data[x0-r:x0+r-1,y0-r:y0+r-1,ind],dim=1),dim=1))
    ydata=alog10(mean(mean(A[0].map[x0-r:x0+r-1,y0-r:y0+r-1,ind],dim=1),dim=1))
    ;xdata = indgen(n_elements(ydata))
    xdata = ind
    plt[ii] = plot2( $
        xdata, ydata, /current, overplot=ii<1, margin=0.1, $
        xtickinterval = 25, $
        ;ytitle = 'average intensity', $
        ytitle = '3-minute power', $
        ;ylog=1, $
        color=color[ii], name='AR' + strtrim(ii+1,1) )
endfor

LABEL_TIME, plt, time=A[0].time
leg = LEGEND2( target=plt )
;OPLOT_FLARE_LINES, plt, t_obs=A[0].time

end
