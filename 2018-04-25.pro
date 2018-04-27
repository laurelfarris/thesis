;; Last modified:   24 April 2018 16:14:34

goto, start


; Images - label axes with arcsec

ax[2].tickname = strtrim(round(ax[0].tickvalues * 0.6),1)

; Put mini tests everywhere!

; AIA 304 data (April 10)


; Movie actually runs faster when window is smaller

; 1700 easier to see at the current scale
temp = A[1].map
xstepper2, temp^0.5, scale=0.75, subscripts=[0:250]
; Have I done this yet? Made a bunch of images, but I don't think I ever
; looked at a movie of the power maps... not sure how that slipped my mind.

; Trim depending on where enhancement is
x1=0
y1=0
x2=499
y2=329
temp = temp[x1:x2,y1:y2,*]

; No movement:
composite = TOTAL( temp, 3 )
w = window2()
im = image2( $
    composite, $
    /current, /device, $
    layout=[1,1,1], margin=[1.0, 0.75, 0.25, 0.25], $
    xtitle='X (pixels)', $
    ytitle='Y (pixels)', $
    title=A[1].name $
)
; Only way this differs from regular images is the data itself and the color bar.
; Even the data dimensions and axis labels are the same.

; Movement: Just describe in Conclusions for now.



; Another thing to be done LATER:
dz = 10
period = 1./((fourier2( indgen(dz), 24 ))[0,*])
stop


start:;------------------------------------------------------------------------------

z = [0:680:5]
tc = A[0].time[z+32]

ind = [33:77:3]
tc = tc[ind]
nc = z[ind] + 32

; Probably don't need loop here.
;title=[]
;for i = 0, 14 do $
    ;title=[ title, tc[i]+'   (' + strtrim(nc[i],1) + ')' ]
title=[ tc + '   (' + strtrim(nc,1) + ')' ]


; IDL> .com graphics
; IDL> graphics
; IDL> .run today
;    common defaults
;  --> dpi is "already defined with a conflicting definition"
; I'm starting to remember why I quit using common blocks...
; Seem to recall some issue with trying to call a defined block
; at the main level.

xoff = -0.05
yoff = 0.0

;map = (A[1].map[*,*,ind])^0.5


map = (A[1].map[*,*,5:19])^0.5
i = 0
max_value = 1700
cols = 3
rows = 5
im = objarr(cols,rows)
w = window2( dimensions=[8.5,9.0]*dpi )
for y = 0, rows-1 do begin
for x = 0, cols-1 do begin
    im[x,y] = image2( $
        map[*,*,i], $
        layout=[cols,rows,i+1], $
        margin=[0.1, 0.1, 1.50, 0.75]*dpi, $
        /current, /device, $
        ;max_value=max_value, $
        ;max_value=
        title=title[i], $
        axis_style=0, $
        ;rgb_table=39, $
        rgb_table=A[1].ct, $
        _EXTRA=e )
    im[x,y].position = $
        im[x,y].position + [x*xoff, y*yoff, x*xoff, y*yoff]
    i = i + 1
    max_value = max_value - 100
endfor
endfor

im_lower = im[cols-1,rows-1]
im_upper = im[cols-1,0]
cx1 = (im_lower.position)[2] + 0.01
cy1 = (im_lower.position)[1]
cx2 = cx1 + 0.03
cy2 = (im_upper.position)[3]
c = colorbar2( position=[cx1,cy1,cx2,cy2], $
    tickformat='(I0)', $
    major=11, $
    title='3-minute power^0.5' )
    ;range=[0,mx], $  mx = ??
stop

temp = total(map, 3)
im = image( temp, layout=[1,1,1], margin=0.05, rgb_table=A[1].ct )

wx = 8.5
wy = wx * (330./500.) * 2
w = window( dimensions=[wx,wy]*dpi )

for i = 0, 1 do begin
    map = (A[i].map[*,*,5:19])^0.5
    temp = total(map, 3)
    im = image2( $
        temp, $
        /current, $
        /device, $
        layout=[1,2,i+1], $
        margin=1.0*dpi, $
        xtitle='X (pixels)', $
        ytitle='Y (pixels)', $
        rgb_table=A[i].ct, $
        title=A[i].name $
        )
endfor
stop



;resolve_routine, 'graphics', /compile_full_file
dpi = 96

cols=4
rows=5

;margin=[1.0, 1.0, 0.2, 0.2 ] * dpi
margin=[0.2, 0.2, 0.1, 0.1]
;margin=0.0

signal = randomn(seed, 500)

xdata = indgen(n_elements(signal))
dz = 25
w = window2( dimensions=[10.0,11.0]*dpi, location=[0,0] )
for i = 0, rows*cols-1 do begin
    p = plot2( xdata, signal[0:dz-1], $
        /current, $
        ;/device, $
        layout=[cols,rows,i+1], $
        margin=margin, $
        title='dz=' + strtrim(dz,1), $
        xtitle='time', $
        ytitle='flux', $
        ;xshowtext=0, ;yshowtext=0, $
        color='blue' $
        )
    dz = dz + 1
endfor



; create a little subroutine for window?
; Shouldn't ever have to change the same values in two
; different places like this!

dz = 25
w = window2( dimensions=[10.0,11.0]*dpi, location=[800,0] )
for i = 0, rows*cols-1 do begin
    result = fourier2( signal[0:dz-1], 24. )
    frequency = reform(result[0,*]) * 1000
    df = frequency[1]-frequency[0]
    power = reform(result[1,*])
    ;print, max(power), min(power)
    p = plot2( frequency, power, $
        /current, $
        ;/device, $
        layout=[cols,rows,i+1], $
        margin=margin, $
        title='dz=' + strtrim(dz,1) + '; df=' + strtrim(df,1), $
        xtitle='frequency (mHz)', $
        ;ytitle='Power', $
        ;xrange=1000./[220.,150.], $
        ;xrange=[4.8,6.3], $
        ;yrange=[0.0, 0.35], $
        xmajor=4, $
        xtickformat='(F0.1)', $
        ytickformat='(F0.1)', $
        symbol='Circle', sym_filled=1, $
        sym_size=0.5, $
        color='red' $
        )
    ; or this...
    dz = dz + 1
endfor

i1 = (where( frequency gt 5.6 ))[ 0]
i2 = (where( frequency lt 5.6 ))[-1]


v = plot2( [5.6,5.6], p.yrange, /overplot, linestyle='--' )


; show image of AIA 1700 power maps to find non-saturated pixel
; that is enhanced a lot

end
