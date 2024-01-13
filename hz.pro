; 13 January 2024
;   quick code to convert frequency (mHz0) to period
;   in seconds and/or minutes.



mhz = 10.0

;-----

hz = mhz / 1000.

Tsec = 1.0/hz
Tmin = Tsec / 60.



print, Tsec

print, Tmin

end
