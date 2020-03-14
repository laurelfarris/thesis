;+
;- 13 March 2020
;-
;- Today's project:
;-   Restore maps from .sav files and multiply them by global mask,
;-   rather than 3D cube of map_masks where pixels only = 0 if saturated
;-   during that particular window -->   [t_i : t_i+T-1]
;-
;- Steps:
;-   IDL> .RUN struc_aia
;-   IDL> .RUN restore_maps
;-   Set variables to desired values (dz, buffer, threshold, --> see top of ML code)
;-   IDL> .RUN today
;-

;- imaging code : getting it out of my way for now.
;dw
;im = image2( alog10(map[*,*,280,0]) )
;im = image2( alog10(map[*,*,280,1]) )

;-
;- User-defined variables
dz = 64
buffer = 1
;threshold = 15000.
threshold = 10000.



;+
;--- 3D cube of masks, one for each $T$-length window
;-
;sz = size( A.map, /dimensions)
;mask = fltarr(sz)
;-  Shouldn't have to run this more than once... sets dimensions of mask,
;-   is overwritten everytime re-run code, e.g.
;-     mask = POWERMAP_MASK(...)
;-  for 3D mask computed using subsets with 3rd dim = dz, or
;-     mask = product( A.data LT threshold, 3 )
;-  for global mask (2D mask for each channel)
;-
;resolve_routine, 'powermap_mask', /either
;for cc = 0, 1 do begin
;    mask[*,*,*,cc] = POWERMAP_MASK( $
;        ;A[cc].data, $
;        A[cc].data/A[cc].exptime, $
;        ;exptime=A[cc].exptime, $
;        threshold=threshold, $
;        dz=dz )
;endfor
;- IDL> help, map
;-        FLOAT  = Array[500, 330, 686, 2]
;-----


;+
;--- Global mask
;-
mask = product( A.data LT threshold, 3 )
;-  That was easy enough
;-
;-------



;+
;- Create new variable "map", rather than A.map = A.map*mask
;-  ... NEVER good idea to update variable with itself..
;-



;-
;- For 3D mask:
;-  Directly multiply map by mask...
;-    straightforward when dimensions of A.map match those of mask.
;map = A.map * mask
;-


;-
;- For Global mask:
;-   Not so straightforward when mask is the same for every map in the
;-     500x330x686 array that each channel has.
;-    There's probably a much easier way to do this with matrix operators,
;-     or some IDL array function I'm not familiar with. Can't think of anything
;-     at the moment, but this should at least produce the correct result.
map = A.map
for cc = 0, 1 do begin
    for ii = 0, 685 do begin
        map[*,*,ii,cc] = A[cc].map[*,*,ii] * mask[*,*,cc]
    endfor
endfor
;-
;-



;- Sum over x and y in each power map to get 3min power as function of time: P(t)
power = total(total( map, 1),1)
;-


;- Sum over maps WITHOUT excluding contaminated pixels
;power = total(total( A.map, 1),1)


;-
;-
help, power
;-
format="(e0.2)"
print, min(power[*,0]), format=format
print, max(power[*,0]), format=format
print, min(power[*,1]), format=format
print, max(power[*,1]), format=format
;--



;+
;--- Plot 3-minute power as function of time -- P(t)
;-


;ind = [470:500]
resolve_routine, 'plot_pt', /is_function
dw
;power[*,0] = power[*,0] * ((A[0].exptime)^2)
;power[*,1] = power[*,1] * ((A[1].exptime)^2)
plt = PLOT_PT( $
    A[0].time, $
    power, $
    ;A[0].time[ind], $
    ;power[ind,*], $
    ;alog10(power), $
    dz, $
    buffer=buffer, $
    stairstep = 1, $
    ;yminor = 4, $
    ;yrange=[-250,480], $   ; maps
    title = '', $
    name = A.name )
;-
;ax = plt[0].axes
;ax[1].tickname = strtrim([68, 91, 114, 137, 160],1)
;ax[3].tickname = strtrim([1220, 1384, 1548, 1712, 1876],1)
ax2 = (plt[0].axes)[1]
ax2.title = plt[0].name + " 3-minute power"
ax2.text_color = plt[0].color
ax3 = plt[1].axes
ax3.title = plt[1].name + " 3-minute power"
;-
;-

;filename = 'pt_maskGlobal_' + class
filename = 'time-3minutepower_maps_' + class
resolve_routine, 'save2'
save2, filename, /timestamp, /overwrite

end
