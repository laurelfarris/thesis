; 23 July 2018

; HMI possible channels: 'dop', 'mag', 'cont'


pro HMI, channels, cube, time, X, Y

    N = 3

    cube = fltarr(500,330,N)
    time = strarr(N)

    ; AR moves about 70 pixels over entire ts
    ; There should be 400 HMI images covering this ts
    ; (actually 398 because of missing data, but time still goes on).
    pixels_per_image = 70./400

    ;ind = [0,390]

    for i = 0, N-1 do begin

        x0 = 2375; + fix(round( ind[i] * pixels_per_image ))
        y0 = 1660

        READ_MY_FITS, index, data, inst='hmi', channel=channels[i], $
            ind=[0]

        time[i] = index.date_obs
        cube[*,*,i] = crop_data(data, center=[x0,y0])
    endfor

    xll = x0 - 250
    yll = y0 - 165

    X = round(( (indgen(500)+xll) - index.crpix1 ) * index.cdelt1)
    Y = round(( (indgen(330)+yll) - index.crpix2 ) * index.cdelt2)

    ;return, cube
end

;cube = HMI('mag')

channels = [ 'dop', 'mag', 'cont' ]
HMI, channels, cube, time, X, Y


title = 'HMI ' + ['Doppler velocity', 'B$_{LOS}$', 'continuum'] + $
    ' 2011-February-15 ' + strmid(time,11,8)

N = n_elements(channels)
win = window( dimensions=[8.5/2, 9.0]*dpi, location=[600,0] )

cols = 1
rows = 3
left = 1.00
bottom = 0.5
right = 0.25
top = 0.5

resolve_routine, 'image_array_2', /either
IMAGE_ARRAY_2, cube, X, Y, layout=[cols,rows], $
    xtitle = 'X (arcseconds)', $
    ytitle = 'Y (arcseconds)', $
    title = title

stop

for i = 0, N-1 do begin
    im = image2( $
        cube[*,*,i], X, Y, $
        ;cube[*,*,i]>(-300)<(300),  $
        /current, $
        /device, $
        layout=[cols,rows,i+1], $
        margin=0.75*dpi, $
        xtitle = 'X (arcseconds)', $
        ytitle = 'Y (arcseconds)', $
        title = titles[i] )

endfor


end
