


goto, start
start:;-----------------------------------------------------------------------------

;- 01 October 2018

journal, '2018-10-01.pro'
; What happens if journal is edited directly before closing?

CD, 'Prep/'
.run prep
CD, '../'

Result = GET_SCREEN_SIZE( [Display_name] [, RESOLUTION=variable] )

N = 330.*500.
flux = A[0].flux/N
result = fourier2(


print, ''
print, 'Type .CONTINUE to close journal.'
stop
journal


;- Power spectra:
;-   Don't have to show full range of frequencies from Milligan2017.
;-

;- Power maps:
;-   Multiply power maps by mask, which can be created using any threshold.
;-   Compare same power map using multiple thresholds.
;-   Show images used to compute maps: running average? standard deviation?
;-   How should power maps be scaled visually?  @methods
;-

stop


end
