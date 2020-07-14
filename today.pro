;+
;- 14 July 2020
;/*
; * blah
; * new way to type comments
; */
;
;-
;-
;- PURPOSE:
;-   1. Histogram for each BDA map with number of pixels with 3-minute power between
;-       N and N+dn, where dn = bin width (depends on max-min of power...
;-       probably easier to set number of bins instead of bin width in first
;-        call to IDL's HISTOGRAM function.
;-
;-   histogram: # pixels vs. 3-minute power
;-   xrange = [ MIN(map[*,*,zz]) : MAX(map[*,*,zz]) ]
;-   where zz = values from last week's BDA maps.
;-
;-
;- To do :
;-   [] Histograms
;-   [] remove tags for data and power maps and re-save "headers".
;-   [] copy code from struc_aia.pro that restores and crops 3D data cube
;-       and paste into a separate routine.
;-

buffer = 1
dz = 64


restore, 'BDAmaps.sav'
;

;restore, "multiflare_structures_X22.sav"
;restore, "multiflare_structures_M73.sav"
;restore, "multiflare_structures_C30.sav"
;


imdata = aia1600maps[*,*,0]

format='(e0.4)'
print, min(imdata), format=format
print, max(imdata), format=format

;
;print, xdata, format=format
;print, result, format=format
print, max(xdata)
print, xdata[-1]
print, min(xdata)
print, xdata[0]
print, sort(xdata)


;- test IDL's SORT function
test = [5,3,9,1]
ind = fix(sort(test))
print, test
print, ind
print, test[ind]


;---------------------------------------------------------------------------------

;- test best way to set ticklen... NOT IMPORTANT!!!

;wx = 8.0
;wy = 3.0
;
wx = 3.0
wy = 3.0
;
dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
xdata = findgen(20)
ydata = sqrt(xdata)
plt = PLOT2( $
    xdata, ydata, $
    /current, $
    xticklen=0.15/wy, $
    yticklen=0.15/wx, $
    color='pink', $
    symbol='Circle', $
    ;sym_size=0.5, $
    buffer=buffer $
)

ax = plt.axes
print, ax[0].ticklen  --> 0.067
print, ax[1].ticklen  --> 0.024
;
print, ax[0].ticklen*wy
print, ax[1].ticklen*wx
;-  both ~0.2 for 8x3 inch window
;-  both ~0.1 for 4x1.5 inch window...



save2, 'test2'

;-------------------------------------------------------------------

imdata = aia1600maps[*,*,4]

nbins = 1000
result = HISTOGRAM( $
    imdata, $
    locations=xdata, $
    nbins=nbins, $
    min=0.0, $
    omax=omax, $
    omin=omin $
)

print, omin
print, omax
;

;
ind = [nbins/2 : nbins-1]
print, ind[0]
print, ind[-1]
;
;print, (where(xdata gt 1e4))[0]



ind = [200:nbins-1]
;
wx = 8.0
wy = 8.0
dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
resolve_routine, 'plot2', /is_function
plt = plot2( $
    xdata, result, $
    ;xdata[ind], result[ind], $
    /current, $
    stairstep=1, $
    ;xlog=1, $
    ylog=1, $
    ;xmajor=
    ;yrange=[0.1, 10^(ceil(alog10(max(result)))) ], $
    ;yrange=[0,10], $
    ;min_value=0, $
    xticklen=(0.10/wy), $
    yticklen=(0.10/wx), $
    title='C3.0 pre-flare ' + bda_time[0,0] + '-' + bda_time[1,0], $
        ;- [] need better multiflare structure setup for this!
    ytitle='# pixels', $
    xtitle='3-minute power', $
    buffer=buffer $
)
save2, 'histogram'

;
;
print, plt.xticklen
print, plt.yticklen
;
print, plt.xticklen*wy
print, plt.yticklen*wx


;- Eventually... one histogram for each BDA power map; 
;-   same layout as figure from 2020-07-10.pdf weekly summary.


;===============================================================================



;- back to power maps





end
