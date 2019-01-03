
; Last modified: 16 July 2018

; Input:  3D data cube, titles


;- 17 December 2018
;- I think this was written to create relatively large images (~2 per page) to use
;- for marking coords, doodling on, like the giant reference lightcurve.
;- Subroutine may be useful for general imaging...

;- At a glance, obviously it's making an array of tons of images...
;- That can be helpful too :)

function MAKE_REFERENCE_IMAGES, data, title=title, _EXTRA=e

    common defaults

    sz = size(data, /dimensions)
    im = objarr(sz[2])

    layout = [5,8]
    cols = layout[0]
    rows = layout[1]
    wx = 8.5
    wy = 11.0
    win = window( dimensions=[wx,wy]*dpi, /buffer )
    width = 2.0
    height = width * float(sz[1])/sz[0]

    left   = 0.1
    bottom = 0.1
    right  = 0.1
    top    = 0.5
    margin = [left, bottom, right, top] * dpi

    xoff = -0.05
    yoff = 0.0

    i = 0
    im = objarr(cols,rows)
    for y = 0, rows-1 do begin
    for x = 0, cols-1 do begin
        im[x,y] = image2( $
            map[*,*,i], $
            /current, /device, $
            layout=[cols,rows,i+1], $
            margin=margin, $
            xshowtext=0, $
            yshowtext=0, $
            title=title[i], $
            _EXTRA=e )
        ;offset = [x*xoff, y*yoff, x*xoff, y*yoff]
        ;im[x,y].position = im[x,y].position + offset
        i = i + 1
        ;if i eq 23 then return, im
    endfor
    endfor
    return, im
end


dz = 64
ii = 1

channel = A[ii].channel
data = aia_intscale( A[ii].data, wave=fix(channel), exptime=A[ii].exptime )
;map = AIA_INTSCALE( A[ii].map, wave=fix(channel), exptime=A[ii].exptime )
sz = size(data, /dimensions)

time = strmid(A[ii].time,0,5)
index = indgen(n_elements(time))
time_obs = time + ' (' + strtrim(index,1) + ')'
time_range = time + '-' + shift(time, -(dz-1)) + $
    ' (' + strtrim(index,1) + '-' + strtrim(shift(index, -(dz-1)), 1)  + ')'
time_range = time_range[ 0 : sz[2]-1 ]
;time_central = (shift(time, -(dz/2)))[ 0 : sz[2]-1 ]

for j = 0, 7 do begin
    rows = 8
    cols = 5
    step = 2
    i1 = 0 + j*step*(rows*cols)
    print, i1
    ind = [ i1 : sz[2]-1 : step ]

        im = IMAGE_ALL_POWERMAPS( $
            data[*,*,ind], $
            ;map[*,*,ind], $
            layout=[cols,rows], $
            title=time_obs[ind], $
            ;title=time_range[ind], $
            font_size=9, $
            rgb_table=AIA_COLORS(wave=fix(channel)) )

    file = 'aia' + channel + 'dat_' + strtrim(j,1) + '.pdf'
    save2, file
endfor
end
