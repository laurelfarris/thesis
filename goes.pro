; 07 August 2018
; GOES objects

goto, start


tstart = '15-Nov-2011 00:00:00'
tend   = '15-Nov-2011 04:59:59'

tstart = '15-Nov-2011 01:40:00'
tend   = '15-Nov-2011 02:10:00'

sat = 'goes15'

a = ogoes()
a->set, tstart=tstart, tend=tend;, sat=sat




;-- extract data and derived quantities into a structure
data = a->getdata(/struct)
help, data, /struct

a->plot

oplot, data.ydata[*,1]

start:
stop


; Example from website:
;** Structure <70774e0>, 15 tags, length=3936, data length=3928, refs=1:
;UTBASE STRING '22-Mar-2002 18:00:00.000' ; utbase time
;TARRAY LONG Array[61]         ; time array in seconds relative to utbase
;YDATA FLOAT Array[61, 2]      ; 2 channels of GOES data in watts/m^2
;YCLEAN FLOAT Array[61, 2]     ; 2 channels of cleaned GOES data in watts/m^2
;YBSUB FLOAT Array[61, 2]      ; 2 channels of cleaned background-subtracted data in watts/m^2
;BK FLOAT Array[61, 2]         ; 2 channels of computed background in watts/m^2
;BAD0 INT -1                   ; indices for channel 0 array that were bad
;BAD1 INT -1                   ; indices for channel 1 array that were bad
;TEM DOUBLE Array[61]          ; temperature array in MK
;EM DOUBLE Array[61]           ; emission measure array in cm^-3 * 10^49
;LRAD DOUBLE Array[61]         ; total radiative energy loss rate (or integral) array in erg/s
;LX FLOAT Array[61]            ; radiative energy loss rate in X-rays (or integral) array in erg/s
;INTEGRATE_TIMES STRING Array[2]   ; integration time interval
;YES_CLEAN INT 1               ; 0/1 means data wasn't / was cleaned
;YES_BSUB INT 1                ; 0/1 means background wasn't / was subtracted





end
