
; 29 June 2018
; comparing flux - mean(flux) for raw data and normalized data (between 0 and 1)

; 19 June 2018

pro blah, flux, cadence, freq, power, phase, amp

    common defaults
    wx = 8.5
    wy = 5.0
    w = window( dimensions=[wx,wy]*dpi )

    p = plot2( flux, /current, layout=[2,1,1], xtitle='time', ytitle='flux')

    result = fourier2(flux, 24)
    freq = reform(result[0,*])
    power = reform(result[1,*])
    phase = reform(result[2,*])
    amp = reform(result[3,*])

    p = plot2( freq, power, /current, layout=[2,1,1], xtitle='frequency', ytitle='power' )

end

print, 'blah'
stop

N = 100
x = findgen(N) * (4*!PI/N)
y0 = sin(x)
y1 = y1 * 10 ; Should have HIGHER power than y0 (norm=0)
y2 = y1 + 10 ; Should have SAME power as y0 (norm=0)

; if norm=1, then power would be the same in all cases?
; What affects power BESIDES variation?
; I guess setting norm=1 would help reveal this...

get_fit, y0, 24
get_fit, y1, 24

stop


; 14 June 2018

; Main code: align.pro



x = findgen(10) - 5
y = 10.^x

p = plot2( x, y, yrange=[1.1e-5,1.1e5], ylog=1  )

stop

;; Test that READ will return empty string by just pressing enter.
result = ''
print, ''
read, result, prompt='Hit enter: '
help, result

if result eq '' then print, "This works!"
if result ne '' then print, "Not an empty string!"
stop

;; Cool

;; Test that save will overwrite file if already exists
;test = 2
test = 2000
save, test, filename='test.sav'
test = !NULL
restore, 'test.sav'
help, test
stop

; Affirmative!



; 06 July 2018
; IDL dictionaries

result = dictionary( 'name', 'AIA 1600$\AA$', 'cadence', 24 )

print, result['name']
print, result.name

;print, result.Count()
;result.IsFoldCase()
;result.Keys()
;print, result.HasKey('namee')

;result.Remove, 'cadence'
;print, result.Remove( 'cadence' )
;print, result.Remove( 'name' )

end
