;+
;- 09 July 2021
;-
;- TO DO:
;-   [] Finish GOES lightcurves
;-
;- C8.3 2013-08-30 T~02:04:00
;- M1.0 2014-11-07 T~10:13:00
;- M1.5 2013-08-12 T~10:21:00
;-



buffer = 1
@par2
;
flare = multiflare.m15

print, flare.class
class = strlowcase((flare.class).Replace('.',''))
print, class










end
