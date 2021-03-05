;+
;- LAST MODIFIED:
;-   08 April 2020
;-
;-    Previous version : article1_maps_OLD_20200408.pro
;-


;-------------
;-  01 March 2021
;-     (Appears that I made a copy for version control, modified current version
;-      the same day, and haven't made any changes since).
;-     Actually the last modified date was 15 May 2020,
;-      but the last recorded modified date at top here was 08 April 2020.
;-    May have made tiny edits that did nothing to change the meat of the
;-   code, but should probably still update date mod, or don't make changes
;-   unless truly necessary).
;-------------

;-
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



;- IDL> .RUN struc_aia
;- IDL> .RUN restore_maps
;-
;- Compute powermap masks and set A.map = product of maps and masks.
;- IDL> .RUN powermap_mask
;-    sets dz and threshold at ML as well..
;-
;dz = 64
;threshold = 10000.
;-   lowered from 15000 to exclude pixels contaminated by bleeding/blooming.
;-
;aia1600mask = powermap_mask( A[0].data, dz=dz, threshold=threshold )
;aia1700mask = powermap_mask( A[1].data, dz=dz, threshold=threshold )
;stop



;------------------------------------------------------------------------------
buffer=1

;-
;- Flare phase: --> uncomment desired phase.
;filename = 'before'
filename = 'during'
;filename = 'after'



;------------------------------------------------------------------------------
;-
;- Define indices for z_start (index corresponding to desired start time)
if filename eq 'before' then z_start = [197]
if filename eq 'during' then z_start = [261]
if filename eq 'after' then z_start = [450]
;-
time = strmid(A[0].time,0,5)
;-
;----
;+
;- Extract subset of data from each channel over same time period
;- from which corresponding power map was obtained.
;- Average intensity through time to get more accurate representation
;-  of data that generated power maps.
;-
intensity = MEAN( A.data[*,*,z_start:z_start+dz-1, *], dimension=3 )
;- = FLOAT Array[500,330,2] (one image for each channel during current phase).

;print, min(intensity[*,*,0])
;print, max(intensity[*,*,0])
;print, min(intensity[*,*,1])
;print, max(intensity[*,*,1])

;------------------------------------------------------------------------------


;-
;imdata = [ $
;    [[ intensity[*,*,0] ]], $
;    [[ intensity[*,*,1] ]], $
;    [[ A[0].map[*,*,z_start] ]], $
;    [[ A[1].map[*,*,z_start] ]]  $
;]


;-
;+
imdata = [ $
    [[ (alog10(intensity[*,*,0])) * aia1600mask[*,*,z_start] ]], $
    [[ (alog10(intensity[*,*,1])) * aia1700mask[*,*,z_start] ]], $
    [[ (alog10(A[0].map[*,*,z_start])) * aia1600mask[*,*,z_start] ]], $
    [[ (alog10(A[1].map[*,*,z_start])) * aia1700mask[*,*,z_start] ]]  $
]

;test = A[0].map[*,*,z_start] * aia1600mask[*,*,z_start]
;print, min(test)
;locs = array_indices( test, where( test gt 0 ) )
;print, min( test[locs])



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
    title=title, $
    buffer=buffer )

;-
;- Color tables
im[0].rgb_table = A[0].ct
im[1].rgb_table = A[1].ct
;-
im[2].rgb_table = A[0].ct
im[3].rgb_table = A[1].ct
;-
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


;---------------------------
;im[2].min_value = -3.12
;im[3].min_value = -2.30
;im[2].min_value = -2.29
;im[3].min_value = -1.13

;im[2].max_value = 4.15
;im[3].max_value = 4.69
;im[2].max_value = 4.77
;im[3].max_value = 5.48

;---------------------------

;im[2].max_value = max(imdata[*,*,2:3])
;im[3].max_value = max(imdata[*,*,2:3])

im[0].min_value = 2.2
im[0].max_value = 3.3
;-
im[1].min_value = 2.6
im[1].max_value = 3.8
;-
;-
im[2].min_value = -2.0
im[2].max_value = 4.0
;-
im[3].min_value = -2.0
im[3].max_value = 4.0

;---------------------------



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
save2, filename + '_arrow'
;-

end
