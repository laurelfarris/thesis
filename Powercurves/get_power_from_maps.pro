
;- LAST MODIFIED:
;-   17 December 2018
;-
;- PURPOSE:
;-   Calculate power as function of time, P(t), by summing over power maps.
;-
;- INPUT:
;- 24 January 2019
;-   Nothing... apparently, GET_POWER_FROM_MAPS is just a ML routine,
;-   no function or procedure to call.
;- KEYWORDS:  N/A
;- OUTPUT:  N/A
;- TO DO:
;-   Add test codes
;-   Create new saturation routine (this currently addresses
;-      saturation and calculation of total power with time.
;-



goto, start
start:;----------------------------------------------------------------------------------------

;- Restore AIA powermaps from .sav files and read into A[0].map and A[1].map.
@restore_maps


;- Thu Jan 24 11:46:02 MST 2019
;-   Correct restored power map for saturation by multiplying by mask.

dz = 64

;- --> write subroutine with data as input argument
sz = size( A.data, /dimensions )


;- Initialize MAP mask
map_mask = fltarr(sz[0],sz[1],sz[2]-dz,n_elements(A))
;map_mask = fltarr(500,330,686,n_elements(A))

;- Compute MAP mask
resolve_routine, 'powermap_mask', /either
for cc = 0, 1 do $
    map_mask[*,*,*,cc] = POWERMAP_MASK( $
        A[cc].data, dz, exptime=A[cc].exptime, threshold=10000.)
; --> returns FLOAT [500,330,686,2]

;- 1D array of # unsaturated pixels in each map.
n_pix = total(total(map_mask,1),1)

;- Test n_pix
if (where(n_pix eq 0.0))[0] ne -1 then begin
    print, "Problem: n_pix = 0 somewhere, which should be impossible. "
    stop
endif


;- Multiply mask by AIA power maps to set saturated pixels = 0.
;-  (may be better to set A.map = A.map * map_mask to save memory...)
;map = A.map * map_mask


;-  Went ahead and did this.
A.map = A.map * map_mask

;---------------------------------------------------------------------------------------------


;- P(t) pix^{-1} = 1D array created by summing over x & y in each map.
;power = (total(total(map,1),1)) / n_pix


;- Total power for small subregions

r = 20
cc = 0

;map1 = CROP_DATA( A[cc].map, dimensions=[r,r], center=[367,213] )
;map2 = CROP_DATA( A[cc].map, dimensions=[r,r], center=[382,193] )

;- center variable is defined in sub.pro
map1 = CROP_DATA( A[cc].map, dimensions=[r,r], center=center[*,0] )
map2 = CROP_DATA( A[cc].map, dimensions=[r,r], center=center[*,1] )


n_pix = float(r*r) ;- map is FLOAT, so may as well convert n_pix

;p1 = (total(total(map1,1),1)) / n_pix
;p2 = (total(total(map2,1),1)) / n_pix


;- Use single pixel at center; no need to sum pixels or divide by n_pix
;-  (previously getting non-zero values during saturation times due to summing
;-    over several pixels, not all of which would have saturated at the same time.
;-    Didn't think plots showed accurate results).
;- --> lots of periodicity in P(t)... is this what Monsue et al. 2016 meant
;      when they said integrated over slightly larger area improved SNR?
;p1 = A[cc].map[center[0,0], center[1,0], *]
;p2 = A[cc].map[center[0,1], center[1,1], *]

;xdata = indgen(686, 2)
;ydata = [ [p1[*,0]], [p2[*,0]] ]
;plt = BATCH_PLOT( xdata, ydata, buffer=0 )

wx = 8.0
wy = 4.0
win = window( dimensions=[wx,wy]*dpi, location=[1250,0] )
xdata = indgen(686)

mm = (size(center, /dimensions))[1]
plt = objarr(mm)
for ii = 0, mm-1 do begin
    map1 = CROP_DATA( A[cc].map, dimensions=[r,r], center=center[*,ii] )
    p1 = (total(total(map1,1),1)) / n_pix
    plt[ii] = plot2( xdata, p1, /current, overplot=ii<1, ylog=1, color=color[ii] )
endfor



;plt = plot2( xdata, p1, /current, ylog=1, color="blue" )
;plt = plot2( xdata, p2, /overplot, ylog=1, color="red" )

stop




print, "AIA 1600:"
st = stats( power[*,0], /display )

print, st.min * A[0].exptime
print, st.max * A[0].exptime

;print, "AIA 1700:"
;st = stats( power[*,1], /display )


;- Run separate routine for plotting:


power_from_maps = power



props = { $
    ;yrange=[-250,480], $ ; maps
    yminor : 4, $
    name : A.name }

file = 'time-3minpower_maps'

;- plot_Pt calls BATCH_PLOT, which takes data with > 1 dimension and
;-   overplots each additional array. (ie don't have to loop over each
;-   channel or call procedure more than once).


;- --> Try adding mini-axis BEFORE shifting ydata.


;- With the "props" structures, the call to plot_pt is still exactly
;-  the same in _maps as it is in _flux...
resolve_routine, 'plot_pt', /either
plot_pt, power, dz, A[0].time, $
    ;file=file, $
    _EXTRA = props


end
