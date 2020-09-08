;Copied from clipboard


;-
;---
;- Plot histgram
;-
;
;help, multiflare_struc.(0)[0]
;help, multiflare_struc.(0)[1]
;
fname = 'aia' + multiflare_struc.(0).channel  + '_hist'
;print, fname
;
;
ylog=1
xlog=1
;
xtitle='3-min power'
if xlog then xtitle = 'log ' + xtitle
ytitle='# pixels'
if ylog then ytitle = 'log ' + ytitle
;
;
title = ['pre-flare', 'flare', 'post-flare']
name = ['C3.0', 'M7.3', 'X2.2']
color = ['deep sky blue', 'green', 'dark orange', '']
;
wx = 8.5
wy = 3.0
resolve_routine, 'plot2', /is_function
;
for cc = 0, 1 do begin
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
    plt = objarr(3,3)
    for tt = 0, 2 do begin
        for ff = 0, 2 do begin
            plt[tt,ff] = plot2( $
                xdata[*,tt,ff,cc], $
                ydata[*,tt,ff,cc], $
                /current, $
                layout=[3,1,tt+1], $
                overplot=ff<1, $
                margin=0.18, $
                histogram=1, $
                xlog=xlog, $
                ylog=ylog, $
                ;yrange=[0.1, 10^(ceil(alog10(max(result)))) ], $
                ;xtickinterval=2e3, $
                name=name[ff], $
                color=color[ff], $
                ;xmajor=2, $
                xtickunits="scientific", $
                ytickunits="scientific", $
                ;xticklen=(0.20/wy), $
                ;yticklen=(0.20/wx), $
                title=title[tt], $
                xtitle=xtitle, $
                ytitle=ytitle, $
                font_size=9, $
                xtickfont_size=9, $
                ytickfont_size=9, $
                buffer=buffer $
            )
        endfor
        leg = legend2( target = plt[tt,*], /upperright )
    endfor
    save2, fname[cc], /add_timestamp
    stop
endfor

end

