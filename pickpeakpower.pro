;+
;
;-

PRO pickpeakpower,power,maxfreq,f_inver,freqpower

;size of the power 'image'
sp = SIZE(power)

;number of time elements:
ntel = (size(power))(1)

nscale = (size(power))(2)

maxfreq = DBLARR(ntel)
freqpower = DBLARR(ntel)

freqs=REVERSE(f_inver)

    for i=0,ntel-1 DO BEGIN
    	
	column = reform(power(i,*))
	colmax = where(column eq max(column))
	
	maxfreq(i) = f_inver(colmax)
	freqpower(i) = DOUBLE(column(colmax))
	
    END
    
END
