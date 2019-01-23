
;- Sat Dec 15 07:14:20 MST 2018

;- Purpose:
;-   Calculate Fourier power spectrum at locations of high and low
;-   magnetic field and see how the dominant power compares across
;-   range of frequencies.
;-
;- Input/keywords/args:
;-   [placeholder]
;-


pro hmi_spectra


    ;- Each of the four sunspots, roughly in center
    ;- (same coords as in subregions.pro)
    center = [ $
        [115, 115], $
        [230, 190], $
        [280, 180], $
        [367, 213] ]
    nn = (size(center, /dimensions))[1]

    highB = { $
        center : [], $
        }


end

;- Sat Dec 15 07:29:36 MST 2018

;- Jain & Haber 2002 : Figure 5
;- shows (velocity) power spectra for area with
;- strong B (between 51 and 300 G) and lower B (between 0 and 50).

end
