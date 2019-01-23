
; email from Prof. James (22 June)

goto, start

;filename = '~/Dropbox/test_data.ps'
;TOGGLE, $
    ;color=color, $
    ;/landscape, $ ; plot orientation (default=portrait)
    ;print=print, $
    ;queue=queue,  $
    ;eps=eps, $
    ;/legal, $ ; page size (default=letter)
;    filename=filename

common defaults
restore, '../test_data.sav'

;help, lc1
;help, time

;plot, time, lc1
;p = plot2( time, lc1, layout=[1,1,1], color='red', current=1 )
;p = plot2( time, lc1, layout=[1,1,1], color='red', buffer=1 )

;p.save, '~/Dropbox/test_data.pdf', page_size=[w,h], width=w, height=h


;; Calculate FT of fake data

cadence = time[1] - time[0]

fmin = 1./400
fmax = 1./50

struc = CALC_FT( lc1, cadence, fmin=fmin, fmax=fmax )
;struc = CALC_FT( lc1, cadence, fmin=0.005, fmax=0.006 )
help, struc

w = 8.5
h = 4.0
win = window( dimensions=[w,h]*dpi, buffer=1 )

p = plot2(  $
    struc.frequency, $
    struc.power, $
    /current, $
    xtitle = 'frequency (Hz)', $
    ytitle='Power', $
    _EXTRA=e )

ax = p.axes
ax[2].showtext = 1
ax[2].title = 'period (s)'

period = 1./(ax[0].tickvalues)
ax[2].tickname = strtrim( fix(period), 1 )


;; Plot power spectrum
p.save, '~/Dropbox/test_ft.pdf', $
    page_size=[w,h], width=w, height=h


;; Plot power vs. time


dz = 64

fmin = 0.005
fmax = 0.006

; initialize power array
N = n_elements(lc1)
power = fltarr(N-dz)

START:
norm = 1
; Calculate power for time series between each value of z and z+dz
for i = 0, n_elements(power)-1 do begin

    struc = CALC_FT( lc1[i:i+dz-1], cadence, fmin=fmin, fmax=fmax, norm=norm )
    power[i] = struc.mean_power

endfor

win = window( dimensions=[w,h]*dpi, buffer=1 )
p = plot2( time, power, $
    /current, $
    xtitle = 'time (s)', $
    ytitle = '3-minute power' )

;p.save, '~/Dropbox/test_power_time_norm.pdf', $
p.save, 'test_power_time_norm.pdf', $
    page_size=[w,h], width=w, height=h
end
