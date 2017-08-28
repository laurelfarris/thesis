;; Last modified:   15 August 2017 20:00:55

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
a6_flux = flux( a6 )
a7_flux = flux( a7 )

end
