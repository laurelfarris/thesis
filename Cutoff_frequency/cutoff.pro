;+
;- DATE CREATED:
;-   28 October 2020
;-
;- ROUTINE:
;-   cutoff.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-  Make my own cutoff frequency profile!
;-  plot variation of acoustic cutoff frequency with height (interior + atm ?)
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
;-   [] Figure out how to use model --> ./model_s.txt
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+



pro CUTOFF

    ; Constants
    k_B = 1.38e-16
    m_amu = 1.67e-24

    ; "Constants"
    gammaa = 5./3.
    mu = 1.2

    ; mass Density array
    rho = [1e-7, 1e-12, 1e-16]

    ; Temperature array for photosphere, T_min, chromosphere, and corona (roughly)
    T = [5800., 4200., 10000., 1e6]

    ; Local sound speed array
    cs = sqrt( ( k_B * T * gammaa ) / ( mu * m_amu ) )


end
