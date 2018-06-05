; 01 June 2018
goto, start
temp = map[95:155,75:135,*]

;; Just integrated flux for now:

; Make mini-structures just for color, symbol, name, etc.
; Make a separate place to store actual data (flux, power)
; Remember to always separate science from graphics...

START:;--------------------------------------------------------------------

fmin = 1./400
fmax = 1./100

w = 2.5
h = w
gap = 1.0

wx = 7.5
wy = 8.0
win = window( dimensions=[wx,wy]*dpi )

; To norm or not to norm? Different panel for each
for norm = 0, 1 do begin

    ; AIA 1600/1700
    for k = 0, 1 do begin

    time = strmid(A[k].time, 0, 5)

    x1 = 0.75 + norm*(w+gap)
    y1 = 1.5 + abs(k-1)*(h+gap)
    position=[x1,y1,x1+w,y1+h]

    quiet = { $
        flux: A[k].flux[100:224], $
        color: 'blue', $
        ;color: A[k].color, $
        linestyle: '-', $
        symbol: 'Triangle', $
        sym_size: 0.75, $
        name: 'Non-flaring (' + time[100] + '-' + time[224] + ')'$
        }
    flare = { $
        flux: A[k].flux[225:349], $
        color: 'red', $
        ;color: A[k].color, $
        ;linestyle: '-.', $
        linestyle: '-', $
        symbol: 'Circle', $
        sym_size: 0.50, $
        name: 'X-flare (' + time[225] + '-' + time[349] + ')'$
        }
    struc=[quiet, flare]
    n = n_elements(struc)
    p = objarr(n)

    for i = 0, n-1 do begin

        result = fourier2( struc[i].flux, 24, norm=norm)
        frequency = reform( result[0,*] )
        power = reform( result[1,*] )
        ;; Plotting fmin onward, but not reducing the array itself...
        ;; Example of not altering the data itself, only the part shown in figures

        ind = where(frequency ge fmin AND frequency le fmax)
        x = frequency[ind]
        y = power[ind]

        if norm eq 0 then begin
            ytitle=A[k].name + ' power'
            yrange=[1e7,1.1e13] 
            endif
        if norm eq 1 then begin
            ytitle=A[k].name + ' power' + ' (normalized)'
            yrange=[1e-4,1e2] 
            endif

        p[i] = plot2( $
            x, y, $
            /current, $
            /device, $
            ;title=A[k].name, $
            position=position*dpi, $
            overplot=i<1, $
            yrange=yrange, $
            color=struc[i].color, $
            symbol=struc[i].symbol, $
            sym_filled=1, $
            ;stairstep=1, $
            sym_size=struc[i].sym_size, $
            linestyle=struc[i].linestyle, $
            ylog=1, $
            xtitle='frequency (Hz)', $
            ytitle=ytitle, $
            name=struc[i].name $
            )
    endfor

    period = [120,180,300]
    ax = p[i-1].axes
    ax[2].tickvalues = 1./period
    ax[2].tickname = strtrim( reverse( period[sort(period)] ), 1 )
    ax[2].title = 'period (s)'
    ax[2].showtext = 1
    foreach per, period do $
        v = plot_vline( 1./per, p[0].yrange, color='light grey' )
    endfor
endfor


leg = legend2( target=p, $
    position=[0.8,0.12], $
    linestyle=6, $
    horizontal_spacing=0.05)
stop

save2, 'norm_vs_not.pdf'


end
