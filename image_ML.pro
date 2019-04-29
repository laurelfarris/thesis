;-
;- LAST MODIFIED:
;-   21 April 2019
;-
;- PURPOSE:
;-   general, simple imaging routine
;- ILD> .RUN some standard image file.
;-  Can be pulled up for reference, read into another script, or
;-    copied and edited as needed.
;-   Purpose is to stop typing the same thing over and over.
;- This takes a lot
;-  of time, esp. when fixing syntax errors, looking up syntax for stuff that
;-   could be INCLUDED IN THE GENERAL ROUTINE!! Have to look it up anyway, may
;-   as well be this file.
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:


goto, start
start:;-------------------------------------------------------------------------------

common defaults

;- Crop imdata
;r = 600
;dimensions = [r, r]
;center=[1700,1650]

imdata = A[0].data[*,*,0:23] ;- made up #s to get rows*cols
sz = size(imdata, /dimensions)

;- Syntax
;-   imdata = AIA_INTSCALE( data, wave=wave, exptime=exptime )

rows=6
cols=4

left   = 0.05
right  = 0.05
bottom = 0.05
top    = 0.1
; These could be arrays... 


props = { $
    axis_style : 2,  $
    rgb_table : AIA_COLORS( wave=1600 )  }

im = objarr(sz[2])
dw
for ii = 0, sz[2]-1 do begin
    im[ii] = image2( $
        imdata[*,*,ii], $
        layout=[cols,rows,ii+1], $
        margin=[left,bottom,right,top], $
        current=ii<1, $
        axis_style=0, $
        title=index[ii].date_obs, $
        buffer=1, $
        _EXTRA = props)
endfor


;_________________________________________________________________________

;- 2 images, different AIA channels, same date_obs.

@parameters
time = strmid(A[0].time,0,5)
zz = (where( time eq strmid(gpeak,0,5) ))[0]
print, zz

imdata = CROP_DATA(A.data[*,*,zz,*], dimensions=dimensions )
props = { $
    xtitle : 'X (arcsec)', $
    ytitle : 'Y (arcsec)', $
    buffer : 1 $
}

rows=1
cols=2

dw
wx = 8.0
wy = 3.5
win = window( dimensions=[wx,wy]*dpi, location=[1200,0], buffer=0 )

for ii = 0, sz[2]-1 do begin
    im[ii] = image2( $
        AIA_INTSCALE( imdata[*,*,ii]*A[ii].exptime, $
            wave=fix(A[ii].channel), exptime=A[ii].exptime), $
        A[ii].X, A[ii].Y, $
        current=1, $
        layout=[cols,rows,ii+1], $
        margin=[left,bottom,right,top], $
        rgb_table = A[ii].ct, $
        buffer=1, $
        title = A[ii].name + ' ' + strmid(A[ii].time[zz],0,8) + ' UT', $
        _EXTRA = props)
endfor
end
