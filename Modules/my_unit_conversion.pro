;+
;- 04 November 2021
;-
;-
;-
;- Unit conversion (since I can't figure out how to use IDL's canned routines,
;-   assuming they exist)
;-
;-



; Channels in wavelength range 1-8 and 0.5-4 Angstroms (=10^-10 meters = 10^-8 cm)

;lambda = 0.5e-8 ; cm
lambda = 1.0e-8
;lambda = 4.0e-8
;lambda = 8.0e-8


; physical constants ARE available as IDL system constants,
; but I don't feel like looking them up at the moment...

; constants (cgs)
h = 6.262e-27 ; cm^2 g s^-1
c = 3.0e10 ; cm s^-1


E_erg = ( h*c ) / lambda

;print, E_erg, ' (erg)'


; 1 erg = 6.242e11 eV

E_keV = ( E_erg * 6.242e11 ) / 1000.

print, '       ', lambda, ' cm'
print, '  ==>> ', E_keV,  ' (keV)'


;format = '()'
;print, E, format=format


end
