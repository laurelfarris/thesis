;+
;- LAST MODIFIED:
;-   17 April 2020
;-
;- PURPOSE:
;-   2x2 image of intensity (top) and power maps (bottom) for
;-    AIA 1600 (left) and AIA 1700 (right)
;-
;- USEAGE:
;-
;- At beginning of new sswidl session, run the following at IDL command line to 
;- create structure A, restore maps from .sav files and add to struc, and
;- compute powermap masks by running powermap_mask once, rather than
;- defining masks in this routine and having to constantly comment and uncomment.
;-   (17 April 2020)
;-
;- IDL> .RUN struc_aia
;- IDL> .RUN restore_maps
;- IDL> .RUN powermap_mask
;-    NOTE: dz and threshold are defined at top of ML code in powermap_mask...
;-     This code is still a bit hacky and ugly, but will have to wait.
;-




buffer=1

filename = [ 'before', 'during', 'after' ]
z_start = [197, 261, 450]

;------------------------------------------------------------------------------


time = strmid(A[0].time,0,5)

;-
;----
;+
;- Extract subset of data from each channel that generated power map at
;-  z_start, and average over the same time period, where window duration = dz.
intensity = MEAN( A.data[*,*,z_start:z_start+dz-1, *], dimension=3 )
;- = FLOAT Array[500,330,2] (one image for each channel during current phase).
;help, intensity


foreach zz, z_start, ii do begin
endforeach

intensity = MEAN( A[0].data[ *, *, z_start : z_start + dz - 1 ], dimension=3 )
intensity = MEAN( A.data[*,*,z_start[0]:z_start[0]+dz-1, *], dimension=3 )
help, intensity

;-
;+
imdata = [ $
    [[ (alog10(intensity[*,*,0])) * aia1600mask[*,*,z_start] ]], $
    [[ (alog10(intensity[*,*,1])) * aia1700mask[*,*,z_start] ]], $
    [[ (alog10(A[0].map[*,*,z_start])) * aia1600mask[*,*,z_start] ]], $
    [[ (alog10(A[1].map[*,*,z_start])) * aia1700mask[*,*,z_start] ]]  $
]


BB = { $
    filename : 'before', $
    z_start : z_start[0], $


;+
;- Titles for each image and each colorbar.
;-
;- image titles for Intensity (top row) and power (bottom row) for
;-   1600 (left col) and 1700 (right col)
;-
dat_title = strarr(n_elements(A))
map_title = strarr(n_elements(A))
for cc = 0, 1 do begin
    dat_title[cc] = A[cc].name + ' intensity (' + $
        time[z_start] + '-' + time[z_start+dz-1] + ' UT)'
    map_title[cc] = A[cc].name + ' 5.6 mHz (' + $
        time[z_start] + '-' + time[z_start+dz-1] + ' UT)'
endfor
title = [ dat_title, map_title ]
cbar_title = [ 'log intensity', 'log intensity', 'log power', 'log power' ]
;struc = { $
;    imdata : [ $
;        ;[[ alog10 ( mean( A.data[*,*,z_start:z_start+dz-1, *], dimension=3 ) ) ]], $
;        [[ intensity ]], $
;        [[ alog10( A.map[*,*,z_start,*] ) ]] ], $
;    title : [ dat_title, map_title ], $
;    cbar_title : [ 'log intensity', 'log intensity', 'log power', 'log power' ] $
;}


;+
;- Contour data
resolve_routine, 'get_contour_data', /either
c_data = GET_CONTOUR_DATA( time[z_start : z_start+dz-1], channel='mag' )
;-


;+
;- Imaging
;-

rows = 2
cols = 2
dw
resolve_routine, 'image3', /is_function
im = image3( $
    ;struc.imdata, $
    imdata, $
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
    ;title = struc.title, $
    title=title, $
    buffer=buffer )
;-
im[0].rgb_table = A[0].ct
im[1].rgb_table = A[1].ct
;-
;----------
;+
;- 14 April 2020 -- confused by this...
;-
;- define min_value to apply when creating image graphics
;-   (2-elemnt array, one value per channel).
;min_value = [ min(intensity[*,*,0]), min(intensity[*,*,1]) ]
;-
;print, im[0].min_value
;print, min(imdata[*,*,0])
;-
;im[0].min_value = min_value[0]
;im[1].min_value = min_value[1]
;-
;-
;-
contourr = objarr(n_elements(im))
cbar = objarr(n_elements(im))
;-
;-
;-
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

;;im[2].max_value = max(struc.imdata[*,*,2:3])
;;im[3].max_value = max(struc.imdata[*,*,2:3])
im[2].max_value = max(imdata[*,*,2:3])
im[3].max_value = max(imdata[*,*,2:3])


;- define min_value to apply when creating image graphics
;-   (2-elemnt array, one value per channel).
min_value = alog10( [ min(intensity[*,*,0]), min(intensity[*,*,1]) ] )
print, min_value
;-
;print, im[0].min_value
;print, min(imdata[*,*,0])
;-

im[0].min_value = min_value[0]
im[1].min_value = min_value[1]

;-
;- Color tables
im[2].rgb_table = A[0].ct
im[3].rgb_table = A[1].ct
;-


;+
;- testing different things to figure out how I produced maps with saturated
;-  pixels = 0.0 and showing up black, but pixel values where LOG = value
;-   LESS THAN 0.0 are still represented... did I set saturated pixels to
;-  the minimum value of LOG(map), rather than 0? Can see why this would be
;-  confusing to referee... should re-read comments with this in mind.
;- (14 April 2020)
;im[2].min_value = 0.0
;im[3].min_value = 0.0


;save2, filename

;-----------------------------------------------------------------------------
;- 17 April 2020



;+
;--- Overlay ARROW graphic(s) on images,
;-     using code copied from Notes/2020-03-05.pro and modified as needed.
;-

;- center coords of ROI
center = [382,192]
;-
;- 'offset' = distance between ROI center and tip of arrow
offset = 10
;-
;- 'arrow_mag' = arrow magnitude, or length of arrow shaft.
arrow_mag = 25
;-

;------


;- x and y components of arrow, calculated using Pythagorean theorem.
xycomp = sqrt( (arrow_mag^2)/2 )
;-
x0 = center[0]
y0 = center[1]
;-
;- X and Y args for ARROW function (endpoint coords of arrow graphic).
x2 = x0 + offset
y2 = y0 - offset
x1 = x2 + xycomp
y1 = y2 - xycomp
;-



resolve_routine, 'arrow2', /is_function
;- defaults in arrow2:
;-   /data
;-   head_angle = 45
;-   head_indent = 0
;-   fill_background = 1
;-
myarrow = objarr(2)
for cc = 0, 1 do begin
    myarrow[cc] = ARROW2( $
        [x1,x2], [y1,y2], $
        target=im[cc+2], $
        thick=3.0, $
        ;line_thick=2.0, $
        head_angle=30, $   ;- default in my subroutine (arrow2) = 45 degrees.
        head_size=0.5, $    ;- forgot what this is...
        fill_background=1 )
endfor
print, myarrow[0].thick
print, myarrow[0].line_thick ; IDL default = 1.0



;-
stop
save2, filename + '_arrow'
;-

end
