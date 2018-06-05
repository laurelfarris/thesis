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




flux = total( total(aia1600.data,1), 1 )
exptime = aia1600index.exptime
aia1600.flux = flux/exptime




flux = total( total(aia1700.data,1), 1 )
exptime = aia1700index.exptime
avg = fltarr(4) + mean( exptime )
exptime = [exptime, avg]

aia1700.flux = flux/exptime

end
