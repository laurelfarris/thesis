;+
;- 05 January 2021


;+
;-   C8.3 2013-08-30 T~02:04:00
;-   M1.0 2014-11-07 T~10:13:00
;-   M1.5 2013-08-12 T~10:21:00
;-   C4.6 2014-10-23 T~13:20:00
;-


buffer = 1
instr = 'aia'
channel = 1600
;channel = 1700

path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'

;----


c46 = { $
    class  : 'C4.6', $
    year   : '2014', $
    month  : '10', $
    day    : '23', $
    tstart : '13:20', $
    tpeak  : '00:00', $
    tend   : '00:00', $
    xcen   : 0.00, $
    ycen   : 0.00 $
}

c83 = { $
    class : 'C8.3', $
    year : '2013', $
    month : '08', $
    day : '30', $
    tstart : '02:04', $
    tpeak  : '02:46', $
    tend   : '04:06', $
    xcen : -633.276, $
    ycen : 128.0748 $
}

m10= { $
    class : 'M1.0', $
    year : '2014', $
    month : '11', $
    day : '07', $
    tstart : '10:13', $
    tpeak  : '10:22', $
    tend   : '10:30', $
    xcen : -639.624, $
    ycen :  206.1222 $
}

m15 = { $
    class : 'M1.5', $
    year : '2013', $
    month : '08', $
    day : '12', $
    tstart : '10:21', $
    tpeak  : '10:41', $
    tend   : '10:47', $
    xcen : -268.8, $
    ycen : -422.4 $
}

;----


stop

;flares = { m15:m15, c83:c83, c46:c46, m10:m10 }

;ii = 3
;fnames = strupcase(instr) + $
;    flares.(ii).year + flares.(ii).month + flares.(ii).day + $
;    '*' + strtrim(channel,1) + '.fits'
fnames = strupcase(instr) + $
    m10.year + m10.month + m10.day + '*' + strtrim(channel,1) + '.fits'
fls = FILE_SEARCH( path + fnames )


READ_SDO, fls, index, data

z0 = 0
z1 = (where( strmid( index.date_obs, 11, 5 ) eq m10.tstart ))[0]
z2 = (where( strmid( index.date_obs, 11, 5 ) eq m10.tpeak ))[0]
z3 = (where( strmid( index.date_obs, 11, 5 ) eq m10.tend ))[0]
z4 = -1

z_indices = [z0, z1, z2, z3, z4 ] 
print, z_indices


center = ([4096.,4096.]/2) + ([ m10.xcen, m10.ycen ] / 0.6)
;- [] get full disk pixel dimensions from headers instead of hard-coding. Also spatial scale.

dimensions = [600,600]
;- "align_dimensions" in @parameters = [1000,800]... more padding than necessary?
;-    Alignment procedures take long enough as it is...

cube = CROP_DATA( data, dimensions=dimensions, center=center )
help, cube





;--------------------------------------------------------------

;+
;- Image

;imdata = AIA_INTSCALE( data, wave=fix(channel), exptime=index.exptime )
imdata = CROP_DATA( $
    AIA_INTSCALE( data, wave=fix(channel), exptime=index.exptime ), $
    dimensions=dimensions, center=center )

aia_lct, r, g, b, wave=fix(channel)
rgb_table = [ [r], [g], [b] ]

im = IMAGE2( $
    imdata, $
    rgb_table=rgb_table, $
    buffer=buffer $
)


SAVE2, 'flare_ARcentered', /timestamp


end
