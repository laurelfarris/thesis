function IMAGE_POWERMAPS, $
    map, $
    rows=rows, $
    cols=cols, $
    titles=titles, $
    _EXTRA=e

    common defaults
    ;resolve_routine, 'colorbar2', /either
    resolve_routine, 'get_position', /either

    sz = size(map, /dimensions)

    wx = 8.5
    wy = wx * (float(rows)/cols) * (float(sz[1])/sz[0])
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    width = 2.5
    height = width * float(sz[1])/sz[0]

    left=0.5
    top=0.5
    xgap=1.00

    ;- appears that setting right and bottom margins is pointless,
    ;- at least with the way my subroutines are currently set up.
    ;- (also images have preserved aspect ratio... this may not
    ;- be the case for plots.)

    im = image3( map, $
        xshowtext=0, $
        yshowtext=0, $
        ;min_value=1.2*min(map), $
        ;max_value=0.5*max(map), $
        title=titles )

    cbar = colorbar3( target=im )

    return, im
end


goto, start

;- 01 December 2018
;- when does post-peak emission fall to half peak-background?
cc = 0
bg = mean(A[cc].flux[125:259])
;flux = A[0].flux[260:375]
flux = A[cc].flux
delt = (max(flux)-bg)
flare_end = bg + 0.5*delt
ind = where( flux ge flare_end )
stop


;-------------------------------------------------------------------------------------------------------
;- 18 October 2018
;-
;- Power maps:
;-   Multiply power maps by mask, which can be created using any threshold.
;-   Compare same power map using multiple thresholds.
;-   Show images used to compute maps: ruNMing average? standard deviation?
;-   How should power maps be scaled visually?  @methods
;-
;- Copy FT bit with fcenter to some other fourier related subroutine.

start:;-------------------------------------------------------------------------------------------------

fcenter = 1./180
bandwidth = 0.001
fmin = fcenter - (bandwidth/2.)
fmax = fcenter + (bandwidth/2.)


;- 'NM' = Number of Maps
NM = 9
dz = 64
;t0 = '01:05'
;t0 = '01:23'
; 01:23 - 02:34 --> z = 207 - 386

t0 = '00:24'
;---

time = strmid(A[0].time, 0, 5)
z0 = (where( time eq t0 ))[0]
zf = z0 + NM*dz - 1
z_ind = [z0:zf]
print, ''
print, time[z_ind[0]]
print, time[z_ind[-1]]
stop

data = A.data[*,*,z_ind,*]
sz = size(data, /dimensions)

;-  Test: third dimension should = dz*NM
if sz[2] ne dz*NM then begin
    print, "Numbers don't match."
    stop
endif

;mask1 = fltarr(sz)
;threshold = 10000
;mask1[where( data lt threshold )] = 1.0
;mask1[where( data ge threshold )] = 0.0
;sat = where(mask1 eq 0.0)
;unsat = where(mask1 eq 1.0)

titles = []
for cc = 0, 1 do begin
    for ii = 0, NM-1 do begin
        ind = indgen(dz) + z0 + (dz*ii)
        titles = [ titles, $
            A[cc].channel + '$\AA$ ' + $
            time[ind[0]] + '-' + time[ind[-1]] ]
        CONTINUE
        print, "CONTINUE didn't work"
    endfor
endfor

titles = 'AIA ' + titles + ' UT'
titles = reform( titles, NM, 2)
foreach t, titles do print, t
stop ;---


;-  Calculate power maps and saturation mask together

map   = fltarr( sz[0], sz[1], NM, 2)
;mask2 = fltarr( sz[0], sz[1], NM, 2)

resolve_routine, 'powermaps', /either
for cc = 0, 1 do begin
    for ii = 0, NM-1 do begin
        ind = indgen(dz) + z0 + (dz*ii)
        map[*,*,ii,cc] = POWERMAPS( $
            A[cc].data[*,*,ind], $
            A[cc].cadence, fmin=fmin, fmax=fmax )
        ;mask2[*,*,ii,cc] = PRODUCT( mask1[*,*,ind,cc], 3 )
    endfor
endfor
stop ;---


;-
;- 'sat' = cube same size as data equal to 0s and 1s
sat = fltarr( sz[0], sz[1], NM, 2)

for cc = 0, 1 do begin
    for ii = 0, NM-1 do begin
        ind = indgen(dz) + z0 + (dz*ii)
        mask[*,*,ii,cc] = PRODUCT( mask1[*,*,ind,cc], 3 )
    endfor
endfor
stop ;---
resolve_routine, 'save2', /either
for cc = 0, 1 do begin

    image_data = alog10(map[*,*,*,cc])
    ;image_data = AIA_INTSCALE( map[*,*,*,cc], wave=fix(A[cc].channel), exptime=A[cc].exptime )
    ;image_data = (map[*,*,*,cc])^0.2
    im = IMAGE_POWERMAPS( $
        image_data, $
        min_value = min(image_data), $
        max_value = max(image_data), $
        rows = 4, $
        cols = 2, $
        rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ), $
        titles = titles[*,cc] )

    file = 'aia' + A[cc].channel + 'map_45.pdf'
    save2, file
endfor
stop


;time = strmid(A[ii].time,0,8)
;index = indgen(n_elements(time))
;time_range = time + '-' + shift(time, -(dz-1)) + ' (' + strtrim(index,1) + '-' + strtrim(shift(index, -(dz-1)), 1)  + ')'
;time_range = time_range[ 0 : sz[2]-1 ]
;ind = [ 0 : sz[2]-1 : 40 ]

;-  power_maps.pro is written to take entire data set and an array of starting indices.
;-  This is probably faster than passing hugs arrays back and forth when computing a bunch of maps...
;-  not sure what the best coding practice would be in this case, if there even is one.
;-  kws are optional: if z isn't specified then default is to start at index 0
;-  and if dz isn't set then map is calculated over entire data cube.

dw
win = window(/buffer)
for ii = 0, 3 do begin
    im = image2( mask2[*,*,ii,0], /current, $
        layout=[2,2,ii+1], margin=0.1, $
        title = 'mask map' )
endfor
save2, 'saturation_mask.pdf'
stop
end

end
