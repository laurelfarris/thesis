;; Last modified:   03 April 2018 17:34:01



function GET_FREQUENCIES, $
    data=data, $
    cadence=cadence, $
    dz=dz, $
    ;f_center=f_center, $
    T=T

    ; dz = Length of time series (# images)
    ; minT/maxT: Same idea as dt, but not nec. equal on each side of T_center.
    ; T_center = central period (seconds)
    ; f_center = central frequency (Hz)

    if not keyword_set(data) then data = indgen(dz)

    ; Array of possible frequencies (Hz) and periods (seconds)
    result = fourier2( data, cadence )
    frequency = reform( result[0,*] )

    ; frequency resolution (constant, but period resolution is NOT)
    ;f_res = (frequency - shift(frequency,1))[1]
    ;print, format='("df = ", F0.4, " mHz")', f_res*1000.

    ; if keyword_set(f_center) then begin ...
        ;f1 = 1./(T+dt)
        ;f2 = 1./(T-dt)
        ;ind = where( frequency ge f1 AND frequency le f2 )
        ;print, "Frequencies:"
        ;foreach i, period_array do print, 1000./i, format='(F10.2)'

    ; if keyword_set(f_center) then begin ...

        period = 1./frequency

        ;if not keyword_set(minT) then minT = min(period)
        ;if not keyword_set(maxT) then maxT = max(period)

        if not keyword_set(T) then $
            T = [ min(period), max(period) ]


        ind = where( period ge T[0] AND period le T[1] )

        print, ""
        ; Test that there are possible frequencies within the given bandpass.
        if ind[0] eq -1 then begin
            print, "ERROR: ", $
                "There are no possible frequencies in the given bandpass.", $
                "Returning."
            return, 0

        endif else begin

            possible_periods = period[ ind ]
            print, "Possible periods (in seconds) and indices:"
            foreach i, ind do begin
                ;print, period[i], format='(F10.1)', i
                print, period[i], i
            endforeach
        endelse

    return, fix(ind)

end

; z_start doesn't matter here. Just trying to figure out what
; possible frequencies I'd get back for a given dz (dt).

; Add easy way to put desired dt, and convert to dz?
; e.g. "I want to input a 10 minute time series, with given cadence."

; Currently not returning any values, just printing out periods
; within specified max/min.

; Working with just period for now, but eventually:
;    if both T_center and f_center are defined,
;    ERROR - give one or the other.

;temp = [ reform(cube[250,165, 0:224]), fltarr(500) ]


; NOTE: T_center is never actually used in calculations.


; What is the easiest (most intuitive) way to get the indices
; for the range of periods/frequencies I want?
; Defining frequency "bandpass" over which to take the total power.

frequency = reform( (fourier2( indgen(64), 24 ))[0,*] )
period = reverse( 1./frequency )
print, (where( period le 180. ))[-1]
print, (where( period ge 180. ))[ 0]




ind = GET_FREQUENCIES( $
    cadence=24, $
    dz=64, $
    T_center=180, $
    maxT=210, $
    minT=160 $
)


end
