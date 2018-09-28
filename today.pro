

; 27 September 2018

goto, start




fls = file_search( './Modules/*.pro' )
foreach f, fls do begin
    ;print, f
    name = strmid( f, 0, strpos(f, '.pro') )
    resolve_routine, name, /either
endforeach


;- Doesn't seem to be working, but compiling using '.com name' somehow seems
;    to be, as if IDL is searching my path recursively, which it's supposed to
;    do anyway, but this didn't seem to be working in the past...
;  p. 40

;- 
;- Plot power spec for BDA, 1 hour each, integrated emission

aia1600 = BDA_STRUCTURES( A[0].flux, A[0].cadence, A[0].time )
aia1700 = BDA_STRUCTURES( A[1].flux, A[1].cadence, A[1].time )

stop
rows = 3
cols = 1

wx = 8.5
wy = wx
dw
win = window( dimensions=[wx, wy]*dpi, /buffer )

p = objarr(3)

resolve_routine, 'plot_power_spectrum', /either
;for cc = 0, 1 do begin
    for ii = 0, 2 do begin
        p[ii] = plot_power_spectrum( $
            aia1600.freq.(ii), $
            aia1600.power.(ii), $
            /label_period, $
            /current, $
            layout=[cols, rows, ii+1], $
            margin=[0.2,0.2,0.1,0.2], $
            symbol='Circle', $
            sym_size=0.25, $
            yrange=[4e4,2e11], $
            /ylog, $
            ;/stairstep, $
            color=A[0].color )

        op = plot_power_spectrum( $
            aia1700.freq.(ii), $
            aia1700.power.(ii), $
            /overplot, $
            symbol='Circle', $
            sym_size=0.25, $
            ;/stairstep, $
            color = A[1].color )
    vert = plot2( [0.0056,0.0056], p[ii].yrange, /overplot, $
        linestyle='--' )
    endfor

;endfor


save2, 'power_spec_BDA.pdf', /add_timestamp
stop

p[0].title = '00:30-01:30'
p[1].title = '01:30-02:30'
p[2].title = '02:30-03:30'


save2, 'power_spec_BDA.pdf', /add_timestamp
stop




;- 
;- Plot BDA power spectrum for each instrument on single panel

struc = [aia1600, aia1700]

rows = 2
cols = 1

colors = ['black', 'blue', 'red']
names = [  $
    'Before (00:30-01:30)', $
    'During (01:30-02:30)', $
     'After (02:30-03:30)' ]

start:;---------------------------------------------------------------------------
wx = 8.5
wy = 11.0
dw
win = window( dimensions=[wx, wy]*dpi, /buffer )

p = objarr(3)

resolve_routine, 'plot_power_spectrum', /either

for cc = 0, 1 do begin
    for ii = 0, 2 do begin
        p[ii] = plot_power_spectrum( $
            ;aia1600.freq.(ii), $
            ;aia1600.power.(ii), $
            struc[cc].freq.(ii), $
            struc[cc].power.(ii), $
            /current, $
            overplot=ii<1, $
            layout=[cols, rows, cc+1], $
            margin=[0.2,0.2,0.1,0.2], $
            symbol='Circle', $
            sym_size=0.25, $
            yrange=[1e4,1e12], $
            /xlog, $
            /ylog, $
            ;thick=ii, $
            ;linestyle=ii, $
            ;/stairstep, $
            ;title='AIA 1600$\AA$', $
            title = A[cc].name, $
            name=names[ii], $
            color=colors[ii] )
    endfor

    period = [120.,180.,200.]
    name = strtrim(period, 1) + ' sec'
    vert = objarr(3)
    for jj = 0, 2 do begin
        vert[jj] = plot2( $
            [1./period[jj], 1./period[jj]], $
            p[0].yrange, $
            /overplot, $
            ;name = '5.6 mHz (3 min)', $
            name = name[jj], $
            linestyle=jj+1 )
    endfor
endfor

leg = legend2(target=[p,vert], position=[0.9,0.55], /normal)




save2, 'power_spec_AIA.pdf', /add_timestamp


end
