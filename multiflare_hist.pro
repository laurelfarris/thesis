;+
;- LAST MODIFIED:
;-   28 July 2020
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
;-   [] copy code from struc_aia.pro that restores and crops 3D data cube
;-       and paste into a separate routine.
;-



;+
;- Example code copied from Harris geospatial ref pages for IDL --> PLOTHIST
;-   (18 July 2020)
;-
;-
;-  "Create a vector of random 1000 values derived from a
;-    Gaussian of mean 0, and sigma of 1.
;-  Plot the histogram of these values with a
;-    binsize of 0.1, and use a box plotting style."
;-
a = randomn(seed,1000)
PLOTHIST, a, bin = 0.1, /boxplot
;-
;-
;- "As before, but fill the plot with diagonal lines at a 45 degree angle"
;-
PLOTHIST, a, bin=0.1, /fill, /fline, forient=45
;-

;====================================================================================



;pro HIST, data, _EXTRA=e
    ;common defaults
;end

buffer = 1
dz = 64
@parameters

format='(e0.2)'

restore, '../multiflare_struc.sav'

;---
;- Set up data whose piels values will be used to create histograms.
;-

restore, '../BDAmaps.sav'
;-   AIA1600MAPS    FLOAT    = Array[ 500, 330, 9 ]
;-   AIA1700MAPS    FLOAT    = Array[ 500, 330, 9 ]
;-   BDA_ZIND        LONG    = Array[ 3, 3 ]
;-   BDA_TIME      STRING    = Array[ 3, 3 ]
;-

restore, '../BDAmask.sav'


;imdata = aia1600maps * aia1600mask
;imdata = aia1700maps * aia1700mask

binsize = 0.1
nbins = 500

sz = size(imdata, /dimensions)
help, sz

ydata = LONARR(nbins, sz[?])
xdata = LONARR(nbins, sz[?])


;-
;- Compute histogram data
;-

;-- possible to have variable bin width (i.e. log scale)?
for ii = 0, 8 do begin
    ydata[*,ii] = HISTOGRAM( $
        imdata[*,*,ii], $
        locations=locations, $
        nbins=nbins, $
        binsize=binsize, $
        input=input, $
;        min=min, $    ;- min value of imdata to consider
;        max=max, $    ;- max value of imdata to consider
;        omin=omin $   ;- starting loc of first bin (~xrange[0])
;        omax=omax, $  ;- starting loc of last bin (~xrange[1])
    )
    xdata[*,ii] = locations
endfor
help, input
print, min(input)
print, max(input)


;---
;- Hacky way to figure out xrange
;-
for jj = 0, 8 do begin
    for ii = 0, nbins-2 do begin
        ;-  --. use TOTAL( /cumulative ) ?
        npix = total( ydata[ii:nbins-1, jj] )
        ;- [] test for MIN x-range as well
        if npix lt 100 then begin
            print, jj, ii, npix
            break
        endif
    endfor
endfor
;
ind = [1:499]


;---
;- Plot histgram
;-

wy = 8.5
wx = 8.5

dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
plt = objarr(9)

;- oplot 3 at a time
resolve_routine, 'plot2', /is_function
for ii = 0, sz[?]-1 do begin
    plt[ii] = plot2( $
        xdata[ind,ii], $
        ydata[ind,ii], $
        /current, $
        layout=[3,3,ii+1], $
        margin=0.15, $
        histogram=1, $
        ;xlog=1, $
        ylog=1, $
        xmajor=4, $
        xtickunits="scientific", $
        ytickunits="scientific", $
        ;yrange=[0.1, 10^(ceil(alog10(max(result)))) ], $
        ;yrange=[0,10], $
        ;min_value=0, $
        xticklen=(0.20/wy), $
        yticklen=(0.20/wx), $
        ytitle='log # pixels', $
        xtitle='log 3-min power', $
        buffer=buffer $
    )
endfor

leg = legend2( $
    target = plt, $
    /upperright $
)

save2, fname, /add_timestamp

end
