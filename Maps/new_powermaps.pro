;+
;- 21 April 2019
;- Copied "image_central_freq_powermaps.pro"
;-
;- TO DO:
;-   [] See the bottom half of this code for some generalizing attempts,
;-        including imaging maps, and how it's different from imaging other things.
;-   []Later, combine with other codes that computed maps at just a few values of
;-     z_start and/or fcenter


goto, start


cc = 1

fcenter = 1./180
bandwidth = 0.001
dz = 64
time = strmid( A[cc].time, 0, 5 )
sz = size( A[cc].data, /dimensions )

;____________________________________________________________________________________

;- 22 April 2019
;- ALL the powermaps through time series:
;- Setting this up to run for AIA 1600 before leaving.
;-  Expect it to take 6-7 hours.

z_start = [0:sz[2]-dz]
;help, n_elements(z_start)
;print, n_elements(z_start)
;print, 'aia' + A[cc].channel + 'map.sav'

nn = n_elements(z_start)


map = COMPUTE_POWERMAPS( $
    A[cc].data, A[cc].cadence, $
    fcenter=fcenter, $
    bandwidth=bandwidth, $
    z_start=z_start, $
    dz=dz )

start:;-----------------------------------------------------------------------------
save, map, filename = 'aia' + A[cc].channel + 'map.sav'

stop
;____________________________________________________________________________________


;- All variables are arrays of size nn, even if all elements
;-  are equal to the same value for variables that don't change.
;-  Just need a general way to determine how "nn" is defined.
;- Go through each array, >if n_elements NE nn then replicate(...) ??


t_start = ['12:10', '12:40', '13:10']
;-   NOTE: this time array does NOT typically consist of start/end times of my
;-     data series or GOES start/peak/end times (though it could).
;-     It's specific to powermaps, which is why this line is here and not read
;-    from @parameters... tho maybe it should be??


z_start = intarr(nn)
for ii = 0, nn-1 do $
    z_start[ii] = (where(time eq t_start[ii]))[0]

stop

;- Not needed for compute_powermaps.pro, but maybe for plotting power spectra?
;fmin = fcenter - (bandwidth/2.)
;fmax = fcenter + (bandwidth/2.)

;- Only need to initialize map if looping through several values of fcenter.
;sz = size(data, /dimensions)
;map = fltarr(sz[0],sz[1],nn)

for ii = 0, 0 do begin
    map = COMPUTE_POWERMAPS( $
        A[cc].data, A[cc].cadence, $
        fcenter=fcenter[ii], $
        bandwidth=bandwidth, $
        z_start=z_start, $
        dz=dz )
endfor
;____________________________________________________________________________________




format='(E0.2)'
;print, min(map[*,*,0]), format=format
;print, min(map[*,*,1]), format=format
;print, min(map[*,*,2]), format=format
;print, max(map[*,*,0]), format=format
;print, max(map[*,*,1]), format=format
;print, max(map[*,*,2]), format=format
;stop

;??
;print, min(map)
;map = map > 0


;- Imaging of power maps
;- "1600$\AA$ 5.6 mHz (00:00-00:25)"
title = strarr(nn)
for ii = 0, nn-1 do begin
    title[ii] = $
        ;A[cc].channel + $
        A[cc].name + $
        ' ' $
        ;+ strmid(fcenter[ii],0,3) $
        + '@' $
        + '5.6' $ ; placeholder for now b/c of extra whitespace in strmid(fcenter..)
        + ' mHz' + ' (' + t_start[ii] + '-' + time[ z_start[ii]+dz-1] + ' UT)'
endfor
;print, title
;for ii = 0, nn-1 do begin
;    str = strtrim( (1000./period[ii]), 1)
;    str = strmid(str, 0, 3) 
;    title[ii] = A[cc].name + ' ' + $
;        ;strtrim(fcenter[ii]*1000, 1) + ' mHz ('  + $
;        '@' + str + ' mHz' + $
;        ' (' + time[z_start] + '-' + time[z_start+dz-1] + ' UT)'
;    print, title[ii]
;endfor

;stop

;- Testing image.... maybe separate "props" structure would be helpful
;im = image2( $
;    alog10(map[*,*,0]), $
;    layout=[1,1,1], $
;    margin=0.1, $
;    rgb_table=A[0].ct, $
;    title=title[0] )



sz = size(A[cc].data, /dimensions)
composite_images = dblarr(sz[0], sz[1], nn)
for ii = 0, nn-1 do begin
    composite_images[*,*,ii] = mean( $
        A[cc].data[*,*, z_start[ii] : z_start[ii]+dz-1 ], dim=3 )
endfor

imdata = AIA_INTSCALE( $
    composite_images, $
    ;A[cc].data[*,*, z_start] * A[cc].exptime, $
    wave = fix(A[cc].channel), $
    exptime = A[cc].exptime )

immap = alog10(map)


rows=3
cols=1
wx = 4.0
wy = 8.0
left   = 0.25
bottom = 0.25
right  = 0.25
top    = 1.00


win = window( dimension=[wx, wy]*dpi, location=[1200,0] )
im = objarr(nn)

for ii = 0, nn-1 do begin
    im[ii] = image2( $
        ;imdata[*,*,ii], $
        immap[*,*,ii], $
        /current, $
        ;/device, $
        layout=[cols,rows,ii+1], $
        margin = 0.1, $
        axis_style=0, $
        min_value=0, $
        ;margin = [left, bottom, right, top]*dpi, $
        rgb_table = A[cc].ct, $
        title=title[ii] )
endfor
;cbar = colorbar2( target = im )

stop

;file = 'aia' + A[cc].channel + 'fcenter.pdf'
;file = 'newflare_aia' + A[cc].channel + 'images'
file = 'newflare_aia' + A[cc].channel + 'maps'
save2, file
stop

;-
;- What makes this code different from imaging anything else?
;-     min_value/max_value
;-     title --> range of time covered to produce power map
;-     room for colorbar

end
