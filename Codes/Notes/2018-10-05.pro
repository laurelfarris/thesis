
;- 05 October 2018

;- Intensity
s1 = { data : float(aia_intscale( aia1600[*,*,0], wave=1600, exptime=A[0].exptime )), $
    extra : { $
        title : 'AIA 1600 intensity', $
        rgb_table : 1 } $
}

;- 3mOs
s2 = { data : aia1600map, $
    extra : { $
        title : 'AIA 1600 @ 5 mHz', $
        rgb_table : 3 } $
}

;- 5mOs
s3 = { data : aia1600map_5min, $
    extra : { $
        title : 'AIA 1600 @ 3 mHz', $
        rgb_table : 8 } $
}

;- "extra" --> anything that varies from one panel to the next


main_array = [s1, s2, s3]

w = window(/buffer)
for ii = 0, 2 do begin
    im = image2( $
        main_array[ii].data, $
        /current, $
        layout = [3,1,ii+1], $
        margin=0.1, $
        _EXTRA = main_array[ii].extra )
endfor

save2, 'test.pdf'



journal, '2018-10-01.pro'
; What happens if journal is edited directly before closing?

;CD, 'Prep/'
;.run prep
;CD, '../'

;Result = GET_SCREEN_SIZE( [Display_name] [, RESOLUTION=variable] )

N = 330.*500.
flux = A[0].flux/N
;result = fourier2(


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

end
