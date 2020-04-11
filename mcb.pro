;Copied from clipboard


resolve_routine, 'colorbar2', /is_function
resolve_routine, 'plot_contours', /is_function
;-
c_pos = '3a3a3a'x  ;237
c_neg = '000000'x ;black
;-
for ii = 0, n_elements(im)-1 do begin
    contourr[ii] = PLOT_CONTOURS( $
        c_data, target=im[ii], channel='mag', $
        c_color=[[c_neg], [c_pos]], $
        c_thick=[0.5,0.1] )
    cbar[ii] = COLORBAR2( $
        target=im[ii], $
        thick=0.5, $
       ;title=struc.cbar_title[ii] )
       title=cbar_title[ii] )
endfor
;-
;-
cbar[2].tickinterval=2
cbar[3].tickinterval=2
;-
;-
;- Use same min/max value for all three phases (BDA)
im[2].min_value = -3
im[3].min_value = -3
im[2].max_value = max(struc.imdata[*,*,2:3])
im[3].max_value = max(struc.imdata[*,*,2:3])
;-
;-
;- Color tables
im[2].rgb_table = A[0].ct
im[3].rgb_table = A[1].ct
;-
save2, filename
;-
;-

end

