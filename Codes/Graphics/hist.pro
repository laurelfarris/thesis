;; Last modified:   24 April 2018 16:19:09



; See Notes from February 15 and April 20.



pro test_hist

    dat = [2,2,3,3,3,5,9]
    dat = dat/10.

    binsize = 0.1

    result = histogram( dat, binsize=binsize )
    print, result

end


pro HIST, data, _EXTRA=e

    common defaults


    binsize = 0.1
    nbins = 1000

    ; if using nbins, this will = n_elements(result)

    result = histogram( data, $
        ;binsize = binsize, $
        nbins = nbins, $
        locations = locations, $
        _EXTRA = e )



    wx = 5.0
    wy = wx

    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    plt = objarr(1)

    ii = 0
    ;for ii = 0, n-1 do begin
    
        plt[ii] = plot2( $
            locations, result, $
            /current, $
            layout=[1,1,1], $
            margin=0.1, $
            ylog=1, $
            yrange=[0,100], $
            stairstep=1, $
            _EXTRA=e )

    ;endfor

    file = 'test_histogram.pdf'
    save2, file, /add_timestamp


end

test = aia1600map[*,*,50]
hist, test

end
