;+
;- DATES MODIFIED:
;-   28 October 2020
;-
;- ROUTINE:
;-   today.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-   Preserve everything I do: developing new code, trying IDL routines
;-   and/or kws/args that I've never tried, test codes, etc.
;-   Almost nothing deleted.. code that doesn't work or is improved is
;-   commented, but left in file. Eventually copied to yyyy-mm-dd.pro,
;-   and code that is actually useful is moved to appropriately named
;-   subroutine, create new routine or add to existing, etc.
;-
;- USEAGE:
;-   result = routine_name( arg1, arg2, kw=kw )
;-
;- INPUT:
;-   arg1   e.g. input time series
;-   arg2   e.g. time separation (cadence)
;-
;- KEYWORDS (optional):
;-   kw     set <kw> to ...
;-
;- OUTPUT:
;-   result     blah
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



;- Test SAVE routine if file exists

var2save = 20191019
save, var2save, filename='hubby.sav'





end
