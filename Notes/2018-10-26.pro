;+
;- 12 February 2019
;-
;- combined two codes:
;-   powermaps_fcenter.pro
;-   central_freq_powermaps.pro

;----------------------------------------------------------------------------------------
;- 26 October 2018

;- Concerned that maps show power scaled with intensity, and don't
;- necessarily reflect true power of 3-min osci.
;- --> make several maps at various central frequencies, especially those
;- that shouldn't be enhanced... maybe 20 mHz? See Milligan WA plots.
;- Full AR, to compare areas of high and low emission.
;- Flare ribbons?
;-
;- should probably compare various time segment lengths and bandpasses...
;- but one thing at a time.

;- Limits on frequencies based on cadence and time segment length.
;-   fmax --> shortest period = 2*cadence
;-   fmin --> longest period = dt/2
;- 48 seconds - 13 minutes

;----------------------------------------------------------------------------------------
;-
;- 31 July 2019
;-   Copied the above comments to a "Note".pro file from routine
;-   central_freq_powermaps.pro in "work"/Maps/
;-  (a merge of a couple different routines computing
;-   power maps at various central frequencies to compare with 5.6 mHz).
;-  Want to clean up my subroutines, but occasionally ramblings in the comments
;-  come in handy later, so wanted to save it somewhere...
;-
;-
;- Guess this should be split into 2018-10-26.pro and 2019-02-12.pro, but, meh.
;-
;----------------------------------------------------------------------------------------
;-
;-
