;; Last modified:   18 May 2018 01:52:38




pro test

    ; test that overplotting arrays of different sizes still plots them
    ; at the correct values the way I think they should.

    x1 = indgen(10)
    y1 = x1^2

    x2 = [2:7]
    y2 = x2^2 + 10

    p1 = plot2( x1, y1, color='blue' )
    p2 = plot2( x2, y2, /overplot, color='red' )

    ; Yes they do. I'll need this for comparing power vs. freq plots
    ; for a variety of sample times, since the returned frequency arrays
    ; will not only be of different lengths, but also have different values.
end

pro test2

    N = 100000
    x = indgen(N)
    y1 = randomu( seed, N ) 
    y2 = randomn( seed, N ) 
    print, min(y2)
    print, max(y2)
    stop

    p1 = plot2( x, y1, color='blue' )
    p2 = plot2( x, y2, color='red', /overplot )

    leg = legend2( target=[p1,p2] )

end



goto, start

test
stop

; nspikes = 0 for both channels, so this isn't useful
nspikes = aia1700index.nspikes
print, n_elements( where( nspikes ne 0 ))
print, ( where( nspikes ne 0 ))
stop

test2
stop



;----------------------------------------------------------------------------------
; movie of power maps during main flare, including maps at edges that
; overlapped with flare time.

map = A[0].map2 * new_map
xstepper, map[*,*,225:345]
; Not much to see...  also I meant to multiply by map_mask... oops.


ind = array_indices( map, where( map gt 0 ) )
test = map
test[ where( map eq 0 ) ] = max(map)
test2 = test[*,*,-1]
print, (n_elements( where( test2 ge 1 AND test2 lt 2 ))) / $
    float(n_elements( test2 ))


; time array in 'hh:mm' format 
time = strmid( aia1600index.date_obs, 11, 5 )


; Estimate most enhancement should be between 1:45 and 1:55
; Showing map centered around that (1:37 - 2:02)
z = (where( time eq '01:45' ))[0] - 20

; mask_map calculated for AIA 1600 only...
; broke away at this point to write subroutine (in saturation.pro)
; to caclulate new mask cube for both channels at new threshold.
A[0].map2 = A[0].map2 * mask_map
A[1].map2 = A[1].map2 * mask_map
print, n_elements( where( A[1].map2 eq 0 ))
print, n_elements( where( A[1].map2 eq 0 ))
stop

map = A[0].map2 * mask_map
temp = map[*,*,z]
temp_time = time[z:z+dz-1]

; Histogram to show distribution of values
print, max(temp)-min(temp)



n = 1000
result = histogram( temp, nbins=n ) 
increment = max(temp)/n
; xdata has length n+1, so trimming off the first value
xdata = indgen(n)
xdata = ([0.0:max(temp):increment])[1:*]

i = 100
p = plot2( $
    xdata[ i:*], $
    result[i:*], $
    ylog=1, $
    ;xrange=[100,max(temp)], $
    ;xrange=[min(temp),max(temp)], $
    title='AIA 1600 power map during flare' $
    )



n = 1000
result = histogram( temp, nbins=n ) 
increment = max(temp)/n
; xdata has length n+1, so trimming off the first value
xdata = indgen(n)
xdata = ([0.0:max(temp):increment])[1:*]

i = 100
i = 0
p = plot2( $
    xdata[ i:*], $
    result[i:*], $
    ;ylog=1, $
    ;xrange=[100,max(temp)], $
    ;xrange=[min(temp),max(temp)], $
    title='AIA 1600 power map during flare' $
    )


stop

print, result[200: 400]
; mostly between 0 and 100 (max = 0 because of saturation).

print, n_elements(temp)
print, n_elements( where( temp ge 100 ))
stop


; Aside from saturation (0.0), what's the min value of power map?
test = temp
test[ where(temp eq 0) ] = 100
print, min(test)
print, max(test)

;ind = array_indices( where( temp ne 0 ))
stop


;----------------------------------------------------------------------------------
; Graphics

; values from when I accidentally squared the map
max_value=300
max_value=100
max_value=max(temp)
max_value=200
max_value=50

; only part of AR that looks like something might be happening
temp2 = temp[105:160,130:200]


; After correcting mask situation..
map = [ $
    [[ A[0].map2[*,*,z]  ]], $
    [[ A[1].map2[*,*,z]  ]] $
    ]
map_time = [ $
    [ A[0].time[z:z+dz-1]], $
    [ A[1].time[z:z+dz-1]] $
    ]

;print, max(map[*,*,0]), max(map[*,*,1])
;endforeach



temp = map[*,*,0]
for i = 0, max(temp)+1 do begin
    ;print, i, n_elements(where(temp ge i AND temp lt i+1))
    n = float(n_elements(where(temp le i)))
    print, i, n/n_elements(temp)
endfor
stop

z = (where( time eq '01:45' ))[0] - 20

test = A[0].flux[0:150]
peak = (where(test eq max(test)))[0]
;z = [ peak-(dz/2):peak+(dz/2)-1 ]
;z = peak - (dz/2)
print, peak
stop

xtickname = strtrim([50:350:50],1)
ytickname = strtrim([-340:-140:50],1)




z_start = [ 0,58,130,241,320,440,510,590,660 ]
rows = 3
cols = 3
max_value = 10

for k = 0, 1 do begin

;time = strmid(A[k].time,0,5)
time = A[k].time

wx = 8.5
wy = wx * (330./500.)
w = window( dimensions=[wx,wy]*dpi, location=[500,0] )

im = objarr(rows*cols)
foreach z, z_start, i do begin

    title=time[z] + ' - ' + time[z+dz-1] + ' UT'
    map = A[k].map2[*,*,z] 

    im[i] = image2( $
        map, $
        /current, $
        /device, $
        layout=[cols,rows,i+1], $
        margin=[0.3, 0.3, 0.0, 0.6]*dpi , $
        max_value=max_value, $
        rgb_table=A[k].ct, $
        xmajor=n_elements(xtickname), $
        ymajor=n_elements(ytickname), $
        xshowtext=0, $
        yshowtext=0, $
        xtitle='X (arcseconds)', $
        ytitle='Y (arcseconds)', $
        title=title $;A[k].time[z] + '-' + A[k].time[z+dz-1] + ' UT' $
        )
    xoff = -0.03
    yoff = 0.0
    ;im[i].xtickname=xtickname
    ;im[i].ytickname=ytickname
    pos = im[i].position
    if (i eq 0 OR i eq 3 OR i eq 6) then $
        im[i].position = pos + [xoff,yoff,xoff,yoff]
    if (i eq 1 OR i eq 4 OR i eq 7) then $
        im[i].position = pos + 2.0*[xoff,yoff,xoff,yoff]
    if (i eq 2 OR i eq 5 OR i eq 8) then $
        im[i].position = pos + 3.0*[xoff,yoff,xoff,yoff]
endforeach

cx1 = (im[8].position)[2] + 0.01
cy1 = (im[8].position)[1]
cx2 = cx1 + 0.03
cy2 = (im[2].position)[3]
c = colorbar2( $
    target=im[0], $
    major=11, $
    minor=4, $
    tickformat='(I0)', $
    position=[cx1,cy1,cx2,cy2], $
    title='3-minute power' $
    )
endfor

;cont = contour( $
;    temp, $
;    /overplot, $
;    c_value=1.0e-6, $
;    c_label_show=0, $
;    color='white' )


START:;---------------------------------------------------------------------------------
stop
save2, 'powermap_6.pdf'



end
