;; Last modified:   04 October 2017 17:24:25

;+
; ROUTINE:      flux.pro
;
; PURPOSE:
;
; USEAGE:
;
; INPUT:
;
; KEYWORDs:
;
; OUTPUT:
;
; TO DO:
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-



function flux, cube


    sz = size(cube, /dimensions)
    flux = []
    for i = 0, sz[2]-1 do $
        flux = [ flux, total(cube[*,*,i]) ]


    return, flux


end



hmi_flux = flux( hmi )
aia_1600_flux = flux( a6 )
aia_1700_flux = flux( a7 )

end
