;+
;- 04 May 2020
;-   AIA_PREP --> last hour of C3.0 flare on 2013-12-28
;-


buffer = 1


@parameters
;- 04 May 2020
;-   Edit top of code:
;-    flare_num = 0  ; X flare
;-    flare_num = 1  ; C flare
;-    flare_num = 2  ; M flare
;-
;-  No idea why I added the lines above... "today.pro" is simply a log of
;-   whatever I'm working on "today", and cotains
;-  notes I will only refer to when needed but not re-usable modules",
;-   or perhaps something a little more clever.
;-
;-

;path = 
;print, path
;-

;path = '/solarstorm/laurel07/' + ['20131228/', '20140418/']
;restore, path[0] + 'aia1600shifts.sav'
;help, aia1600shifts
;restore, path[0] + 'aia1700shifts.sav'
;help, aia1700shifts
;help, aia1700_shifts


;-----------


path = '/solarstorm/laurel07/' + year + month + day + '/'
print, path
stop


;+
;- 10:00 AM
;- Time to process final hour of 2013 flare observations (finally)
;-
;- IDL routine:
;-   /solarstorm/laurel07/thesis/Prep/apply_aia_prep.pro
;-             aka, "work" + Prep/apply_aia_prep.pro
;-
;-
;-
;-


;fls = file_search(path + '*1600*.sav')
;fls = file_search(path + '*1700*.sav')

fls = file_search(path + '*.sav')
;help, fls
;print, fls

foreach file, fls, ii do begin
    ;restore, path + 'aia1600aligned_old.sav'
    restore, file
    ;-
    print, ''
    print, file
    ;print, file eq "\*old.sav"
    if strmatch( file, '*_old.sav' ) then begin
        ;print, 'STRMATCH works!!!!'
        ;stop
        print, 'old .sav file --> creating old variable:'
        old_cube = cube
        help, cube
        help, old_cube
    endif
    ;-
;    print, max(cube)
;    print, max(old_cube)
;    print, min(cube)
;    print, min(old_cube)
;    stop
    ;-
endforeach

;------------

foreach file, fls, ii do begin
    ;-
    if STRMATCH( file, 'aia1600shifts.sav' ) then begin
        print, file
        help, shifts
        print, max(shifts)
    endif
    ;-
    if STRMATCH( file, '*aia1600new_shifts.sav*' ) then begin
        print, file
        help, shifts
;        new_shifts=shifts
;        print, max(new_shifts)
    endif
    ;-
endforeach

;cube_old = cube
;help, cube_old

;restore, path + 'aia1600aligned.sav'
;help, cube
;- --> INT   = Array[1000,800,596]


;-
print, path
help, shifts
stop



;-
;file = 'aia1600shifts.sav'
;file = 'aia1600new_shifts.sav'
;file = 'aia1700shifts.sav'
;-
;file = 'aia1600map.sav'
;file = 'aia1700map.sav'
;-


;------------------

file = 'aia1600aligned.sav'
restore, path + file
aia1600cube = cube
undefine, cube
;-
file = 'aia1600aligned_old.sav'
restore, path + file
aia1600cube_old = cube
undefine, cube
;-

file = 'aia1700aligned.sav'
restore, path + file
aia1700cube = cube
undefine, cube


help, cube
;-
help, aia1600cube
help, aia1600cube_old
;-
help, aia1700cube

;------------------

;file = 'aia1600map.sav'
file = 'aia1700map.sav'
restore, path + file
help, map

aia1600map = map
undefine, map
;-
;------------------



;help, shifts




;- AIA 1600 only, for 2014 M-class flare (04 May 2020)
new_shifts = shifts
help, new_shifts


;-
print, stddev(shifts[0,*,0])
print, max(shifts[0,*,0])
print, min(shifts[0,*,0])


print, stddev(new_shifts[0,*,0])
print, max(new_shifts[0,*,0])
print, min(new_shifts[0,*,0])


;------------------------------------

restore, path + 'aia1600shifts.sav'
help


restore, path + 'aia1600shifts.sav'


;------------------------------------



undefine, shifts
undefine, new_shifts
;-
restore, path + 'aia1600shifts.sav'
;restore, path + 'aia1700shifts.sav'
help, shifts

undefine, shifts

restore, path + 'aia1600new_shifts.sav'
help, new_shifts

end
