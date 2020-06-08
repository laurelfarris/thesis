;+
;- LAST MODIFIED:
;-   05 June 2020
;-     Copied code from plot_filter.pro, since computing and plotting
;-     background levels is unrelated to filtering.
;-
;- ROUTINE:
;-   oplot_background.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-
;- USEAGE:
;-
;- TO DO:
;-   []
;-
;- AUTHOR:
;-   Laurel Farris
;-

;+
;--- Overplot pre-flare background
;-

;- --> HARDCODING!! BAD CODER!
;zind = [120:259]
zind = [0:150]
;- zind = z-indices of pre-flare data from which to extract pre-flare background level
;-    (doesn't start at zero because of the C-flare that took place in the middle
;-      of my pre-flare time period before the X2.2 flare on 15 February 2011... rude).
;-
;-
;background = MEAN(A.flux[zind], dim=1) - delt
;- 15 May 2020
;-  NOTE: "flux" is a subset extracted from A.flux (z-dimension), so in order to get pre-flare background level,
;-    have to go back to full time series: A.flux to get the pre-flare flux,
;-    which was cropped out when defining "flux"...
;-    (was initially confused as to why using A.flux here instead of flux... )
;background = MEAN(A.flux[zind], dim=1)
background = MEAN(A.flux[zind], dim=1)
for jj = 0, 1 do begin
    hor = plot2( $
        plt[0].xrange, $
        [ background[jj], background[jj] ], $
        /overplot, $
        linestyle=[1, '1111'X], $
        name = 'Background' )
endfor
;save2, filename

end
