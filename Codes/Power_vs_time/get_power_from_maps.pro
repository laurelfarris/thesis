
;- LAST MODIFIED:
;-   17 December 2018
;-
;- PURPOSE:
;-   Calculate power as function of time, P(t), by summing over power maps.
;-
;- INPUT:
;-   flux, cadence
;- KEYWORDS:
;- OUTPUT:
;- TO DO:
;-   Add test codes
;-   Create new saturation routine (this currently addresses
;-      saturation and calculation of total power with time.



goto, start

;- Restore AIA powermaps from .sav files and read into A[0].map and A[1].map.
@restore_maps


dz = 64

;- Compute MAP mask
map_mask = fltarr(500,330,686,n_elements(A))
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
map = A.map * map_mask

;- P(t) pix^{-1} = 1D array created by summing over x & y in each map.
power = (total(total(map,1),1)) / n_pix


print, "AIA 1600:"
st = stats( power[*,0], /display )

print, st.min * A[0].exptime
print, st.max * A[0].exptime

;print, "AIA 1700:"
;st = stats( power[*,1], /display )


;- Run separate routine for plotting:


power_from_maps = power



start:;----------------------------------------------------------------------------------------
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
    file=file, $
    _EXTRA = props


end
