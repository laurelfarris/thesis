;+
;- 31 January 2020
;-
;- To do:
;-   1. Compute A.flux using UNSATURATED pixels.
;-   2. Create WA plots using new flux, compare values to powercurves.
;-
;-
;-
;-

;

;-
;- 12 February 2020
;- array below = approx spacing between peak amp in my detrended LC
;-  during flare (in units of frames... x axis labeled with obs # (z), not time (UT).
;-  for more details, see notes all over plots in Dissertation draft,
;-   section on Fourier filters (currently last part of Analysis section).
print, [8,5,4,7,10] * 1.3



;read_my_fits, index, data, fls, $
    
path = 'RHESSI/laurel_RHESSI_ims/20110215/'
fls = file_search( path + '*.fits' )


;dw
win = window(dimensions=[8.5,11.0]*dpi, location=[500,0], buffer=0)
for ii = 0, 2 do begin
    imdata = READFITS(fls[ii])
    im = image2( $
        alog10(imdata), $
        ;current=ii<1, $
        /current, $
        layout=[1,3,ii+1], $
        margin=0.1 )
endfor


filename =  'rhessi'
save2, filename




CALDAT, systime(/julian), $
  month, day, year, hour, minute, second
print, month, day, year, hour, minute, second

year = strtrim(year,1)
month = strtrim(month,1)
day = strtrim(day,1)


;; ---

result = systime( )

print, strlen(result)


hh = strmid(result, 11, 2)
mm = strmid(result, 14, 2)
ss = strmid(result, 17, 2)
print, hh
print, mm
print, ss


print, systime()
print, systime(/julian)

help, systime()
help, systime(/julian)

;-
;-
;-
;- ROIs
;-   (NOTE: copied the code below to new "today.pro" for 21 February 2020
;-    and continued working on ROIs.)
;-
;-

;+
;- User input
;-

;- center and z_ind from zoomed-in figures of power maps
;-  (3 total : far left, center, far right.  Far right is where
;-    "interesting feature" is seen.)
center = [382,192] ;- AR_1p
;center = [280,180] ;- AR_2p
z_ind = 201
rr = 50  ;- dimensions of box around ROI
cc = 0  ;- 1600 for now



;+
;- general code (no user input required)
;-

x0 = center[0]
y0 = center[1]

;imdata = A[cc].map[*,*,z_ind]

rr = 30
dw
;imdata = A[cc].data[ $
imdata = A[cc].map[ $
    x0-(rr/2):x0+(rr/2)-1, $
    y0-(rr/2):y0+(rr/2)-1, $
    z_ind]
;help, imdata
im = image2( $
    ;imdata, $
    alog10(imdata), $
    margin=0.1, $
    rgb_table=AIA_COLORS( wave=fix(A[cc].channel) ) $
)



;- ROI to average over
rr = 10
;
;roi = A[cc].data[ $
roi = A.data[ $
    x0-(rr/2):x0+(rr/2)-1, $
    y0-(rr/2):y0+(rr/2)-1, $
    * ] $
/ A[cc].exptime
;
;
;- average over ROI xy dimensions to get 1D flux array
roi_flux = mean( mean( roi, dimension=1 ), dimension=1 )
help, roi_flux

plt = plot2( roi_flux)


READ_MY_FITS, index, data, fls, instr='aia', channel=1600, $
    ind=280, /nodata, prepped=1
print, index.wavelnth
print, index.exptime
print, index.lvl_num

end
