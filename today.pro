;+
;- 13 March 2020
;-
;- Today's project:
;-



dz = 64
buffer = 0


;- .RUN restore_maps

threshold = 15000.
mask = product( A.data LT threshold, 3 )

map = A.map
for cc = 0, 1 do begin
    for ii = 0, 685 do begin
        map[*,*,ii,cc] = A[cc].map[*,*,ii] * mask[*,*,cc]
    endfor
endfor


dw
im = image2( alog10(map[*,*,280,0]) )
im = image2( alog10(map[*,*,280,1]) )


;-----------------

;sz = size( A.map, /dimensions)
;power = fltarr( sz[2], sz[3] )
;for cc = 0, n_elements(A)-1 do begin
;    power[*,cc] = (total(total(map[
;endfor

power = total(total( map, 1),1)
help, power



buffer=0
resolve_routine, 'plot_pt', /is_function
dw
plt = PLOT_PT( $
    A[0].time, power, dz, buffer=buffer, $
    stairstep = 1, $
    ;yminor = 4, $
    title = '', $
    name = A.name )
    ;yrange=[-250,480], $ ; maps
;ax = plt[0].axes
;ax[1].tickname = strtrim([68, 91, 114, 137, 160],1)
;ax[3].tickname = strtrim([1220, 1384, 1548, 1712, 1876],1)
ax2 = (plt[0].axes)[1]
ax2.title = plt[0].name + " 3-minute power"
ax2.text_color = plt[0].color
ax3 = plt[1].axes
ax3.title = plt[1].name + " 3-minute power"

filename = ''
save2, filename, /timestamp

end
