;+
;- LAST MODIFIED:
;-   04 October 2017 16:05:13
;-
;- ROUTINE:
;-   name_of_routine.pro
;-
;- EXTERNAL SUBROUTINES:
;-   fourier2 --> returns "Array containing power and phase at each frequency"
;-
;- PURPOSE:
;-   Run fourier2 through time on each pair of 2D pixel coordinates
;-   and return 2D power image
;-
;- USEAGE:
;-   PLOT_FOURIER2, flux, delt, $
;-       frequency, power, phase, amplitude, period, $
;-       seconds=seconds, minutes=minutes, $
;-       make_plot=make_plot, $
;-       buffer=buffer, $
;-       norm=norm
;-
;- REQUIRED INPUT ARGS:
;-   cube = data cube time series (i.e. same dt between each image).
;-   delt = time between each image, in seconds.
;- OPTIONAL INPUT ARGS (computed by subroutine; include to get values back at ML):
;-   frequency, power, phase, amplitude, period
;- OPTIONAL KEYWORDS:
;-   seconds=seconds, minutes=minutes, $
;-   make_plot=make_plot, $
;-   buffer=buffer, $
;-   norm=norm
;-
;- OUTPUT:
;-   result     blah
;-
;- TO DO:
;-   []
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-

;pro PLOT_FOURIER2, flux, delt, $
function PLOT_FOURIER2, flux, delt, $
    result, $
    frequency, power, phase, amplitude, $
    period, seconds=seconds, minutes=minutes, $
    make_plot=make_plot, $
    buffer=buffer, $
    norm=norm

    common defaults

    result = FOURIER2( flux, delt )
    frequency = result[0,*]
    power = result[1,*]
    phase = result[2,*]
    amplitude = result[3,*]

    ;- What is period used for? Returned to ML... not sure why.
    if keyword_set( minutes ) then period = (1./frequency)/60.
    if keyword_set( seconds ) then period = 1./frequency


    ;result = [ frequency, power, amplitude, phase ]
    ;  NOTE: each array is already 2D (1xN), so result is 4xN.


    if keyword_set( make_plot ) then begin
;        ytitle = [ "frequency (mHz)", "power spectrum", "phase", "amplitude"  ]

        wx = 8.5
        wy = wx
;        wy = 11.0

        win = window( dimensions=[wx,wy]*dpi, buffer=buffer )

        xdata = reform(frequency*1000)
        ydata = [ alog10(power), phase ]

        xtitle = "frequency (mHz)"
        ytitle = ["log Power", "Phase (degrees)"]
        title = ["Power spectrum", "Phase spectrum" ]

        plt = objarr(3)
        rows = 3
        cols = 1

        for ii = 0, n_elements(plt)-2 do begin

            plt[ii] = PLOT2( xdata, reform(ydata[ii,*]), /current, $
                layout=[cols,rows,ii+1], $
                ;stairstep=1, $
                xtickinterval=2, $
                symbol="o", sym_size=0.25, $
                xtitle=xtitle, ytitle=ytitle[ii], title=title[ii] )
             vert = plot2( $
                [5.56, 5.56], $
                [(plt[ii].yrange)[0], (plt[ii].yrange)[-1]], $
                /overplot, linestyle=4 )

        endfor

        plt[1].yrange = [-180,180]

        ;- Light curve
        plt[2] = PLOT2( flux, /current, layout=[cols,rows,3], $
            xtitle = "time", $
            ytitle = "Flux (DN s$^{-1}$)", $
            title = "Light curve" )
;        for ii = 0, 3 do begin
;            plt = PLOT2( $
;                result[ii,*], /current, layout=[2,2,ii+1], $
;                ytitle=ytitle[ii], xtitle="index of frequencies" )
;        endfor
    return, plt
    endif else begin
        return, 0
    endelse

stop
end
