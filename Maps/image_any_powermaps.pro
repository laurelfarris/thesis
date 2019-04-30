;+
;- LAST MODIFIED:
;-   Tue Feb 12 12:12:38 MST 2019
;-
;- PURPOSE:
;-   General routine for imaging powermaps... for real this time!
;-   One place for anything that changes from one figure to the next.
;-   12 February 2019 - pulling code from all others to get complete list. 
;-
;- INPUT:
;-   None (currently runs from main level).
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   See "../Subregions/powermap_subregions.pro" for more parameters (potentially).
;-
;-
;- To keep in mind:
;-   Could edit this code directly, or copy into another routine.
;-   
;-   It's okay that this is at the main level (for now).
;-   Better than constantly typing the same code and
;-     dealing with the same errors over and over.
;-
;-




;----------------------------------------------------------------------------------
;+
;- CROP data in xy direction, if desired
;-   Not sure about order yet, i.e. if this should go before or after
;-   setting up NN.
;- Definitely crop before computing power maps, obviously.


center = [ 225, 175 ]
r = 200

;- Distinguish between simply assigning numbers and
;-  actually using them
;-   to alter data (or create new data array) for imaging.
;- Would have to go after defining z_ind, since it's used in CROP_DATA function...

imdata = CROP_DATA( $
    A[cc].map, $
    center=center, $
    dimensions=[r,r], $
    z_ind=z_ind )

;----------------------------------------------------------------------------------
;+
;- ROIs
;-

;- center of coords for ROIs, NOT for cropping data!
center = [ $
    [000, 000] ]
r = 10 ; pixel size






;----------------------------------------------------------------------------------
;+
;- "The usual"

cc = 0
time = strmid(A[cc].time,0,5)
dz = 64

;- nn = n_elements( array of changes from one panel to the next )
;-   Generally equal to third dimension of image stack, but usually
;-   predined so it's a shorthand used to PREDEFINE dimemsions...

;----------------------------------------------------------------------------------
;+
;- Define z/t indices
;-   (pulled from various codes).
;-


;- image_powermaps.pro (this code)
z_ind = [0, 197]


;- bda_powermaps.pro
;t0 = '01:05'
;t0 = '01:23'
; 01:23 - 02:34 --> z = 207 - 386
t0 = '00:24'
time = strmid(A[0].time, 0, 5)
z0 = (where( time eq t0 ))[0]
zf = z0 + NM*dz - 1
z_ind = [z0:zf]
print, time[z_ind[0]]
print, time[z_ind[-1]]
data = A.data[*,*,z_ind,*]
sz = size(data, /dimensions)


;- image_bda_powermaps.pro
;-    (BDA z-indices)
;phase = "before"
;z_start = [0, 16, 27, 58, 80, 90, 147, 175, 196]
;phase = "during"
;z_start = [197, 200, 203, 216, 248, 265, 280, 291, 311]
phase = "after"
z_start = [ 387, 405, 450, 467, 475, 525, 625, 660, 685 ]

;-


nn = n_elements(z_ind)

;- Titles, one way
title = strarr(nn)
foreach zz, z_ind, ii do begin
    title[ii] = A[cc].name + ' ' + $
        time[zz] + '-' + time[zz+dz-1] + ' UT' + $
        ' (' + strtrim(zz,1) + '-' + strtrim(zz+dz-1,1)  + ')'
endforeach

;- Titles, another way

titles = []
for cc = 0, 1 do begin
    for ii = 0, NM-1 do begin
        ind = indgen(dz) + z0 + (dz*ii)
        titles = [ titles, $
            A[cc].channel + '$\AA$ ' + $
            time[ind[0]] + '-' + time[ind[-1]] ]
    endfor
endfor
titles = 'AIA ' + titles + ' UT'
titles = reform( titles, NM, 2)
;-    Both channels in one graphic? maybe don't do this?
;-    Just put "aia1600_" or "aia1700_" in filename.
;-    This would avoid 4D data sets, but may need to preserve each channel so can
;-      switch back and forth without re-calculating every time...



;----------------------------------------------------------------------------------
;+
;- Central period/frequency
;-


bandwidth = 0.001

;- Define z index
;-   (same for all maps when central period/frequency is changing)
z_start = 75
;z_start = [197] ;- pre-flare
;z_start = [204] ;- pre-flare/impulsive
;z_start = [450] ;- post-flare

;- frequency/period of interest,
;-   probably followed by calculation of new maps.
;period = [50, 120, 180, 200, 300, 500]
period = [120, 180, 300]
period = [180]



nn = n_elements(period)



;- Titles
title = strarr(nn)
foreach pp, period, ii do begin
    title[ii] =  A[cc].name + ' ' + $
    ;strtrim(fcenter[ii]*1000, 1) + ' mHz ('  + $
    strtrim(pp, 1) + ' sec ' + $
    '(' + time[z_start] + '-' + time[z_start+dz-1] + ' UT'
endforeach
stop

;----------------------------------------------------------------------------------
;+
;- MASK for map and/or image data.
;-

;- bda_powermaps.pro
mask1 = fltarr(sz)
threshold = 10000
mask1[where( data lt threshold )] = 1.0
mask1[where( data ge threshold )] = 0.0
sat = where(mask1 eq 0.0)
unsat = where(mask1 eq 1.0)


;- also see image_bda_powermaps.com, which may have been written before
;-  powermap_mask, a subroutine that computes masks and applys to maps separtely.



;----------------------------------------------------------------------------------
;+
;- Imaging
;-

@color ; polygons... maybe.

;- Scale data for better contrast in images.
imdata = alog10(map[*,*,*,cc])
;imdata = AIA_INTSCALE( map[*,*,*,cc], wave=fix(A[cc].channel), exptime=A[cc].exptime )
;imdata = (map[*,*,*,cc])^0.2


rows = 1
cols = 3

width = 2.5
height = width * float(sz[1])/sz[0]

im = image3( $
    imdata, $
    buffer=0, $
    ;wx=, $ ;- --> default = 8.0
    rows=rows, $
    cols=cols, $
    ;top=, left=, right=, bottom=, xgap=, ygap=,  $
    xshowtext=0, $
    yshowtext=0, $
    ;min_value=1.2*min(map), $
    ;max_value=0.5*max(map), $
    ;min_value = min(image_data), $
    ;max_value = max(image_data), $
    title = title, $ ; title = ARRAY of titles, one for each panel.
    ;rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ), $
    rgb_table=A[cc].ct )


end
