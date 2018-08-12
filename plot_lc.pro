


function PLOT_LC, $
    ind, $
    data, $
    time, $
    _EXTRA = e

    common defaults

    lc = PLOT2( $
            ind, ydata, $
            position=position*dpi, $
            xminor=5, $
            ymajor=7, $
            xticklen=0.025, $
            yticklen=0.010, $
            stairstep=1, $
            xshowtext=1, $
            yshowtext=1, $
            xtitle='index', $
        _EXTRA = e
    return, lc
end

win = WINDOW2()

file = 'lightcurve'
time = strmid(A[0].time,0,5)
ydata = A.flux
N = (size(ydata,/dimensions))[0]
xdata = [0:N-1]

ytitle = ['1600$\AA$ (DN s$^{-1}$)', '1700$\AA$ (DN s$^{-1}$)']

for i = 0, 1 do begin

    lc[i] = PLOT_LC( $
        xdata, ydata[*,i], time, $
        color=A[i].color, $
        ytitle = ytitle[i], $
        name=A[i].name )
endfor


v = OPLOT_FLARE_LINES( time, yrange=p[0].yrange, /send_to_back, color='light gray' )

    dz_axis = axis( $
        'X', $
        axis_range=[ dz, dz*2 ], $
        location=(p[0].yrange)[1] - 0.2*(p[0].yrange)[1], $
        major=2, $
        minor=0, $
        tickname=['',''], $
        title='$T=64$', $
        tickdir=1, $
        textpos=1, $
        ;tickdir=(i mod 2), $
        tickfont_size = fontsize )

p[1].GetData, x, y
ax = p[0].axes
ax[0].tickname = time[ax[0].tickvalues]
ax[0].title = 'Start time (UT) on 2011-February-15'
ax[1].title=ytitle[0]
ax[3].title=ytitle[1]
pos = p[0].position
leg = legend2(  $
    target=[p,v], /normal, $
    position = [ pos[2]*0.90, pos[3]*0.97 ], $
    ;position=[ position[2]-0.25, position[3]-0.25 ]*dpi, $
    sample_width=0.2)

save2, file + '.pdf' ;, /add_timestamp


end
