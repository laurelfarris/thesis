
;- 25 October 2018


cc = 0
;z_start = [ 16, 58, 196, 216, 248, 280, 314, 386, 450, 525, 600, 658 ]

;before
ind = [0:259]
z_start = [ 16, 58, 196]
file = 'aia' + A[cc].channel + 'before.pdf'

;during
ind = [260:449]
;z_start = [ 216, 248, 280]
;file = 'aia' + A[cc].channel + 'during.pdf'

;after, parts 1 and 2
ind = [450:748]
;z_start = [314, 386, 450]
;z_start = [525, 600, 658 ]
;file = 'aia' + A[cc].channel + 'after1.pdf'
;file = 'aia' + A[cc].channel + 'after2.pdf'

;-------------

dz = 64

time = strmid(A[cc].time, 0, 5)

N = n_elements(z_start)

bda = fltarr(500, 300, N*2)
title = strarr(N*2)

for ii = 0, N-1 do begin
    bda[*,*,ii] = A[cc].data[*,*,z_start[ii]-(dz/2)]
    title[ii] = time[z_start[ii]-(dz/2)] + ' UT'
endfor
restore, '../aia1600map_2.sav'
for ii = 0, N-1 do begin
    bda[*,*,ii+N] = map[*,*,z[ii]]
    title[ii+N] = time[z_start[ii]] + '-' + time[z_start[ii]+dz] + ' UT'
endfor


im = image3( bda, rows=2, cols=3, title=title, rgb_table=A[cc].ct )


;- polygons

x0 = [125, 250, 375, 425]
y0 = [100, 175, 225,  75]
r = 100

for ii = 0, 5 do begin
    for jj = 0, n_elements(x0)-1 do begin
        pol = polygon2( center=[x0[jj],y0[jj]], dimensions=[r,r], target=im[ii])
    endfor
endfor
save2, file

stop

;- Plot LC for subregions outlined by polygons

nn = n_elements(x0)
name = strarr(nn)
flux = fltarr( n_elements(ind), nn )

for ii = 0, nn-1 do begin
    flux[*,ii] = total( total( $
        crop_data( $
            A[cc].data, $
            center=[x0[ii],y0[ii]], $
            dimensions=[r,r] ), 1), 1)
    name = 'subregion' + strtrim(ii,1)
endfor


plt = plot3( A[cc].jd[ind], flux, name=name )



end
