;Copied from clipboard


rows = 2
cols = 2
dw
resolve_routine, 'image3', /is_function
im = image3( $
    struc.imdata, $
    rows=rows, $
    cols=cols, $
    left=0.1, $
    bottom = 0.1, $
    top= 0.3, $
    ygap=0.4, $
    xgap=0.8, $
    right=1.0, $
    xshowtext=0, $
    yshowtext=0, $
    title = struc.title, $
    buffer=buffer )
;-
im[0].rgb_table = A[0].ct
im[1].rgb_table = A[1].ct
im[0].min_value = min_value[0]
im[1].min_value = min_value[1]
;-
contourr = objarr(n_elements(im))
    ;-   terrible variable name ...
cbar = objarr(n_elements(im))
resolve_routine, 'colorbar2', /is_function
resolve_routine, 'contours', /is_function
;-
;c_neg = "black"
;c_neg = [0,0,0]
;c_pos = "yellow"
;-
; various shades of gray (darkest at top)
;c_pos = '303030'x  ;236
c_pos = '3a3a3a'x  ;237
;c_pos = '444444'x  ;238
;c_pos = '4e4e4e'x  ;239
;c_pos = '585858'x  ;240
; ...
; 'eeeeee'x  ;255  --> basically white
;-
c_neg = '000000'x ;black
;-
for ii = 0, n_elements(im)-1 do begin
    contourr[ii] = CONTOURS( $
        c_data, target=im[ii], channel='mag', $
        ;color=c_pos, $
        c_color=[[c_neg], [c_pos]], $
        c_thick=[0.5,0.1] )
    cbar[ii] = COLORBAR2( $
        target=im[ii], $
        ;tickinterval=1.0, $
        ;minor=4, $
        thick=0.5, $
       title=struc.cbar_title[ii] )
endfor
;-
cbar[2].tickinterval=2
cbar[3].tickinterval=2
;cbar[2].tickvalues=[-3:5:2]
;cbar[3].tickvalues=[-3:9:2]
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
;power_ct = 73
;im[2].rgb_table = power_ct
;im[3].rgb_table = power_ct
;im[2].rgb_table = reverse(im[2].rgb_table, 2)
;im[3].rgb_table = reverse(im[3].rgb_table, 2)
;-
;resolve_routine, 'color_tables', /is_function
;im[2].rgb_table = color_tables()
;im[3].rgb_table = color_tables()
;-
save2, filename

end

