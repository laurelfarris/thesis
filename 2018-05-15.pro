;; Last modified:   15 May 2018 20:36:15


goto, start

; image power maps (after running them with /NORM and MEAN power over
; freq. bandpass.

; counter for array (0 for AIA 1600, 1 for AIA 1700).
k = 1

; data to show
temp = (A[k].map)^2
sz = size(temp, /dimensions)

z_start = [0:sz[2]:75]


; Window dimensions and creation
rat = ( 330./500. )
wx = 8.5*1.5
wy = ( wx * rat )
w = window( dimensions=[wx, wy]*dpi, location=[500,0] )

; Make images
for i = 0, 8 do begin

    im = image2( $
        temp[*,*,z_start[i]], $
        /current, $
        layout = [3,3,i+1], $
        margin = 0.1, $
        title = A[k].name + ' ' + A[k].time[z_start[i]], $
        xtitle = 'X (arcseconds)', $
        ytitle = 'Y (arcseconds)', $
        rgb_table = A[k].ct $
        )



endfor


; Both data and title use the same variable to pull index from,
; so better not display incorrect information here!


im.xtickname = strtrim(round(im.xtickvalues*0.6), 1)
im.ytickname = strtrim(round(im.ytickvalues*0.6), 1)




;------------------------------------------------------------------------
; Plot total power vs. time


w = window( dimensions=[8.5, 4.0]*dpi, location=[500,0] )


p = objarr(2)

for i = 0, 1 do begin
    y = total( total( A[i].map, 1 ), 1 )
    x = indgen( n_elements(y) )
    if i eq 0 then begin
        graphic = plot2( $
            x, y, /nodata, $
            /current, $
            /device, $
            layout=[1,1,1], $
            margin=[1.0, 0.75, 0.5, 0.5]*dpi )
    endif

    p[i] = plot2( $
        x, y, $
        /overplot, $
        color=A[i].color, $
        name=A[i].name ) 
endfor

leg = legend2( target=p )


; Little things that change when switching from lightcurve to power.
; Could use either arrays or if statements depending on value of k.
; Or, once this becomes a procedure, these values could be the arguments.

;; Put this somewhere! *******************
;aia1600 = create_struct( aia1600, 'power2', $
;    [ total( total( A[0].map, 1 ), 1 ), fltarr(dz) ])
;aia1700 = create_struct( aia1700, 'power2', $
;    [ total( total( A[1].map, 1 ), 1 ), fltarr(dz) ])
;A = [ aia1600, aia1700 ]
stop




; Probably simpler to define flux and power separately, and comment the
; one I'm not using (since I'm commenting between power and power2 anyway...)
;ydata = [ [[ A.flux_norm ]], [[ shift(A.power,  (dz/2) ) ]] ]
ydata = [ [[ A.flux_norm ]], [[ shift(A.power2, (dz/2) ) ]] ]


;------------------------------------------------------------------------------------

; C-class flare
t_start = '00:30'
t_end   = '01:00'


; Entire time series
t_start = '00:00'
t_end   = '04:59'

; String to label plot with date_obs from header.
date_obs = strmid( A[0].time, 0, 5 )
i1 = (where( date_obs eq t_start ))[ 0]
i2 = (where( date_obs eq t_end   ))[-1]
xname = date_obs[i1:i2]


; Flare start, peak, & end times; to be marked with vertical lines.
f1 = (where( date_obs eq '01:44'))[0]
f2 = (where( date_obs eq '01:56'))[0]
f3 = (where( date_obs eq '02:06'))[0]
f = [f1, f2, f3]

;; Graphics


; create window, graphic array(s)
wx = 8.5
wy = 3.0 * 2.0
w = window( dimensions=[wx,wy]*dpi, location=[600,0] )
p = objarr(3)

for k = 0, n_elements(p)-1 do begin  ;***

    ; Margin values for axes that are not on top of other axes.
    ; These are all you should have to change to adjust margins.
    left = 0.75
    bottom = 1.25
    right = 0.10
    top = 1.25

    ; Power - shift to plot as function of CENTRAL time, but no cropping here.

    ; power calculated from total(maps)
    if k eq 2 then $
        p0 = A[0].power2 * good_pix
        p1 = A[1].power2 * good_pix
        p_tot_map = [ [p0], [p1] ]
        ydata = shift(p_tot_map,  (dz/2) )
    ; power calculated from total(flux)
    if k eq 1 then begin
        ydata = shift(A.power,  (dz/2) )
        bottom = 0.0
    endif

    if k ge 1 then begin
        top = 0.0
        ytitle = 'power (normalized)'
        ; Trim zeros from edges of power.
        ; --> ONly need to do this for full light curve!
        ydata = ydata[32:716, *]
        xdata = [32:716]

        ; Only cover desired time
        ;ydata = ydata[i1:i2,*]

        ; normalize
        y0 = ydata[*,0]
        y0 = y0 - min(y0)
        y0 = y0/max(y0)
        y1 = ydata[*,1]
        y1 = y1 - min(y1)
        y1 = y1/max(y1)
        ydata = [ [y0], [y1] ]
    endif

    ; This requires k to start at 0, otherwise xdata is not defined.
    ; Lightcurves
    if k eq 0 then begin
        bottom = 0.0
        xdata = [i1:i2]
        ydata = A.flux_norm
        ytitle = 'counts (normalized)'
    endif

    margin = [ left, bottom, right, top ] * dpi

    for i = 0, 1 do begin

        ; Why not just put this before starting the loop?
        ; There's probably a reason, but no comments to explain it...
        ; Can use i to avoid hard coding data to use here..
        ; And also just easier to group stuff together... iono.

        if i eq 0 then begin
            graphic = plot2( $
                xdata, ydata[*,i], /nodata, /current, /device, $
                layout=[1,3,k+1], $
                margin=margin, $
                xtickinterval=100, $
                xrange=[i1,i2], $
                xticklen=0.05, $
                yticklen=0.015, $
                xtitle='Start time (UT) on 2011-February-15', $
                xshowtext=0, $
                ytickvalues=[2:10:2]/10., $
                ytickformat='(F0.1)', $
                ytitle=ytitle )

        endif


        ;if k ge 1 then begin
        if k ge 10 then begin  ;; sneaky way to comment :)
            ;yy1 = [ ydata[*,i], fltarr(dz) ]
            n = n_elements(ydata[*,i])
            yy1 = shift( ydata[*,i], -32 )
            yy1 = yy1[0:n-32]
            yy2 = shift( ydata[*,i],  32 )
            yy2 = yy2[32:*]
            q = plot2( xdata[0:n-32], yy1, /overplot, stairstep=1, color='light gray', $
                ;fill_background=1, fill_level=yy1, $
                name='t-dz' )
            q = plot2( xdata[32:*], yy2, /overplot, stairstep=1, color='light gray', $
                ;fill_background=1, fill_level=yy2, $
                name='t+dz' )
        endif

        p[i] = plot2( $
            xdata, ydata[*,i], /overplot, $
            stairstep=1, $
            color=A[i].color, $
            name=A[i].name )
    endfor
    yr = graphic.yrange
    v = plot( $
        [ f[0]-32, f[0]-32, f[-1]+32-1, f[-1]+32-1 ], $
        [ yr[0], yr[1], yr[1], yr[0] ], $
        ;graphic.yrange, $
        /overplot, $
        ystyle=1, $
        ;color='light gray', $
        linestyle=6, $
        fill_background=1, $
        fill_transparency=70, $
        fill_color='light gray' )

    ax = graphic.axes
    ax[0].tickname = date_obs[ ax[0].tickvalues ]
    ax[2].title = 'index'
    if k eq 0 then ax[2].showtext = 1
    if k eq n_elements(p)-1 then ax[0].showtext = 1

    ; vertical lines to show start/stop/peak
    ; (only for full time series though...)
    for j = 0, 2 do begin
        v = plot( [f[j],f[j]], graphic.yrange, /overplot, $
            ystyle=1, linestyle='-.', thick=1.5 )
    endfor

endfor ;***


leg = legend2( $
    target=[ p[0], p[1] ], $
    ;target=p, $
    position=[0.9,0.85] )




;save2, 'power_time_4.pdf'
;write_png, 'power_time_4.png', tvrd(/true)
w.save, '~/power_time_5.png', width=wx*dpi


stop

; Saturation

z = [0:684]
n = n_elements(z)
sat_arr = fltarr(n)
data = A[0].data

for i = 0, n-1 do begin
    for y = 0, sz[1]-1 do begin
    for x = 0, sz[0]-1 do begin
            
        flux = data[ x, y, z[i]:z[i]+dz-1 ]
        sat = [where( flux ge 15000. )]
        if not sat[0] eq -1 then begin
            sat_arr[i] = sat_arr[i] + 1
        endif

    endfor
    endfor
endfor



pixels = fltarr(n) + (500.*330.)

; Divide power2 by this array
good_pix = pixels / ( pixels - sat_arr )
good_pix = [ good_pix, fltarr(dz) ]




START:;------------------------------------------------------------------------------


; Make some structures here.


i = 0
res0 = fourier2( A[i].flux, NORM=0, 24 )
pow0 = reform( res0[1,*] )
res1 = fourier2( A[i].flux, NORM=1, 24 )
pow1 = reform( res1[1,*] )
res2 = fourier2( A[i].flux_norm, NORM=0, 24 )
pow2 = reform( res2[1,*] )
res3 = fourier2( A[i].flux_norm, NORM=1, 24 )
pow3 = reform( res3[1,*] )


frequency = reform(res0[0,*])
ind = where( frequency ge 0.005 AND frequency le 0.006 )
xdata = frequency[ind]

ydata = [ [pow0[ind]], [pow1[ind]], [pow2[ind]], [pow3[ind]] ]
p = objarr(4)


title = ['flux', 'flux, /NORM', 'flux_norm', 'flux_norm, /NORM']

color = [ 'black', 'blue', 'red', 'cyan' ]

for i = 0, 3 do begin
    p[i] = plot2( xdata, ydata[*,i], $
    title=title[i] $
    )
endfor

end
