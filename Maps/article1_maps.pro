;+
;- LAST MODIFIED:
;-   05 March 2020
;-
;- PURPOSE:
;-   2x2 image of intensity (top) and power maps (bottom) for
;-    AIA 1600 (left) and AIA 1700 (right)
;-
;- USEAGE:
;-   Uncomment filename of window to be imaged.
;-   3 separate figures, one for each window.
;-
;- To do:
;-   Improve procedure for selecting flare phase (aka no hard-coding, or
;-   sloppy commenting/uncommenting), preferably without re-defining
;-   contour data (c_data) every time routine runs.
;-
;- To consider:
;-   There's a very significant difference between
;-     lines of code that define variables (e.g. dz=64) and those that perform
;-     actual computations, which can take time to run (e.g. c_data=...)
;-     Consider this when writing subroutines ( Wed Feb 20 03:56:27 MST 2019 )
;-
;- 31 July 2019:
;- Is this specifically for addressing the referee comments after article1
;-  was submitted to ApJ?
;-
;-


;+
;- User-defined parameters
;-

buffer=0

;-
;- Flare phase: [] uncomment one of the three phases (BDA) to image.
filename = 'before'
;filename = 'during'
;filename = 'after'

;+
;- 21 February 2019 -- multiply intensity by saturation mask
;data_mask = A[0].data lt threshold/A[0].exptime
;- ...   ?? (05 March 2020)
;-

;-
dz = 64
threshold = 10000.
;-   threshold lowered from 15000 (saturation threshold) to exclude pixels
;-    contaminated by bleeding/blooming.
;-     --> How do I know what value to use for new threshold??
;-      Is there a standard? Pretty sure I "eyeballed" this... :(
;-

;-------------------------------------------------------------------------

;@restore_maps
;- script is causing problems... run on IDL command line using .RUN restore_maps
;-  (05 March 2020)
;-

resolve_routine, 'powermap_mask', /is_function
;- 24 January 2020
;-   NOTE: set kw 'exptime' in call to powermap_mask function
;-     to ensure that threshold value is also corrected for it.
;-     Calculation is performed in subroutine: threshold / exptime,
;-     provided that condition "keyword_set(exptime)" is met.
;-


aia1600mask = POWERMAP_MASK( $
    A[0].data, dz=dz, exptime=A[0].exptime, threshold=threshold )
aia1700mask = POWERMAP_MASK( $
    A[1].data, dz=dz, exptime=A[1].exptime, threshold=threshold )




;-
;-
print, max(A[0].map)
print, max(A[1].map)
;-
A[0].map = A[0].map * aia1600mask
A[1].map = A[1].map * aia1700mask
;-
print, max(A[0].map)
print, max(A[1].map)
;-  Horrible way to update maps ... could accidentally repeat these lines
;-   continually updating variables that should have only been changed once.
;-  However, masks are all 1s and 0s, so once multiplied once,
;-    values shouldn't change no matter how many times this code is run
;-   on the same modified variables.
;-     I still don't like it, but whatev.
;-
;--------------


;+
;- "The usual"
;-


time = strmid(A[0].time,0,5)
;-
;-
;+
;- Define z/t indices
;-
if filename eq 'before' then z_start = [197]
if filename eq 'during' then z_start = [261]
if filename eq 'after' then z_start = [450]
;-
;+
;- Contour data
;-
resolve_routine, 'get_contour_data', /either
c_data = GET_CONTOUR_DATA( time[z_start : z_start+dz-1], channel='mag' )
;-
nn = 2
;-
dat_title = strarr(nn)
map_title = strarr(nn)
for cc = 0, 1 do begin
    dat_title[cc] = A[cc].name + ' intensity (' + $
        time[z_start] + '-' + time[z_start+dz-1] + ' UT)'
    map_title[cc] = A[cc].name + ' 5.6 mHz (' + $
        time[z_start] + '-' + time[z_start+dz-1] + ' UT)'
endfor
;-
intensity = alog10 ( mean( A.data[*,*,z_start:z_start+dz-1, *], dimension=3 ) )
min_value = [ min(intensity[*,*,0]), min(intensity[*,*,1]) ]
;-
intensity = intensity * [ $
    [[aia1600mask[*,*,z_start]]], [[aia1700mask[*,*,z_start]]] ]
struc = { $
    imdata : [ $
        ;[[ alog10 ( mean( A.data[*,*,z_start:z_start+dz-1, *], dimension=3 ) ) ]], $
        [[ intensity ]], $
        [[ alog10( A.map[*,*,z_start,*] ) ]] ], $
    title : [ dat_title, map_title ], $
    cbar_title : [ 'log intensity', 'log intensity', 'log power', 'log power' ] $
}
;-
;--- Wed Feb 20 04:33:33 MST 2019 ---;
;testdat = mean( A.data[*,*,z_start:z_start+dz-1, 0], dimension=3 )
;testmap = A.map[*,*,z_start,0]
;-  Why are these returning arrays with 2 images each?? Should be 1!

;testdat = mean( A[0].data[*,*,z_start:z_start+dz-1], dimension=3 )
;testmap = A[0].map[*,*,z_start]
;-  Guess A should be indexed, rather than putting '0' as fourth dimension...
;-   still don't know why it works this way, but whatev.
;---


;----------------------------------------------------------------------------------
;+
;- Imaging
;-

rows = 2
cols = 2
dw
im = image3( $
    struc.imdata, $
    buffer=buffer, $
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
    title = struc.title )

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
;-
im[2].rgb_table = A[0].ct
im[3].rgb_table = A[1].ct
;-
;power_ct = 73
;im[2].rgb_table = power_ct
;im[3].rgb_table = power_ct
;im[2].rgb_table = reverse(im[2].rgb_table, 2)
;im[3].rgb_table = reverse(im[3].rgb_table, 2)

;resolve_routine, 'color_tables', /is_function
;im[2].rgb_table = color_tables()
;im[3].rgb_table = color_tables()

save2, filename

end
