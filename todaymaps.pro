;+
;- LAST MODIFIED:
;-   17 June 2019
;-
;- PURPOSE:
;-   2x2 image of intensity (top) and power maps (bottom) for
;-    AIA 1600 (left) and AIA 1700 (right)
;-
;- USEAGE:
;-   Uncomment filename of time segment to be imaged.
;-   3 separate figures, one for each time segment.
;-
;- To do:
;-   Better way to change between BDA, preferably without re-defining
;-   contour data (c_data) every time.
;- 
;- To consider:
;-   There's a very significant different between
;-     lines of code that define variables (e.g. dz=64) and those that perform
;-     actual computations, which can take time to run (e.g. c_data=...)
;-     Consider this when writing subroutines ( Wed Feb 20 03:56:27 MST 2019 )


goto, start

@restore_maps

;+
;- 21 February 2019 -- multiply intensity by saturation mask

;threshold = 10000.
;data_mask = A[0].data lt threshold/A[0].exptime

aia1600mask = POWERMAP_MASK( $
    A[0].data, $
    dz=64, $
    exptime=A[0].exptime, $
    threshold=10000. )


aia1700mask = POWERMAP_MASK( $
    A[1].data, $
    dz=64, $
    exptime=A[1].exptime, $
    threshold=10000. )
stop


;+
;- "The usual"


filename = 'before'
;filename = 'during'
;filename = 'after'

cc = 0
time = strmid(A[cc].time,0,5)
dz = 64

;+
;- Define z/t indices
;-
if filename eq 'before' then z_start = [197]
if filename eq 'during' then z_start = [261]
if filename eq 'after' then z_start = [450]

;+
;- Contour data
;-
resolve_routine, 'get_contour_data', /either
c_data = GET_CONTOUR_DATA( time[z_start : z_start+dz-1], channel='mag' )

nn = 2

dat_title = strarr(nn)
map_title = strarr(nn)
for cc = 0, 1 do begin

    dat_title[cc] = A[cc].name + ' intensity (' + $
        time[z_start] + '-' + time[z_start+dz-1] + ' UT)'

    map_title[cc] = A[cc].name + ' 5.6 mHz (' + $
        time[z_start] + '-' + time[z_start+dz-1] + ' UT)'
endfor


intensity = alog10 ( mean( A.data[*,*,z_start:z_start+dz-1, *], dimension=3 ) )
min_value = [ min(intensity[*,*,0]), min(intensity[*,*,1]) ]
;print, min_value
;help, min_value

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
start:;---------------------------------------------------------------------------------

rows = 2
cols = 2
dw
im = image3( $
    struc.imdata, $
    buffer=1, $
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

contourr = objarr(4)
resolve_routine, 'colorbar2', /is_function
resolve_routine, 'contours', /is_function
for ii = 0, n_elements(im)-1 do begin
    contourr[ii] = CONTOURS( $
        c_data, target=im[ii], channel='mag', $ ;c_linestyle=2, $  --> TERRIBLE
        c_thick=0.5 )
    cbar = COLORBAR2( $
        target=im[ii], $
;        tickinterval=1.0, $
;        minor=4, $
        title=struc.cbar_title[ii] )
endfor

im[2].min_value = -3
im[3].min_value = -3
im[2].max_value = max(struc.imdata[*,*,2:3])
im[3].max_value = max(struc.imdata[*,*,2:3])


;- Trying different colors for power maps (17 June 2019)
im[2].rgb_table = A[0].ct
im[3].rgb_table = A[1].ct
;power_ct = 74
;im[2].rgb_table = power_ct
;im[3].rgb_table = power_ct
;im[2].rgb_table = reverse(im[2].rgb_table, 2)
;im[3].rgb_table = reverse(im[3].rgb_table, 2)


contourr[0].c_color = []
contourr[1].c_color = []
contourr[2].c_color = []
contourr[3].c_color = []

save2, filename
end