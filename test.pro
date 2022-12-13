
;---------------------------------------------------------------------------------------------------------------
;13 December 2022


pro test, testid

    test_flare_id = 'x22'

    ; display nesting level of procedures/function
    help, /traceback

    print, 'The current flare id is: ', test_flare_id
    print, '  Is this correct?'
    ;read, 'Is this the flare you want?  ', response
    response = ''
    help, response
    read, response;, format='(A1)'
    help, response
    ;
    testid = ''
    ;testid = 'n'
    ;testid = 'y'
    testid = 'q'
    ;
    if ( strlowcase(testid) ne ( 'n' || 'y' || 'q' ) ) then begin
        print, "Incorrect input."
    endif else print, 'Great job!'
    ;
    testid = 'm73'
    print, 'Flare ID = ', testid
    ;
    read, testid, 'Type desired flare (or "enter" if already correct): '
    print, ''
    print, 'Flare ID = ', testid
    print, ''
    ;
    ;help, testid
end


test, 'm73'







;---------------------------------------------------------------------------------------------------------------
; 07 October 2022


cadence = 24.0

print, ''
headings = ['power', 'N', 't (sec)', 't (min)']
print, '   ' + headings

for ii = 0, 8 do begin
    NN = 2^ii
    duration = cadence * NN
    print, ii, NN, fix(duration), fix(duration/60.0)
;    print, ii, round(duration)
;    print, ii, round( 2^(float(ii)))
;    print, ii, 2.0^ii
endfor


print, 1000. * (1./(64*24))



nuc = 5.6
nu = 5.4
res = 0.65
dnu = 1.0
;
print, ''
print, nuc - (dnu/2), nuc + (dnu/2)
print, nu-res, nu+res
print, ''




;-----------------------------------------------------------------------------------------------------------------
; 14 October 2022


Rsun = 6.96e10
AU = 1.5e13
;
theta_rad = atan(Rsun/AU)
print, theta_rad
;
;theta_deg = theta_rad * (360. / (2*!PI))
theta_deg = theta_rad * !RADEG
print, theta_deg
;
theta_arcsec = theta_deg * 3600.
print, theta_arcsec

;
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

end
