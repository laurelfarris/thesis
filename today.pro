;- 12 April 2019

;- Peak time 12:47
;- Class C3.0
;- 28 December 2013
;- Prepped file names: /solarstorm/laurel07/Data/AIA_prepped/
;-   "AIAyyyymmdd_hhmmss_channel.fits", where channel = 1600, 1700, 304, ...


goto, start

;-- Run vsoget to query/download data


tstart = '2013/12/28 10:00:00'
tend   = '2013/12/28 13:59:59'


instr = 'aia'
year = '2013'
channel = [304, 1600, 1700]
out_dir="/solarstorm/laurel07/Data/AIA_prepped/"
;out_dir="/solarstorm/laurel07/Data/HMI_prepped/"

;-----------------------------------------------------------------------------------

;-- § -- Read fits files and run aia_prep.pro
cc = 0

files = instr + "*" + strtrim(channel[cc],1) + "*" + year + "*.fits"

resolve_routine, 'read_my_fits', /either
;- input parts of fnames individually? E.g. year, instr, channel, ...
READ_MY_FITS, old_indices, old_data, $
    nodata=0, $
    instr=instr, $
    channel=channel[cc], $
    prepped=0, $
    ;ind = [10:15], $
    files = files

stop

start:;-------------------------------------------------------------------------------
print, old_indices[0].date_obs
print, old_indices[-1].date_obs
stop


;-- Read fits files and run aia_prep.pro
AIA_PREP, old_indices, old_data, $
    index, data, $
    ;/do_write_fits, $  Not needed if out_dir kw is set?
    out_dir=out_dir

stop

ct = AIA_COLORS( wave=channel )

xx = 525
yy = 400
dimensions = [xx, yy]
center=[1675,1600]

;- NOTE: 500x330 dimensions are HARD-CODED in crop_data routine!
;-         Possibly set as "defaults" using some hacky if statements...
;-        Look into this later.

resolve_routine, 'crop_data', /either
imdata = CROP_DATA( $
    data, $
    center=center, dimensions=dimensions )
stop

zz = 246
;imdata = AIA_INTSCALE( $ data[*,*,zz], $ wave=1700, exptime=index[zz].exptime )


im = image2( imdata[*,*,zz], /buffer, rgb_table=ct )
;@image_quick

save2, 'sol2013_aia' + string(channel)
stop


;-   Lightcurves
;-   (NOTE: If alignment hasn't been done yet,
;-         need to use big enough box to contain AR throughout time.)

flux = total( total( imdata, 1), 1 )
help, flux

common defaults
color = ['blue']
name = ['AIA ' + string(channel)]


dw
win = window( dimensions=[8.0, 3.0]*dpi, buffer=1 )
ii=0
;for ii = 0, 1 do begin
    plt = plot2( $
        ;mynorm(flux), $
        flux[50:*], $
        ylog=1, $
        ;(flux-min(flux))/(max(flux)-min(flux)), $
        ;flux[*,ii], $
        current = 1, $
        overplot = ii<1, $
        layout = [1,1,1], $
        margin = 0.1, $
        name = channel[ii], $
        color = color[ii] )
;endfor

save2, 'lc2'


end
