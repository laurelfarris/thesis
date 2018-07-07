
; Initialize power array, to be calculated across entire time series:

; for integrated flux (only run this once!)
power = fltarr(n_elements(A[0].flux))
aia1600 = create_struct( aia1600, 'power', power )
aia1700 = create_struct( aia1700, 'power', power )
A = [ aia1600, aia1700 ]
stop


dz = 64
z_start = [0 : n_elements(A[0].power)-dz]

; Calculate possible frequencies for dz.
f_min = 0.005
f_max = 0.006
frequency = (reform( fourier2( indgen(dz), A[0].cadence, /NORM )))[0,*] 
ind = where( frequency ge f_min AND frequency le f_max )
stop

; Calculate power for time series between each value of z and z+dz
for j = 0, 1 do begin
    foreach z, z_start, i do begin
        result = fourier2( A[j].flux[z:z+dz-1], A[j].cadence, /NORM ) 
        power = reform( result[1,*] )
        ; MEAN power over dz and d\nu = frequency[ind]
        ; Adjust to, e.g. power per second ?
        A[j].power[i] = MEAN( power[ind] )
    endforeach
endfor
stop

; C-class flare
t_start = '00:30'
t_end   = '01:00'
date_obs = strmid( A[0].time, 0, 5 )
i1 = (where( date_obs eq t_start ))[ 0]
i2 = (where( date_obs eq t_end   ))[-1]
xdata = [i1:i2]
xname = date_obs[i1:i2]
stop


; Little things that change when switching from lightcurve to power.
; Could use either arrays or if statements depending on value of k.
; Or, once this becomes a procedure, these values could be the arguments.

;k = 0 ; lightcurve
;k = 1 ; power
ytitle = [ 'counts (DN)', 'power (normalized)' ]
ydata = [ $
    [[ A.flux_norm ]], $
    [[ A.power ]] ]

for k = 0, 1 do begin  ;***

if k eq 0 then margin=[1.00, 0.00, 0.10, 0.75]*dpi
if k eq 1 then margin=[1.00, 0.75, 0.10, 0.00]*dpi

; create window, graphic array(s)
if k eq 0 then begin
    wx = 8.5
    wy = 3.0 * 2
    w = window( dimensions=[wx,wy]*dpi, location=[600,0] )
endif

p = objarr(2)
for i = 0, 1 do begin

    ;; ydata - the main thing that changes.

    ; Why not just put this before starting the loop?
    ; There's probably a reason, but no comments to explain it...
    if i eq 0 then begin
        graphic = plot2( $
            xdata, ydata[*,i,k], /nodata, /current, /device, $
            layout=[1,2,k+1], $
            margin=margin, $
            ;xtickinterval=12, $
            ;xtickinterval=75, $
            xticklen=0.05, $
            yticklen=0.015, $
            xtitle='t_obs (UT) on 2011 February 15', $
            xshowtext=k, $
            ytitle=ytitle[k] )
    endif

    p[i] = plot2( $
        xdata, ydata[*,i,k], /overplot, $
        stairstep=0, $
        color=A[i].color, $
        name=A[i].name )
endfor

ax = graphic.axes
; tickvalues on ax[0] are the indices for the correct time array
ax[0].tickname = date_obs[ ax[0].tickvalues ]
;ax[2].minor = 5 ; should be 4, and maybe not necessary at all.
ax[2].title = 'index'
if k eq 0 then ax[2].showtext = 1

endfor ;***


leg = legend2( target=[ p[0], p[1] ] , $
    /relative, $ ; to bottom panel
    ;position=[(graphic.xrange)[1],(graphic.yrange)[1]] )
    position=[0.9,0.6] )


;v = plot( [i1,i1], graphic.yrange, /overplot, linestyle='-.', thick=1.5 )
;v = plot( [i2,i2], graphic.yrange, /overplot, linestyle='-.', thick=1.5 )



;--------------------------------------------------------------------------

; Compare power for total flux vs. total power over power map
; test using corner of AIA 1700 (non-flaring)

; Don't know why I showed images... not important
im = image2( test[*,*,0], layout=[1,2,1] )
im = image2( testmap[*,*,0], /current, layout=[1,2,2] )



crop = 10
testdata = A[1].data[ 0:crop-1, 0:crop-1, * ]
testz = [0:600]

; power based on total flux
testflux = total( total( testdata,1 ), 1 )
testpower1 = []

foreach z, testz, i do begin
    result = fourier2( testflux[z:z+dz-1], 24, /NORM ) 
    power = reform( result[1,*] )
    testpower1 = [ testpower1, MEAN( power[ind] ) ]
endforeach


; power based on total of power map
testmap = power_maps( testdata, z=testz, dz=64, cadence=24 )
testpower2 = total( total( testmap,1 ), 1 )

stop



testx = indgen(601)
p = plot2( testx, testpower1, color='blue' )
p = plot2( testx, testpower2, /overplot, color='red' )


end
