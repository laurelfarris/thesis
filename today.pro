;- 06 March 2019

;- Peak time 12:47
;- Class C3.0
;- 28 December 2013

;- .RUN some standard image file. Can be written at ML, pull it up and look
;-   at it, just stop typing the same thing over and over. This takes a lot
;-  of time, esp. when fixing syntax errors, looking up syntax for stuff that
;-   could be INCLUDED IN THE GENERAL ROUTINE!! Have to look it up anyway, may
;-   as well be this file.

goto, start

tstart = '2013/12/28 12:42:00'
tend   = '2013/12/28 12:52:00'
;- haven't actually used these variables from differendifferent routine yet.


resolve_routine, 'read_my_fits', /either
READ_MY_FITS, index, data, nodata=0, $
    instr='aia', channel=1600, prepped=0, $
    ;ind = [10:15], $
    files = '*2013*.fits'

print, index.date_obs
;- 12:47:28.12
stop


start:;-------------------------------------------------------------------------------

ct = AIA_COLORS( wave=1600 )

r = 600
dimensions = [r, r]
center=[1700,1650]

rows=6
cols=4




;- NOTE: 500x330 dimensions are HARD-CODED in crop_data routine!
;-         Possibly set as "defaults" using some hacky if statements...
;-        Look into this later.

resolve_routine, 'crop_data', /either
imdata = AIA_INTSCALE( $
    CROP_DATA( $
        data, $
        ;z_ind=z_ind, $
        center=center, dimensions=dimensions ), $
    wave=1600, exptime=index[0].exptime )


sz = size(imdata, /dimensions)

left = 0.05
right = 0.05
bottom = 0.05
top = 0.1

im = objarr(sz[2])
dw
for ii = 0, sz[2]-1 do begin
    im[ii] = image2( imdata[*,*,ii], $
        layout=[cols,rows,ii+1], $
        margin=[left,bottom,right,top], $
        current=ii<1, $
        axis_style=0, $
        title=index[ii].date_obs, $
        rgb_table=ct, buffer=1 ) 
endfor

save2, 'new_flare'



;- NEXT:
;-   Lightcurves!

end
