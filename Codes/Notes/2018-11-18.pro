
;- 18 November 2018

goto, start

start:;-------------------------------------------------------------------------------------------------

journal, '2018-11-17.pro'




xdata = gdata.tarray
ydata = gdata.ydata

ytitle = gdata.utbase

;- try alog10(goesflux)

ylog = 1

y1 = A[0].flux - min(A[0].flux)
y2 = A[1].flux - min(A[1].flux)

win = window(dimensions=[8.0,6.0]*dpi )
plt = plot2( indgen(749), y1, /current, color='blue', ylog=ylog )
plt = plot2( indgen(749), y2, /overplot, color='red', ylog=ylog )

;plt = plot2( xdata, ydata[*,0], /overplot,  ylog=ylog )


;- To do:
;-      HMI prep routine
;-      Contours
;-      All 4 data types??


stop
; What happens if journal is edited directly before closing?
print, ''
print, '--> Type .CONTINUE to close journal.'
print, ''
stop
journal


;Result = GET_SCREEN_SIZE( [Display_name] [, RESOLUTION=variable] )

;- Power spectra:
;-   Don't have to show full range of frequencies from Milligan2017.
;-

end
