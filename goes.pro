;--+
; Created:       07 August 2018
; Last Modified: 12 August 2018

; Extracting and plotting GOES data.

goto, start

TVLCT, 255, 255, 255, 254
TVLCT, 0, 0, 0, 253
!P.Color = 253
!P.Background = 254

!P.Color = '000000'x
!P.Background = 'ffffff'x

; Object parameters ( = defaults):

    ; tstart  = start of day two days ago
    ; tend    = end of day two days ago
    ; sat     = most recent that contains tstart:tend
    ; sdac    = 2 (YOHKOH, then SDAC if YOHKOH not available)
    ; mode    = 0
    ; euv = (?) set to 1|2|3 for EUV A|B|E; set to 0 for XRS data
    ;                                         via sdac and mode
    ; clean = 1
    ; showclass = 1 (show classes on right side of plot)
    ; markbad = 1
    ; abund ; for calculation of temp and EM... ignore for now.
    ; itimes ; integration interval for E loss calcs... also ignore.

  ; Background
    ; bsub = 0 (subtract background - btimes required!)
    ; bfunc = 0poly (option to use 1poly, 2poly, 3poly, exp)
    ; btimes = 2 x N array of start/end times, for N time segments
    ; b0times ; channel 0 background
    ; b1times ; channel 1 background
    ; b0user = user defined background for channel 0
    ; b1user = user defined background for channel 1


; set using, e.g. a->set, kw=value


; My times
;tstart = '15-Feb-2011 00:00:00'
;tend   = '15-Feb-2011 04:59:59'

; times covered in Milligan2017 (to start)
tstart = '15-Feb-2011 01:40:00'
tend   = '15-Feb-2011 02:10:00'

; GOES satellite (pretty sure 15 is the default)
sat = 'goes15'

; Create object
a = OGOES()


; set parameters and plot:
a->SET, tstart=tstart, tend=tend, sat=sat


a->plot, charsize=1.5
stop

START:;----------------------------------------------------------------------------------

TOGGLE, /landscape, filename='goes.ps'

a->plot, xcharsize=1.25, ycharsize=1.25

TOGGLE

stop

; Or do both at once:
;a->plot, tstart=tstart, tend=tend, sat=sat

; Show current parameter values
a->help


;-- extract data and derived quantities into a structure
data = a->getdata(/struct)
help, data, /struct



stop


; GETDATA args/keywords, all of which are included with /struct:
;low = a->getdata( /low )       ; low channel only (1-8 A, or 0.5-4 A?)
high = a->getdata( /high )     ; high channel only (ditto)
times = a->getdata( /times )   ; time array and UTBASE
utbase = a->getdata( /utbase )


UTPLOT, times, high, utbase
;deri=deriv(times,high)


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






;oplot, data.ydata[*,1]



end
