


;- 25 November 2018
;- P(t) plots

;- Rename this routine from 'today' to plot_power_time.pro, or something similar

goto, start

;- Testing different saturation threshold values.
common defaults
spike = A[0].data[200:230,45:65,280] * A[0].exptime
test = A[0].data[*,*,280]*A[0].exptime
threshold = [15000, 10000, 8000, 4000, 3000, 2000, 1000, 500]
rows=4
cols=2
wx = 8.5
wy = 11.0
win = window(dimensions=[8.5,11.0]*dpi, location=[500,0], $
    title='AIA 1600$\AA$  ' + A[0].time[280] + ' UT (280)' )
ii = 0
for yy = 0, cols-1 do begin
for xx = 0, rows-1 do begin
    position = get_position( layout=[cols,rows,ii+1], $
        left=1.25, top=1.0, xgap=0.1, ygap=0.40, width=2.75 )
    testmask = MASK(test, threshold=threshold[ii])
    im = image2( $
        test * testmask, $
        /current, $
        /device, $
        axis_style = 0, $
        position=position*dpi, $
        ;layout=[cols,rows,ii+1], $
        ;margin=0.1, $
        min_value=0, $
        title = 'Saturation threshold = ' + strtrim(threshold[ii],1), $
        rgb_table=A[0].ct)
        ii++
endfor
endfor
stop


start:;---------------------------------------------------------------------------------




end
