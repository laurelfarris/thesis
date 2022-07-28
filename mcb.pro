;Copied from clipboard


resolve_routine, 'legend2', /either
leg = LEGEND2( target=plt, sample_width=0.25, $
    ;/upperleft )
    /upperright )
;
;- NO point in defining these twice (ax[1] and ax[3]) -- 17 January 2020
;ymajor = -1
;yminor = -1
;
;- --> Y-major/minor aren't necessarily the same for both y-axes!
;-       1600A y-range is different from 1700A.
;- ...except the following values should work for both.. appear to be
;-   what original axes are set to.
;-     (14 March 2020)
ymajor = 4
yminor = 3
;
ax[1].title = ytitle[0]
;ax[1].tickvalues = [2:8:2]*10.^7 ; -- hardcoded, 2011 flare
;-----ax[1].tickvalues = [2:6:1]*10.^7 ; -- hardcoded, 2011 flare
;ax[1].tickname = scinot( ax[1].tickvalues )
;ax[1].major = ymajor
ax[1].minor = yminor
;
;ax = plt[1].axes
ax[3].title = ytitle[1]
;----ax[3].tickvalues = [2.2:2.8:0.2]*10.^8 ; -- hardcoded, 2011 flare
;ax[3].tickname = scinot( ax[3].tickvalues )
;ax[3].tickinterval = 1e7
ax[3].major = ymajor
ax[3].minor = yminor
;-
ax[3].title = ytitle[1]
;ax3.title = ytitle[1]
;-
;- Color axes to match data
ax[1].text_color = A[0].color
;ax[3].color = A[1].color
ax[3].text_color = A[1].color
;-
save2, aia_lc_filename

end

