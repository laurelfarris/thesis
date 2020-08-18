;Copied from clipboard


for ii = 0, sz[2]-1 do begin
    ydata[*,ii] = HISTOGRAM( $
        imdata[*,*,ii,cc], $
        min=min, $
        max=max, $
        omin=omin, $
        omax=omax, $
        nbins=nbins, $
;        binsize=binsize, $
        locations=locations $
    )
    xdata[*,ii] = locations
endfor
;
;ind = [1:499]
;- 18 August 2020 -- set min and max kws in call to HISTOGRAM function, which should
;-      accomplish the same thing, but tidier than cropping x|ydata in call to PLOT func.
;
;---
;- Plot histgram
;-
;
ylog=1
xlog=0
;
xtitle='3-min power'
if xlog then xtitle = 'log ' + xtitle
ytitle='# pixels'
if ylog then ytitle = 'log ' + ytitle
;
name = [ $
    'C3.0 pre-flare ' + bda_time[0], $
    'C3.0 flare '      + bda_time[1], $
    'C3.0 post-flare ' + bda_time[2], $
    'M7.3 pre-flare ' + bda_time[3], $
    'M7.3 flare '      + bda_time[4], $
    'M7.3 post-flare ' + bda_time[5], $
    'X2.2 pre-flare ' + bda_time[6], $
    'X2.2 flare '      + bda_time[7], $
    'X2.2 post-flare ' + bda_time[8] $
]
;
color = [ $
    'black', 'black', 'black', $
    'blue', 'blue', 'blue', $
    'red', 'red', 'red' $
]
;
wy = 8.5
wx = 8.5
dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
plt = objarr(sz[2])
resolve_routine, 'plot2', /is_function
for ii = 0, sz[2]-1 do begin
    plt[ii] = plot2( $
        xdata[*,ii], $
        ydata[*,ii], $
        /current, $
        layout=[3,3,ii+1], $
        margin=0.12, $
        overplot=0, $
        histogram=1, $
        xlog=xlog, $
        ylog=ylog, $
        xtickinterval=2e3, $
        name=name[ii], $
        font_size=9, $
        xtickfont_size=9, $
        ytickfont_size=9, $
        title=name[ii], $
        xtitle=xtitle, $
        ytitle=ytitle, $
        color=color[ii], $
        ;xmajor=4, $
        xtickunits="scientific", $
        ytickunits="scientific", $
        ;yrange=[0.1, 10^(ceil(alog10(max(result)))) ], $
        xticklen=(0.20/wy), $
        yticklen=(0.20/wx), $
        buffer=buffer $
    )
endfor
;
;leg = legend2( target = plt, /upperright )
;
save2, fname, /add_timestamp

end

