;; Last modified:   28 May 2018 13:17:50


;Input:     3D data cube
;Output:    1D array, each element = total over dimensions 1 and 2.


function GET_FLUX, cube, norm=norm, exptime=exptime

    flux = total( total(cube,1), 1 )

    if keyword_set( norm ) then begin
        flux_norm = flux - min(flux)
        flux_norm = flux_norm / max(flux_norm)
        flux = flux_norm
    endif

    return, flux

end

exptime = aia1600index.exptime
exptime = aia1700index.exptime

aia1600.flux = flux/exptime
aia1700.flux = flux/exptime



; ??
avg = fltarr(4) + mean( exptime )
exptime = [exptime, avg]




end
