

;- Sun Apr 21 10:27:12 MDT 2019


pro testplot
    xdata = indgen(10) + 2
    ydata = [ [xdata^2], [xdata^3] ]
    dw
    plt = objarr(2)
    plt[0] = plot2( xdata, ydata[*,0], location=[1200,0], ystyle=1 )
    plt[1] = plot2( xdata, ydata[*,1], overplot=1, ystyle=1 )

;    x = [0.0, 1.0, 2.0]
;    y = [0.0, 10.0, 45.0]
;    x = [0,0.5,1]
;    y = [0,0.5,1]

    nn = 5
    y = findgen(nn)/nn
    y = ( y - min(y))
    x = y

    result = plt[0].convertcoord( x, y, /relative, /to_data )
    print, result[1,*]
    ;print, round(result)

;    print, plot.xrange
;    print, plot.yrange

    ;print, x * result[0,*]
end

goto, start


;_____________________________________________________________________________________________

;- Removing first observation for AIA1600 so #elements agrees with AIA1700.
restore, '../20131228/aia1600aligned.sav'
save, cube, filename='aia1600aligned_old.sav'

cube = cube[*,*,1:*]
save, cube, filename='aia1600aligned.sav'

;- NOTE: setting a variable equal to subset of itself is risky; could accidentally
;-  crop off more and more without intending to if code is run multiple times.
;- Better way:

save, cube[*,*,1:*], filename='aia1600aligned.sav'
;_____________________________________________________________________________________________

testplot ;- procedure defined at top of file.

format = '(E0.2)'

print, min(A[0].flux), format=format
print, max(A[0].flux), format=format
print, min(A[1].flux), format=format
print, max(A[1].flux), format=format
print, max(A[0].flux) - min(A[0].flux), format=format
print, max(A[1].flux) - min(A[1].flux), format=format
print, plt[0].yrange, format=format
print, plt[1].yrange, format=format
print, plt[0].ytickvalues, format=format
print, plt[1].ytickvalues, format=format
;_____________________________________________________________________________________________

;- Imaging... still don't have good routine for this.

@parameters
zz = (where( time eq strmid(gpeak,0,5) ))[0]
print, zz

imdata = crop_data( A.data[*,*, zz, *], dimensions=dimensions )
sz = size(imdata, /dimensions)
time = strmid(A[0].time,0,5)
stop

start:;------------------------------------------------------------------------------

;- Update aia1600 shifts to exclude first observation
restore, '../20131228/aia1600shifts.sav'
save, aia1600_shifts, filename = 'aia1600shifts_old.sav'
aia1600shifts = aia1600_shifts[*, 1:*, *]
help, aia1600_shifts
help, aia1600shifts
save, aia1600shifts, filename = 'aia1600shifts.sav'


;shifts = total( aia1600_shifts, 3 )
;shifts = shifts[*,1:*]

stop


cdelt = 0.6
crpix = 2048.5

;- Determine coords of image zz by subtracting its shifts from ref coords,
;-  and using crpix and cdelt to convert to solar coords in arcseconds.
xx = ( indgen(sz[0]) + (x1 - crpix - shifts[0,zz]) ) * cdelt
yy = ( indgen(sz[1]) + (y1 - crpix - shifts[1,zz]) ) * cdelt
    ;- 24 April 2019
    ;-   Removed "ROUND" from correction of coords.

common defaults

im = objarr(sz[2])

rows=1
cols=2

left   = 0.17
right  = 0.02
bottom = 0.10
top    = 0.10

;- Syntax
;-   imdata = AIA_INTSCALE( data, wave=wave, exptime=exptime )


props = { $
    xtitle : 'X (arcsec)', $
    ytitle : 'Y (arcsec)', $
    buffer : 1 $
}

dw
wx = 8.0
wy = 3.5
win = window( dimensions=[wx,wy]*dpi, location=[1200,0], buffer=0 )

for ii = 0, sz[2]-1 do begin
    im[ii] = image2( $
        AIA_INTSCALE( imdata[*,*,ii]*A[ii].exptime, $
            wave=fix(A[ii].channel), exptime=A[ii].exptime), $
        xx, yy, $
        ;A[ii].X[100:599], A[ii].Y[185:514], $
        current=1, $
        layout=[cols,rows,ii+1], $
        margin=[left,bottom,right,top], $
        ;axis_style=0, $
        rgb_table = A[ii].ct, $
        buffer=1, $
        title = A[ii].name + ' ' + strmid(A[ii].time[zz],0,8) + ' UT', $
        _EXTRA = props)
endfor

end
