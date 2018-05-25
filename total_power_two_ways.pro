;; Last modified:   15 May 2018 20:36:15




; snippets of code from when I was testing plots of total
; power from total flux vs. total(powermaps),
; and plotting in same window as lightcurve.

; k is a counter used to access the various arrays

for k = 0, n_elements(p)-1 do begin  ;***

    ; shift power to plot as function of CENTRAL time

    ; power calculated from total(maps)
    if k eq 2 then begin
        p0 = A[0].power2 * good_pix
        p1 = A[1].power2 * good_pix
        p_tot_map = [ [p0], [p1] ]
        ydata = shift(p_tot_map,  (dz/2) )
    endif

    ; power calculated from total(flux)
    if k eq 1 then begin
        ydata = shift(A.power,  (dz/2) )
        bottom = 0.0
    endif

    if k ge 1 then begin
        top = 0.0
        ytitle = 'power (normalized)'
        ; Trim zeros from edges of power.
        ; --> ONly need to do this for full light curve!
        ydata = ydata[32:716, *]
        xdata = [32:716]

        ; Only cover desired time
        ;ydata = ydata[i1:i2,*]

        ; normalize
        y0 = ydata[*,0]
        y0 = y0 - min(y0)
        y0 = y0/max(y0)
        y1 = ydata[*,1]
        y1 = y1 - min(y1)
        y1 = y1/max(y1)
        ydata = [ [y0], [y1] ]
    endif

    ; This requires k to start at 0, otherwise xdata is not defined.
    ; Lightcurves
    if k eq 0 then begin
        bottom = 0.0
        xdata = [i1:i2]
        ydata = A.flux_norm
        ytitle = 'counts (normalized)'
    endif


endfor ;***
