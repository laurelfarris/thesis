
;- 11 October 2018


function PLOT_FT, frequency, power, names=names, _EXTRA = e

    common defaults
    wx = 8.0
    wy = 4.0
    win = window(/buffer)

    colors = [ 'blue', 'red', 'green', 'purple', 'dark orange', 'dark cyan' ]

    num_plots = (size( power, /dimensions))[1]

    plt = objarr( num_plots )
    for ii = 0, num_plots-1 do begin
        plt[ii] = plot2( $
            frequency, power[*,ii], $
            /current, $
            overplot = ii<1, $
            layout = [1,1,1], $
            margin = 0.1, $
            ;linestyle = ii, $
            symbol = 'circle', $
            color = colors[ii], $
            name = names[ii], $
            ymajor = 7, $
            xtitle = 'frequency (Hz)', $
            ytitle = 'power', $
            _EXTRA = e )
    endfor

    fx = [0.0056]
    v = plot2( [fx,fx], plt[0].yrange, /overplot, ystyle=1, linestyle='--', $
        color='grey')
    v.Order, /send_to_back

    pos = plt[0].position
    leg = legend2( $
        target=plt, $
        position=[pos[2],pos[3]], $
        /relative )
    save2, 'dz.pdf'
    return, plt

    print, ''
    print, '--> Type .CONTINUE (or .C) to save, or .RETALL to return to main level.'
    print, ''
    stop
end

goto, start


journal, '2018-10-01.pro'

;- Set up start indices
dz = 45
time = ( strmid(A[1].time, 0, 5) )
t_start = [ '01:23', '01:41', '01:59' ]
z_start = intarr( n_elements(t_start) )
for ii = 0, n_elements(z_start)-1 do begin
    z_start[ii] = (where(time eq t_start[ii]))[0]
endfor
print, z_start

;- Compute power spectra for each starting index.
power = []
for ii = 0, n_elements(z_start)-1 do begin
    ind = [ z_start[ii] : z_start[ii]+dz-1 ]
    flux = A[1].flux[ind]
    result = fourier2( flux, 24 )
    frequency = reform( result[0,*] )
    power = [ [power], [reform(result[1,*])] ]
endfor


start:;-----------------------------------------------------------------------------

fmin = 1./400
fmax = 1./50
ind = where( frequency gt fmin AND frequency lt fmax )

names = [ '01:23-01:40', '01:41-01:58', '01:59-02:16' ]
stop

plt = PLOT_FT( frequency[ind], power[ind,*], ylog=1, names=names, sym_size=0.5 )


stop
; What happens if journal is edited directly before closing?
print, ''
print, '--> Type .CONTINUE to close journal.'
print, ''
stop
journal


;CD, 'Prep/'
;.run prep
;CD, '../'

;Result = GET_SCREEN_SIZE( [Display_name] [, RESOLUTION=variable] )

;- Power spectra:
;-   Don't have to show full range of frequencies from Milligan2017.
;-

;- Power maps:
;-   Multiply power maps by mask, which can be created using any threshold.
;-   Compare same power map using multiple thresholds.
;-   Show images used to compute maps: running average? standard deviation?
;-   How should power maps be scaled visually?  @methods
;-

end
