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
;-   [] change filename to all lowercase. IDL language is not case-sensitive, but
;-       external filenames are, and ".run image_ml" will give error for
;-      filename = "image_ML.pro"
;-
;- --> No capital letters in IDL filenames!!
;-
;+


goto, start
start:;-------------------------------------------------------------------------------

common defaults


year=['2012', '2014']
month=['03', '04']
day=['09', '18']

;channel='1600'
;channel='1700'

;nn = 0  ;- M6.3 -- 09 March 2012 flare
nn = 1  ;- M7.3 -- birthday flare

instr='hmi'
channel = 'cont'
;channel = 'mag'

READ_MY_FITS, index, data, fls, $
    instr=instr, $
    channel=channel, $
;    ind=ind, $
    nodata=0, $
    prepped=0, $
    year=year[nn], $
    month=month[nn], $
    day=day[nn]

stop


;imdata = A[0].data[*,*,0:23] ;- made up #s to get rows*cols


;- Crop imdata
;dimensions = [600, 600]
;x0 = 1700
;y0 = 1650
;center=[x0,y0]

;- AIA center coords, with offset for (UNprepped) HMI data (birthday flare)
x0 = 2879 + 215
y0 = 1713 - 80
dimensions=[400,340]

;- syntax:  AIA_INTSCALE( data, wave=wave, exptime=exptime )

imdata = CROP_DATA( rotate(data,2), center=[x0,y0], dimensions=dimensions )

;- Ensure a 3D array, even for only one image
sz = size(imdata, /dimensions)
if n_elements(sz) eq 2 then $
    imdata=reform(imdata, sz[0], sz[1], 1, /overwrite)
sz = size(imdata, /dimensions)

rows=1
cols=1

margin_offset = 0.00
margin_offset = 0.05 ;- Axis labels

left   = 0.05 + margin_offset
bottom = 0.05 + margin_offset
right  = 0.05
top    = 0.1  ;- room for title at top

margin=[left,bottom,right,top]


props = { $
    ;rgb_table : AIA_COLORS( wave=1600 ), $
    xtitle : 'X (pixels)', ytitle : 'Y (pixels)', $
    ;xtitle : 'X (arcsec)', ytitle : 'Y (arcsec)', $
    axis_style : 2  } ;- axis_style: 0=none, 1=bottom/left, 2=box, 3=crosshair

dw
im = objarr(sz[2])
for ii = 0, sz[2]-1 do begin
    title = $
        ;'HMI B$_{LOS}$' + $
        'HMI cont' + $
        ' (' + index[ii].bunit + ')   ' + $
        index[ii].date_obs
    im[ii] = image2( $
        imdata[*,*,ii], $
        layout=[cols,rows,ii+1], $
        margin=margin, $
        ;current=1, $
        current=ii<1, $
        axis_style=0, $
        title=title, $
        buffer=1, $
        _EXTRA = props)
endfor

ax = im[0].axes
;b_Xscale = index[0].cdelt1
;b_Yscale = index[0].cdelt2
;a_Xshift = ( (dimensions[0]/2) - x0); / b_Xscale
;a_Yshift = ((dimensions[1]/2)/b_Yscale) - y0
;ax[0].coord_transform = [a_Xshift, b_scale]
;ax[1].coord_transform = [a_Yshift, b_scale]



filename = instr + '_' + channel + '_Mflare'
save2, filename
stop

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
