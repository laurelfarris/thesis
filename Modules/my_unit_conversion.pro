;+
;-
;- 27 December 2023
;-  Moved part of Codes/test.pro from 14 October 2022 to bottom of this file
;-   => at a glance, includes variables for Rsun, AU, theta_deg, !RADEG, + others
;-      so seems appropriate for now..
;-
;-
;- 04 November 2021
;- Unit conversion (since I can't figure out how to use IDL's canned routines,
;-   assuming they exist)
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

;---------------------------------------------------------------------------------------
; 14 October 2022

Rsun = 6.96e10
AU = 1.5e13

theta_rad = atan(Rsun/AU)
print, theta_rad

;theta_deg = theta_rad * (360. / (2*!PI))
theta_deg = theta_rad * !RADEG
print, theta_deg

theta_arcsec = theta_deg * 3600.
print, theta_arcsec

; double theta to get angle of full diameter
print, theta_arcsec*2.0

; arcsec / hour
print, ((theta_arcsec*2.0)/(15.*24))

; pixels / hour
print, ((theta_arcsec*2.0)/(15.*24)) / 0.6

; pixel shift over 5-hour time series
print, (((theta_arcsec*2.0)/(15.*24)) / 0.6) * 5.0

; Re-did computations, just to make sure
theta_arcsec = ((atan(Rsun/AU))*!RADEG)*3600*2
print, theta_arcsec

; Rotational period range (days -> hours)
period = ([26.0, 32.0]/2) * 24

; arcsec per hour
print, theta_arcsec / period

; pixels per hour
print, (theta_arcsec/0.6) / period

; pixels between images separated by 24 seconds
print, (((theta_arcsec/0.6)/period) / 3600.) * 24.

; pixels over 5-hour time series
print, ((theta_arcsec/0.6) / period) * 5.0

;---------------------------------------------------------------------------------------


end
