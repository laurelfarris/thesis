;; Last modified:   13 May 2018 14:10:33


goto, start


; string array of t_obs in   ?   form....
t_obs = aia1700index.t_obs
time = strmid( t_obs, 11, 11 )

; Use observation time from header to get individual time values
timestamptovalues, t_obs, $
    day=day, $
    hour=hour, $
    minute=minute, $
    month=month, $
    offset=offset, $
    second=second, $
    year=year

; Covert observations times to JD
jd = julday(month, day, year, hour, minute, second)

;  Is there a way to read in the input data type at beginning
;  of subroutine, then convert back to that at the end?

dt = jd - shift(jd,1)
dt = dt * 24 * 3600
dt = round(dt)
dt = fix(dt)

cadence = 24

;; There is a gap between i-1 and i.
interp_coords = ( where(dt ne cadence) )

if n_elements(interp_coords) gt 1 then begin

    ; Create interpolated images and put them in the data cube in
    ; DESCENDING order to preserve the indices of the missing data.
    descending = (interp_coords[reverse(sort(interp_coords))])[0:-2]

    foreach i, descending do begin

        ; Could actually use MEAN here...
        missing_time = ( jd[i-1] + jd[i] ) / 2.
        jd = [ jd[0:i-1], missing_time, jd[i:-1] ]

    endforeach

endif

; Convert jd back to form hh:mm:ss...
; Use CALDAT, then TIMESTAMP to do this (I think).
;  Actually can't use timestamp - error that func/pro is undefined.


; Calculate month, day, etc. for jd after missing values were added.
caldat, jd, month, day, year, hour, minute, second

; Use new month, day, etc. arrays to get new timestamps.
; Compare values to original (should be the same almost everywhere).
; interp_coords for AIA 1700 are 149, 298, 447, and 596


; Getting error here, but .com timestamp works just fine.
; My guess is that timestamp was once a procedure (like plot),
; or some similar bullshit.
;resolve_routine, 'timestamp';, /is_function
;result = timestamp( $
;    day=day, $
;	hour=hour, $
;	minute=minute, $
;	month=month, $
;    second=second, $
;    year=year)



; I'll do it myself. Dicks.


; NOTE: hour and minute are both LONG,
; but second is DOUBLE (many decimal places).
; Leaving second out for now...
; Still PLOTTING each channel as function of its own jd.
; Time is just for labeling the figures.


; TEST: if N not the same for all three of the above, there's a problem.
test = indgen(10)
NH = n_elements(hour)
NM = n_elements(minute)
NS = n_elements(second)
if (NM ne NH) OR (NS ne NH) OR (NM ne NS) then print, "Problem!" else N=NH

; How to deal with seconds?

hour_string = strtrim(hour,1)
minute_string = strtrim(minute,1)
second_string = strtrim( fix(second),1)

; create string array of the two digits that comprise the nearest 100th
;   of each value in second array.
dec = strtrim( fix((second - fix(second))*100), 1)


; Append '0' to values with only one digit
for i = 0, N-1 do begin
    if strlen(hour_string[i]) eq 1 then $
        hour_string[i] = '0' + hour_string[i]
    if strlen(minute_string[i]) eq 1 then $
        minute_string[i] = '0' + minute_string[i]
    if strlen(second_string[i]) eq 1 then $
        second_string[i] = '0' + second_string[i]
    second_string[i] = second_string[i] + '.' + dec[i]
endfor



new_time = hour_string + ':' + minute_string + ':' + second_string
stop
; success!


; Appending 'Z' seems to work just fine!
s1 = aia1600index.date_obs + 'Z'
s2 = aia1600index.t_obs
JDtest = get_jd( s1 )

;--------------------------------------------------------------------------
; Read in full disk data for first image only:

path = '/solarstorm/laurel07/Data/AIA/'

channel = '1600'
files = '*aia*' + channel + '*2011-02-15*.fits'
fls = (file_search(path + files))[0]
READ_SDO, fls, index, aia1600full

channel = '1700'
files = '*aia*' + channel + '*2011-02-15*.fits'
fls = (file_search(path + files))[0]
READ_SDO, fls, index, aia1700full

full = [ [[ aia1600full ]], [[ aia1700full ]] ]

;pro image_color, A, data

    ;common defaults
    ;t_array = [ ' 00:00:42.57 UT', ' 00:00:32.21 UT' ]

    sz = float( size( full, /dimensions ) )

    ; Coordinates (relative to full disk) from prep.pro
    x_center = 2400
    y_center = 1650
    x_length = 500
    y_length = 330
    x1 = x_center - x_length/2
    y1 = y_center - y_length/2
    x2 = x1 + x_length -1
    y2 = y1 + y_length -1

    wx = 8.5/2
    wy = wx * (sz[1]/sz[0]) * 2
    w = window( dimensions=[wx,wy]*dpi )
    im = objarr(2)
    for i = 0, 1 do begin
        ;crop = 200
        ;data = full[ crop:sz[0]-crop, crop:sz[1]-crop, i ]
        data = full[ *, *, i ]
        ;data = A[i].data[*,*,0]

        im[i] = image2( $
            data^0.5, $
            /device, $
            /current, $
            layout=[1,2,i+1], $
            margin=[0.75, 0.75, 0.2, 0.75]*dpi, $
            ;axis_style=0, $
            rgb_table=A[i].ct, $
            ;title=A[i].name + ' 2011-February-15 ' + t_array[i], $
            title=A[i].name + ' 2011-February-15 ' + A[i].time[0], $
            xtitle='X (arcseconds)', $
            ytitle='Y (arcseconds)', $
            name=A[i].name $
        )
        ; Change axis labels from pixels to arcseconds
        im[i].xtickname = strtrim(round(im[i].xtickvalues * 0.6),1)
        im[i].ytickname = strtrim(round(im[i].ytickvalues * 0.6),1)

        ; Draw rectangle around (temporary) area of interest.
        rec = polygon2( x1, y1, x2, y2, target=im[i])
    endfor
    save2, 'full_color_boxed.pdf'
;end


;--------------------------------------------------------------------------
START:;--------------------------------------------------------------------

; Initialize power array, to be calculated across entire time series
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
