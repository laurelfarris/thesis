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
;-   result = routine_name( arg1, arg2, kw=kw )
;-
;- INPUT:
;-   cube = data cube time series (i.e. same dt between each image).
;-   delt = time between each image, in seconds.
;-
;- KEYWORDS (optional):
;-   kw     set <kw> to ...
;-
;- OUTPUT:
;-   result     blah
;-
;- TO DO:
;-   [] item 1
;-   [] item 2
;-   [] ...
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+




pro PLOT_FOURIER2, flux, delt, $
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




    if keyword_set( make_plot ) then begin
        ytitle=["frequency", "power spectrum", "phase", "amplitude"]

        wx = 8.5
        wy = wx

        win = window( dimensions=[wx,wy]*dpi, buffer=buffer )


        for ii = 0, 3 do begin
            plt = PLOT2( $
                result[ii,*], $
                /current, $
                layout=[2,2,ii+1], $
                ytitle=ytitle[ii], $
                xtitle="index of frequencies" $
                )
        endfor
    endif


end
