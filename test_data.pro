
; email from Prof. James (22 June)

goto, start

;filename = '~/Dropbox/test_data.ps'
;TOGGLE, $
    ;color=color, $
    ;/landscape, $ ; plot orientation (default=portrait)
    ;print=print, $
    ;queue=queue,  $
    ;eps=eps, $
    ;/legal, $ ; page size (default=letter)
;    filename=filename

common defaults

restore, '../test_data.sav'
help, lc1
help, time

start:

;plot, time, lc1
w = 8.5
h = 4.0
win = window( dimensions=[w,h]*dpi, buffer=1 )
p = plot2( time, lc1, layout=[1,1,1], color='red', current=1 )
;p = plot2( time, lc1, layout=[1,1,1], color='red', buffer=1 )

p.save, '~/Dropbox/test_data.pdf', $
    page_size=[w,h], width=w, height=h


end
