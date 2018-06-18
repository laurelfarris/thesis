
; 14 June 2018

; Main code: align.pro

; NOTE: doing things in reverse order so I can just use stop command,
; rather than GOTO plus stop.



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

;; Cool


stop






;; Test that save will overwrite file if already exists
;test = 2
test = 2000
save, test, filename='test.sav'
test = !NULL
restore, 'test.sav'
help, test
stop

; Affirmative!


end
