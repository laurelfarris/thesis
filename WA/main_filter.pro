;+
;- Last modified:
;-    05 June 2020
;-
;- Purpose:
;-   cutoff_period => defined
;-   flux
;-
;- External subroutines:
;-   filter.pro
;-
;- To Do
;-   [] RENAME to s/t other than filter? Line where filter is called below looked like
;-        a canned IDL routine.. serached around the internet for some source material
;-        before remembered that "filter.pro" is a function I wrote,
;-        located in the current directory...
;-

;- Keep period > 400 sec (freq < 2.5 mHz)

;- pass to FILTER function
cutoff_period = 400.

;- Define flux
flux = A.flux
;-   NOTE: input variable may not always take the form of "A.flux", e.g. if I
;-    wanted to test by directly running read_sdo and bypassing struc_aia.pro.
;-    Structure "A" would not exist. Or maybe structure is called "H" because it's
;-    HMI data..
;-  Using codes entirely at ML to "hardcode" values that often change, and call
;-   external routines that are NOT hardcoded. Any code that stays the same for
;-   all types of data, or all flares, etc. should be in an external subroutine.


;+
;--- Compute inverse transform
;-
inverseTransform = []
for cc = 0, 1 do begin
    inverseTransform = [ $
        [ inverseTransform ], $
        [ FILTER( flux[*,cc], A[cc].cadence, cutoff_period ) ] $
    ]
endfor

end
