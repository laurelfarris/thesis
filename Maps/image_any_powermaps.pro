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
;+




;----------------------------------------------------------------------------------
;+
;- SUBSET of AR (single sunspot, small ROI, etc.) in xy direction.
;-  (skip this part if using entire AR)
;- Crop data BEFORE computing power maps; only run FT on pixels that are keepers.
center = [ 225, 175 ]
rr = 200

;- Distinguish between simply assigning numbers and
;-  actually using them
;-   to alter data (or create new data array) for imaging.
;- Would have to go after defining z_ind, since it's used in CROP_DATA function...

imdata = CROP_DATA( $
    A[cc].map, $
    center=center, $
    dimensions=[rr,rr], $
    z_ind=z_ind )

;----------------------------------------------------------------------------------
;+
;- ROI(s)
;-
;- NOTE: still imaging whole AR here (no x|y cropping),
;-  but extracting ROIs to be analyzed separately from integrated emission.
;-

;- center of coords for ROI(s)
center = [ $
    [000, 000] ]
rr = 10 ; pixel size

;----------------------------------------------------------------------------------
;+
;- "The usual"

cc = 0
time = strmid(A[cc].time,0,5)
;dz = 64
dz = 150

;----------------------------------------------------------------------------------
;+
;- Define z/t indices
;-   (pulled from various codes).
;-


;- image_powermaps.pro (this code)...
;-    except not anymore... bda_powermaps.pro calls a function called
;-   IMAGE_POWERMAPS, I'm guessing this used to be a subroutine, turned into
;-   (attempts at) general, ML code.
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


;-
;------------
;- Image power maps  (31 July 2019)
;-
;-----
;- Titles (several ways to define title string array)
;-


;- title, one way
title = strupcase(instr) + ' @5.6mHz' + ' (' + $
    strmid(index[z_start].date_obs,11,8) + $
    '-' + $
    strmid(index[z_start+dz-1].date_obs,11,8) + $
    ')'

;---

nn = n_elements(z_ind)


;- title, another way
title = strarr(nn)
foreach zz, z_ind, ii do begin
    title[ii] = A[cc].name + ' ' + $
        time[zz] + '-' + time[zz+dz-1] + ' UT' + $
        ' (' + strtrim(zz,1) + '-' + strtrim(zz+dz-1,1)  + ')'
endforeach


;- title, a third way
title = []
for cc = 0, 1 do begin
    for ii = 0, NM-1 do begin
        ind = indgen(dz) + z0 + (dz*ii)
        title = [ title, $
            A[cc].channel + '$\AA$ ' + $
            time[ind[0]] + '-' + time[ind[-1]] ]
    endfor
endfor
title = 'AIA ' + title + ' UT'
title = reform( title, NM, 2)
;-    Both channels in one graphic? maybe don't do this?
;-    Just put "aia1600_" or "aia1700_" in filename.
;-    This would avoid 4D data sets, but may need to preserve each channel so can
;-      switch back and forth without re-calculating every time...




;+
;--------
;- Central period/frequency
;-   (see central_freq_powermaps.pro).
;- Was this adapted from that code, or vice versa?
;-   The following little bits of code appear to simply set up the variables
;-   needed to compute power maps at various central freq. values;
;-   doesn't actually do any calculations.
;-


;- The following is definitely direct copy of code in central_freq_powermaps.pro

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

;---
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


;---
;+
;- Imaging
;-

;@color ; polygons for ROIs or to box any subset that's doing something interesting
;-    Not used anywhere...

;+
;- SCALE data for better contrast in images.
;-   • raw #s
;-   • log(power)
;-   • sqrt (power^0.5), or raised to even smaller fraction (power^0.1)
;-   • min/max values -- lower/upper limit
;-   • whatever ssw routine AIA_INTSCALE does... uses exposure time somehow
;-

;- variable "map" doesn't appear to be defined or restored anywhere in this code..
imdata = alog10(map[*,*,*,cc])
;imdata = AIA_INTSCALE( map[*,*,*,cc], wave=fix(A[cc].channel), exptime=A[cc].exptime )
;imdata = (map[*,*,*,cc])^0.2


;- One channel (row 1), 3 time segments (BDA) --> 3 columns
rows = 1
cols = 3

;width = 2.5
;height = width * float(sz[1])/sz[0]
;-    neither width nor height appear to be used in this code anywhere...


;- function definition/calling sequence (31 July 2019):
;- im = IMAGE3( data, XX, YY, _Extra=e )
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
