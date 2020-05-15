; Last modified:    08 August 2018


;- Make my own cutoff frequency profile through interior and atmosphere
;-  of the sun



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
