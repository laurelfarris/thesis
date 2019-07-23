;- 19 July 2019
;- Downloading data for a few flares around GOES peak time;
;-  looking for new flares for multi-flare phase of thesis.
;-
;- 22 July 2019
;- Check where 1700 stopped downloading.
;- To do:
;-   [] Generalized code for reading index.date_obs from fits files,
;-       and displaying where the missing images are -- indices, dt between images,
;-       number of consecutive images missing at each hole, etc.

goto, start


year=['2012', '2014']
month=['03', '04']
day=['09', '18']

;channel='1600'
channel='1700'

;nn = 0  ;- M6.3 -- 09 March 2012 flare
nn = 1  ;- M7.3 -- birthday flare


read_my_fits, index, data, fls, $
    instr='aia', $
    channel=channel, $
    ind=[460:467], $
    nodata=0, $
    prepped=0, $
    year=year[nn], $
    month=month[nn], $
    day=day[nn]

start:;---------------------------------------------------------------------------
foreach ind, index, ii do begin
    ;print, ind 
    ;- NOTE: each "ind" is a full header, since "index" is an array of structures.
    print, index[ii].date_obs
endforeach
;- --> 2014-04-18T13:24:30.71
stop




;- 500" W and 200" S of disk center (Brannon2015)
x0 = 2046 + (500/0.6)
y0 = 2046 - (200/0.6)

print, x0, y0

wx = 8
wy = 8
dw
win = window(dimensions=[wx, wy]*dpi, buffer=1)
imdata = crop_data( data[*,*,3], center=[x0,y0], dimensions=[600,600] )
im = image( $
    aia_intscale( imdata, wave=fix(channel), exptime=index[3].exptime), $
    current=1, $
    rgb_table=aia_colors(channel) $
)

save2, 'birthday'


end
