;+
;- LAST MODIFIED:
;-   30 April 2019
;-
;- 21 May 2019
;-
;- Brief description of what I did today
;-  (include subroutines, filenames of saved figures, key terms to make searchable)
;-
;- Also, like the idea of planning out little coding tasks ahead of time like
;-  this.. probably more likely to be done than when they're in Todoist.
;- Could even write a few lines of code early, even tho can't run it yet.


goto, start


start:;-------------------------------------------------------------------------------

;- get_power_from_maps.pro is a ML program currently plotting ROIs.
;-  It's a mess. No idea how I got plots out of this before.
;-  Also had hard-coded variables. Shocking.
;- Reading in the bits that make sense.

dz = 64
sz = size( A.data, /dimensions )

;- Restore AIA powermaps from .sav files and read into A[0].map and A[1].map.
@restore_maps

;- MASK: Correct restored power map for saturation by multiplying by mask.

;- Initialize, then compute MAP mask
map_mask = fltarr(sz[0],sz[1],sz[2]-dz,n_elements(A))
resolve_routine, 'powermap_mask', /either
for cc = 0, 1 do $
    map_mask[*,*,*,cc] = POWERMAP_MASK( $
        A[cc].data, dz, exptime=A[cc].exptime, threshold=10000.)
; --> returns FLOAT [500,330,686,2]

;- 1D array of # unsaturated pixels in each map.
npix = total(total(map_mask,1),1)

;- Test npix
if (where(npix eq 0.0))[0] ne -1 then begin
    print, "Problem: npix = 0 somewhere, which should be impossible. "
    stop
endif

A.map = A.map * map_mask ;(dangerous!)


sz = size( A.data, /dimensions )

;- Initialize 1D array of power summed over maps (second dimension is for multi-channel)
;- P(t) pix^{-1} = 1D array created by summing over x & y in each map.
Pt = fltarr( sz[2]-dz, n_elements(A) )
for cc = 0, n_elements(A)-1 do begin
    Pt[*,cc] = (total( total( A[cc].map, 1), 1 )) / npix
end

xdata = indgen(sz[2]-dz, n_elements(A))
ydata = Pt
;ydata = [ [p1[*,0]], [p2[*,0]] ]
;plt = BATCH_PLOT( xdata, ydata, buffer=0 )

wx = 8.0
wy = 4.0
win = window( dimensions=[wx,wy]*dpi, location=[1250,0] )

p = objarr(2)
p[0] = plot2( xdata[*,0], ydata[*,0], /current, axis_style=1, color='green', ylog=1)
p[1] = plot2( xdata[*,1], ydata[*,1], /current, $
    position=p[0].position, $
    axis_style=4, color='purple', $
    ylog=1 )

ax = axis( 'Y', location='right', target=p[1], color=p[1].color )

;- see how this looks before moving on.
stop
;----------------------------------------------------------------------------------


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


;- 1.  P(t) plots over short dt and plot symbols to see where data points are
;-         relative to apparent periodicity in these plots.

;- 2.  Lots of info on all figures -- titles, legends, window_title,
;-         use IDL's TEXT function to randomly plop info in available white space.
;-         Can easily remove later, for now, show all the numbers!

end
