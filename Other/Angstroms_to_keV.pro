
;- 18 October 2018

;- convert Angstroms to keV for the GOES 0.5-4.0\AA{} band:

;- wavelengths in Angstroms
lambda = [1.0, 8.0]
lambda = [0.5, 4.0]

;- Energy of a photon: E = hc/lambda
;- hc = ~1240 eV. Conversion to cgs: 1 erg = 6.2415 x 10^{11} eV
;- eV * (1 erg / 6.2415e11 eV erg^{-1})
hc = 1240.0 / 6.2415e11

;- Convert wavelength to cgs: 1\AA{} = 10^{-10} m = 10^{-8} cm
lambda = lambda * 1.e-8

;- Get energy in keV by converting wavelengths to cm 
E = hc/lambda

print, E, ' eV = ', E/1000., ' keV'

;- Should be 1.5 and 10 keV
;- Not getting the correct numbers, but I've spent way too much time on this...
