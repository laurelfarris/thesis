
;- 17 November 2018

goto, start

start:;-------------------------------------------------------------------------------------------------

journal, '2018-11-17.pro'


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
