;-
;- LAST MODIFIED:
;-   07 March 2019
;-
;- PURPOSE:
;-   general, simple imaging routine
;- .RUN some standard image file. Can be written at ML, pull it up and look
;-   at it, just stop typing the same thing over and over. This takes a lot
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


r = 600
dimensions = [r, r]
center=[1700,1650]

sz = size(imdata, /dimensions)
im = objarr(sz[2])

rows=6
cols=4

left = 0.05
right = 0.05
bottom = 0.05
top = 0.1

;- Syntax
;-   imdata = AIA_INTSCALE( data, wave=wave, exptime=exptime )

dw

props = { $
    axis_style : 2,  $
    rgb_table : AIA_COLORS( wave=1600 )  }

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

end
