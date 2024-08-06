;+
;
;-

PRO pickpeakperiod,power,maxper,period,perpower

;size of the power 'image'
sp = SIZE(power)

;number of time elements:
ntel = (size(power))(1)

nscale = (size(power))(2)

maxper = DBLARR(ntel)
perpower = DBLARR(ntel)

pers=REVERSE(period)

    for i=0,ntel-1 DO BEGIN
    	
	column = reform(power(i,*))
	colmax = where(column eq max(column))
	
	maxper(i) = period(colmax)
	perpower(i) = DOUBLE(column(colmax))
	
    END
    
END
