;+
;- LAST MODIFIED:
;-   21 May 2019
;-
;-  15 May 2020
;-    • separated out calc_fourier2 from filter.pro into its own file
;-      so I can clean up filter.pro for computing WA.
;-    • Modifed (improved) the following comments:
;-        The function "calc_fourier2" defined here was copied from a
;-        routine called filter.pro, but NOT the same as function
;-        of the same name that currently resides in the same directory.
;-        Don't recall the details of when/why this was written,
;-        [] compare to Spectra/calc_ft.pro, maybe similar...
;-            Actually the final block of comments before procedure definition
;-            indicates spectra and power maps had their own different versions of
;-            a routine to compute fourier2 and return something in a useful form.
;-      Backburner for now.
;-     --> see filter_OLD_20200515.pro for lots of messy ML code, with many calls to
;-        CALC_FOURIER2, though all lines are commented..
;-
;- ROUTINE:
;-   calc_fourier2.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-
;- USEAGE:
;-   From ML:
;-     CALC_FOURIER2, A[0].flux, 24, frequency, power
;-
;-   threshold = 400 ;- Remove variations on timescales less than this? Or greater?
;-     ??
;-
;- INPUT:
;-
;- KEYWORDS (optional):
;-
;- OUTPUT:
;-
;- TO DO:
;-
;- KNOWN BUGS:
;-
;- AUTHOR:
;-   Laurel Farris
;-
;-
;- This is mostly for power maps, not spectra:
;fcenter = 1./180
;bandwidth = 0.001
;fmin = fcenter - (bandwidth/2.)
;fmax = fcenter + (bandwidth/2.)



pro CALC_FOURIER2, flux, cadence, frequency, power, fmax=fmax, fmin=fmin

    sz = size( flux, /dimensions )
    if n_elements(sz) eq 1 then sz = reform(sz, sz[0], 1, /overwrite)

    result = fourier2( indgen(sz[0]), 24 )

    frequency = reform(result[0,*])
    if not keyword_set(fmin) then fmin = min(frequency)
    if not keyword_set(fmax) then fmax = max(frequency)

    ind = where(frequency ge fmin and frequency le fmax)
    frequency = frequency[ind]

    power = fltarr( n_elements(frequency), sz[1] )
    for ii = 0, sz[1]-1 do begin
        result = fourier2( flux[*,ii], 24 )
        power[*,ii] = (reform(result[1,*]))[ind]

        ;frequency = frequency[ind]
        ;power = power[ind]

    endfor
end
