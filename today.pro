;+
;- LAST MODIFIED:
;-   25 April 2019
;-
;-

goto, start

;- Idea:
;- All variables are arrays of size nn, even if all elements
;-  are equal to the same value for variables that don't change.
;-  Just need a general way to determine how "nn" is defined.
;- Go through each array, >if n_elements NE nn then replicate(...) ??
;- Should be same as sz[2] for map once computed.
;- Tho if using this for arrays that go INTO compute_maps... then nevermind.

;-   NOTE: this time array does NOT typically consist of start/end times of my
;-     data series or GOES start/peak/end times (though it could).
;-     It's specific to powermaps, which is why this line is here and not read
;-    from @parameters... tho maybe it should be??


;- power maps pre-flare, compare norm to no norm


;---- BDA power spectra for inegrated flux


start:;-------------------------------------------------------------------------

dw

for cc = 0, 1 do begin
for norm= 0, 1 do begin
;cc = 1
;norm = 1

time = strmid( A[cc].time, 0, 5 )
;fcenter = 1./180
;bandwidth = 0.001 ; --> default is 1 mHz

;t_start = ['12:10', '12:40', '13:10']
;dz = 64
t_start = ['11:45', '12:30', '13:15']
dz = 110

nn = n_elements(t_start)
z_start = intarr(nn)
for ii = 0, nn-1 do z_start[ii] = (where(time eq t_start[ii]))[0]


name = ['Pre-flare ', 'C3.0 flare ', 'Post-flare ']
nfreqs = dz/2
power = fltarr(nfreqs,nn)
frequency = fltarr(nfreqs,nn)

foreach zz, z_start, ii do begin
    result = fourier2( A[cc].flux[zz:zz+dz-1], A[cc].cadence, norm=norm )
    frequency[*,ii] = reform(result[0,*])
    power[*,ii] = reform(result[1,*])
    name[ii] = name[ii] + '(' + time[zz] + '-' + time[zz+dz-1] + ' UT)'
endforeach

;- fmin/max mostly for setting boundaries of spactra.
fmin = 2.0 / 1000.
fmax = 9.0 / 1000.
ind = where( frequency[*,0] ge fmin AND frequency[*,0] le fmax )
symbol = ['Diamond', 'Plus', 'Asterisk']
resolve_routine, 'plot_spectra', /either
plt = PLOT_SPECTRA( $
    frequency[ind,*], $
    alog10(power[ind,*]), $
    leg=leg, $
    ytitle = 'log power', $
    symbol=symbol, $
    sym_size=0.75, $
    buffer=0, label=1, $
    xtickinterval=1, $
    xminor=4, $
    yminor=4, $
    ytickinterval=1, $
    left=0.50, bottom=0.50, right=0.25, top=0.50, $
    wx=4.0, wy=4.0, $
    ystyle=2, $
    name=name )
if norm then plt[0].ytitle = plt[0].ytitle + ' (normalized)'


leg.position = [0.90, 0.87]

plt[0].aspect_ratio = $
    ((plt[0].xrange)[1] - (plt[0].xrange)[0]) / $
    ((plt[0].yrange)[1] - (plt[0].yrange)[0])

ax = plt[0].axes
ax[0].tickname = strtrim(fix(ax[0].tickvalues), 1)

aiatitle = TEXT2( 0.17, 0.87, A[cc].name, /normal, $
    alignment=0, vertical_alignment=1 )

filename = 'aia' + A[cc].channel + 'BDAspectra'
if norm then filename = filename + '_norm'
stop
save2, filename;, /stamp

endfor
endfor

stop


;mapcube = map
;
;;- Currently, if using multiple values of fcenter, compute_powermaps.pro
;;-  doesn't do that, so have to loop outside the subroutine.
;
;map = fltarr(sz[0],sz[1],nn)
;for ii = 0, 0 do begin
;    map[*,*,ii] = COMPUTE_POWERMAPS( $
;        A[cc].data, A[cc].cadence, $
;        fcenter=fcenter, $
;        ;fcenter=fcenter[ii], $
;        ;bandwidth=bandwidth, $
;        z_start=z_start, $
;        dz=dz, $
;        norm = norm )
;endfor
;
;;mapcube = [ [[mapcube]], [[map]] ]
;;- concatenation can cause problems on loop. mabcube might get huge without realizing it.
;;sz = size(mapcube, /dimensions)
;sz = size(map, /dimensions)
;
;nn = (size( mapcube, /dimensions))[2]
;print, nn
;
;
;;_______________________________________________________________________________
;
;;- Imaging of power maps
;;- "1600$\AA$ 5.6 mHz (00:00-00:25)"
;title = strarr(nn)
;for ii = 0, nn-1 do begin
;    title[ii] = A[cc].name + ' @5.6 mHz (' $
;        + time[z_start] + '-' +time[ z_start+dz-1] + ' UT) '
;    if ii eq norm then title[ii] = title[ii] + ' normalized'
;endfor
;print, title
;stop
;
;;map = mapcube
;
;;- Composite images
;;sz = size(A[cc].data, /dimensions)
;;composite_images = dblarr(sz[0], sz[1], nn)
;;for ii = 0, nn-1 do begin
;;    composite_images[*,*,ii] = mean( $
;;        A[cc].data[*,*, z_start[ii] : z_start[ii]+dz-1 ], dim=3 )
;;endfor
;;
;;imdata = AIA_INTSCALE( $
;;    composite_images, $  ; didn't multiply by exptime...
;;    ;A[cc].data[*,*, z_start] * A[cc].exptime, $
;;    wave = fix(A[cc].channel), $
;;    exptime = A[cc].exptime )
;
;
;format='(E0.2)'
;for ii = 0, nn-1 do begin
;    print, min(map[*,*,ii])/dz, format=format
;    print, max(map[*,*,ii])/dz, format=format
;endfor
;
;
;sz = size(map, /dimensions)
;nn = sz[2]
;
;x0 = [195, 266, 290] + 1
;y0 = [165, 207, 223] + 1
;
;;immap = alog10(map)
;rows=1
;cols=1
;wx = 10.0
;wy = wx
;;wy = wx * (float(sz[1])/sz[0])
;left   = 0.25
;bottom = 0.25
;right  = 0.25
;top    = 1.00
;;margin=[left, bottom, right, top]
;margin=0.05
;
;im = objarr(nn)
;
;rr = 5.
;
;@color
;
;xx = [150:349]
;yy = [ 65:65+200-1]
;
;for ii = 0, nn-1 do begin
;    win = window( dimension=[wx, wy]*dpi, location=[1000,0] )
;    im[ii] = image2( $
;        ;imdata[*,*,ii], $
;        alog10(map[*,*,ii]), $
;        ;map[*,*,ii], $
;        /current, $
;        /device, $
;        layout=[cols,rows,ii+1], $
;        margin=margin*dpi, $
;        axis_style=0, $
;        ;min_value=0, $
;        ;margin = [left, bottom, right, top]*dpi, $
;        rgb_table = A[cc].ct, $
;        title=title[ii] )
;
;    for jj = 0, n_elements(x0)-1 do $
;        pol = polygon2( $
;            target=im[ii], center=[x0[jj],y0[jj]], dimensions=[rr,rr], $
;            color=color[jj] )
;
;endfor
;;cbar = colorbar2( target = im )
;
;stop
;
;;file = 'aia' + A[cc].channel + 'fcenter.pdf'
;;file = 'newflare_aia' + A[cc].channel + 'images'
;file = 'newflare_aia' + A[cc].channel + 'maps'
;save2, file
;stop
;
;
;cc = 0
;
;xdata = []
;flux = []
;name = []
;frequency = []
;power = []
;
;norm = 1
;
;for ii = 0, 2 do begin
;    xdata = [ [xdata], [0:dz-1] ]
;    ;flux = [ [flux], [ reform(A[cc].data[ x0[ii], y0[ii], 0:dz-1 ])] ]
;    flux = [ [flux], [ reform( total( total( $
;        A[cc].data[ x0[ii]-2:x0[ii]+2, y0[ii]-2:y0[ii]+2, 0:dz-1 ], 1),1))]]
;
;    name = [ name, strtrim(x0[ii],1)+','+strtrim(y0[ii],1) ]
;    result = fourier2( flux[*,ii], A[cc].cadence, norm=norm )
;    frequency = [ [frequency], [transpose(result[0,*])] ]
;    power = [ [power], [transpose(result[1,*])] ]
;endfor
;flux = flux / (r*r)
;stop
;
;resolve_routine, 'batch_plot', /either
;plt = batch_plot( $
;    xdata, alog10(flux), buffer=0, $
;    ytitle='log intensity', $
;    wx=11, wy=6.0, ystyle=2, $
;    title=A[cc].name, name=name)
;leg = legend2( sample_width=0.15, target=plt, /upperleft )
;stop
;
;fmin = 2.0 / 1000.
;fmax = 20.0 / 1000.
;ind = where( frequency[*,0] ge fmin AND frequency[*,0] le fmax )
;
;
;resolve_routine, 'plot_spectra', /either
;plt = plot_spectra( $
;    frequency[ind,*], $
;    ;power[ind,*], $
;    alog10(power[ind,*]), $
;    buffer=0, label=1, $
;    wx=11, wy=6.0, $
;    ystyle=2, $
;    ;title=A[cc].name, $
;    name=name)
;if norm then plt[0].ytitle = plt[0].ytitle + ' (normalized)'
;
;;- result arrays need to be transposed or reformed, b/c
;;- batch_plot takes [*,2], not [2,*]
;
;
end
