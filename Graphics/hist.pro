;-
;- LAST MODIFIED:
;-   18 July 2020
;-
;- CREATED:
;-   24 April 2018 16:19:09
;-
;-
;- main procedure HIST (the own following test_hist)
;- calls IDL function HISTOGRAM, which returns data to use for plotting,
;- but doesn't create any graphics itself.
;-



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

    result = HISTOGRAM( $
        data, $
        ;binsize = binsize, $
        nbins = nbins, $
        locations = locations, $
        _EXTRA = e $
    )


    wx = 5.0
    wy = wx
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=buffer )

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
HIST, test


;-------------------------------------------------------------------------------


;+
;- Example code copied from Harris geospatial ref pages for IDL --> PLOTHIST
;-   (18 July 2020)
;-


;-
;-  Create a vector of random 1000 values derived from a
;-    Gaussian of mean 0, and sigma of 1.
;-  Plot the histogram of these values with a
;-    binsize of 0.1, and use a box plotting style.
;-
a = randomn(seed,1000)
PLOTHIST, a, bin = 0.1, /boxplot

;-
;- As before, but fill the plot with diagonal lines at a 45 degree angle
;-
PLOTHIST, a, bin=0.1, /fill, /fline, forient=45


end
