;+
;- DATE(S) CREATED/MODIFIED:
;-   10 September 2020
;-
;- ROUTINE:
;-   name_of_routine.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-
;- USEAGE:
;-   result = name_of_routine( arg1, arg2, kw1=kw1, ... )
;-
;- INPUT:
;-   arg1   e.g. input time series
;-   arg2   e.g. time separation (cadence)
;-
;- KEYWORDS (optional):
;-   kw1     set <kw1> to ...
;-   kw2     set <kw2> to ...
;-
;- OUTPUT:
;-   result     <data type>  what value(s) mean
;-
;- TO DO:
;-   [] item 1
;-   [] item 2
;-   [] ...
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+

;-
;- On 08 August 2020, created today.pro
;-   (actually "yesterday.pro", so may have created file on 07 August)
;-   by copying 2020-07-24.pro which itself contains content from 2020-07-14.pro
;- Command "diff" at command line revealed no difference between
;-   ./yesterday.pro and Notes/2020-07-24.pro, so deleted the former.
;-  [] --> see other notes from these dates (handwritten, Entoe, wherever.)
;-     to see what I was planning on doing here..
;-

;- NOTE: copied _template.pro to today.pro and
;-   "deleted" it (--> OLD/_template_20200910.pro)
;-  to clean up working directory as much as possible.

;_______________________________________________________________________
;-  From 08 September's "today.pro":

flare_path = [ '../20131228/', '../20140418/', '../20110215/' ]
format = '(e0.2)'


print, '---------'
foreach path, flare_path, ii do begin
    restore, path + 'aia1600map.sav'
    aia1600power = total(total(map,1),1)

;    print, where( aia1600power eq max(aia1600power) )
;    print, where( aia1600power eq min(aia1600power) )
    print, min(aia1600power), format=format
    print, max(aia1600power), format=format
    dp = max(aia1600power) - min(aia1600power)
    print, dp, format=format

    print, '---------'

endforeach

;_______________________________________________________________________


end
