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
start:;---------------------------------------------------------------------------

year=['2012', '2014']
month=['03', '04']
day=['09', '18']

;channel='1600'
channel='1700'

;nn = 0  ;- M6.3 -- 09 March 2012 flare
nn = 1  ;- M7.3 -- birthday flare


READ_MY_FITS, index, data, fls, $
    instr='aia', $
    channel=channel, $
    ind=[0:149], $ ; 150 files ... 750/5 = 150, should be 1 hour of data
    nodata=0, $
    prepped=0, $
    year=year[nn], $
    month=month[nn], $
    day=day[nn]

;foreach ind, index, ii do begin
    ;print, ind 
    ;- NOTE: each "ind" is a full header, since "index" is an array of structures.
    ;print, index[ii].date_obs
;endforeach
;- --> 2014-04-18T13:24:30.71

;- 23 July 2019:
;-  Testing "find_missing_images.pro", where coords of missing observations are
;-  determined in separated routine. Returned coords are then used to apply
;-  interpolations, or just to display WHERE missing images should have been,
;-  see if they're spread out or if there's a continuous time chunk of time with
;-  no data.
;-

time = strmid( index.date_obs, 11, 11 )
jd = GET_JD( index.date_obs + 'Z' )

dt = 5 * 3600
interp_coords = FIND_MISSING_IMAGES( jd, cadence, time, dt=dt )



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
