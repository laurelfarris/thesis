;; Last modified:   14 July 2017 09:43:18

;; y = Latitude of sunspot group, in arcseconds
;; From hmi header, cdelt1 = 0.50422200 arcseconds per pixel (=~0.000138889 degrees per pixel)
;;   y = 2450 pixels relative to 4096x4096 image
;;     = 402 pixels from horizontal line through center (y = 2048)
;;     = 201 arcseconds

y = 201.

;; latitude in degrees
theta = y/3600.

a0 = 14.3
a1 = -2.4
a2 = -1.8

;; rotation rate [degrees per day]
w = a0 + a1 * (sin(theta))^2 + a2 * (sin(theta))^4

;print, "w = ", w, " degrees per day."

R = 6.96e10
AU = 1.5e13

b = R + AU
a = R
theta_c = w*!PI/180

x = R*tan(theta_c)
phi = atan(x/AU)
print, (phi*180/!PI)*3600 * 2


c = sqrt( a^2 + b^2 - 2*a*b*cos(theta_c))

;print, "w = ", w*(1./24.)*(3600./1.)*(1./0.5), " pixels per hour."

;; w = 14.2925 degrees per day
;;   = pixels per day
