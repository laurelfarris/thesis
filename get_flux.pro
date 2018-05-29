;; Last modified:   28 May 2018 13:17:50


;Input:     3D data cube
;Output:    1D array, each element = total over dimensions 1 and 2.


function get_flux, cube

    flux = total( total(cube,1), 1 )

    if keyword_set( norm ) then begin
        flux_norm = flux - min(flux)
        flux_norm = flux_norm / max(flux_norm)
        flux = flux_norm
    endif


    return, flux

end
