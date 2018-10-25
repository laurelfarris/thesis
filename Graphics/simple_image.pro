


;- simple code to quickly image data


function image_test, data


    common defaults

    n = 1

    win = window( dimensions=[wx,wy]*dpi, /buffer )

    im = objarr(n)

    for ii = 0, n-1 do begin
    
        im[ii] = image2( $
            data[*,*,ii], $
            layout=[1,1,1], $
            margin=0.1, $
            _EXTRA=e )

    endfor


    return, im
end



function plot_test, x, y


    common defaults

    n = 1

    wx = 5.0
    wy = wx

    ;dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    plt = objarr(n)

    for ii = 0, n-1 do begin
    
        plt[ii] = plot2( $
            x, y, $
            layout=[1,1,1], $
            margin=0.1, $
            _EXTRA=e )

    endfor

    file = 'test_histogram.pdf'
    save2, file, /add_timestamp


    return, plt
end
