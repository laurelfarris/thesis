;; Last modified:   02 June 2017 14:41:11


step = 6

case step of 
    1: begin
        ;; Read fits files
        resolve_routine, 'read_my_fits', /either
        ;path = '/solarstorm/laurel07/Data/aia/aia*2011*.fits'
        ;READ_MY_FITS, aia_index, aia_data, path=path, nodata=0
        path = '/solarstorm/laurel07/Data/HMI/hmi*2011*continuum.fits'
        READ_MY_FITS, hmi_index, hmi_data, path=path, nodata=0
        end
    2: begin
        ;; Images
        w = window()
        for i = 0, 5 do begin
            im = image( data[*,*,i+50], current=1, layout=[2,3,i+1] )
        endfor
        end
    3: begin
        ;; Watch movie of images to see what flare looks like
        xstepper, data ;, info_array, xsize=xsize, ysize=ysize, /interp, start=start, /noscale
        end
    4: begin
        ;; Align data (may need to adjust according to xcen, ycen, but only if using
        ;;    data from different instruments... which I probably won't be.)
        ALIGN, cube
        end
    5: begin
        ;; Sum entire disk
        d = fltarr(381)
        for i = 0, 380 do begin
            ;d[i] = total( hmi_data[*,*,i+1] ) - total( hmi_data[*,*,i] )
            d[i] = total( hmi_data[*,*,i] )
        endfor
        end
    6: begin
        ;; Fourier analysis
        delt = 45

        ;; Array containing power and phase at each frequency (according to comments).
        result = Fourier2( d, delt )

        frequency = result[0,*]
        power_spectrum = result[1,*]
        phase = result[2,*]
        amplitude = result[3,*]

        ytitle=["frequency", "power spectrum", "phase", "amplitude"]

        ;resolve_routine, "graphic_configs"
        e = graphic_configs(2)
        w = my_window( 700, 700, /del )
        for i = 0, 3 do begin
            p = plot(result[i,*], layout=[2,2,i+1], /current, $
            ytitle=ytitle[i], xtitle="",  _EXTRA=e)
        endfor
        w2 = my_window( 700,500 )
        p1 = plot(d, layout=[1,1,1], _EXTRA=e)
        end
      
endcase


end
