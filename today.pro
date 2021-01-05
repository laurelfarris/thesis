;+
;- 05 January 2021


;+
;-   C8.3 2013-08-30 T~02:04:00
;-   M1.0 2014-11-07 T~10:13:00
;-   M1.5 2013-08-12 T~10:21:00
;-   C4.6 2014-10-23 T~13:20:00
;-


buffer = 1
channel = 1600



m15 = { $
    class : 'M1.5', $
    year : '2013', $
    month : '08', $
    day : '12', $
    tstart : '10:21' $
}
c83 = { $
    class : 'C8.3', $
    year : '2013', $
    month : '08', $
    day : '30', $
    tstart : '02:04' $
}
c46 = { $
    class : 'C4.6', $
    year : '2014', $
    month : '10', $
    day : '23', $
    tstart : '13:20' $
}
m10= { $
    class : 'M1.0', $
    year : '2014', $
    month : '11', $
    day : '07', $
    tstart : '10:13' $
}

stop

flares = { m15:m15, c83:c83, c46:c46, m10:m10 }
help, flares

;-  <structure_variable>.<tag_name>  OR  <structure_variable>.(<tag_index>)
;-  E.g.:   flares.m10  OR  flares.(3)



instr = 'aia'
path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'

ii = 0
;
fnames = strupcase(instr) + $
    flares.(ii).year + flares.(ii).month + flares.(ii).day + $
    '*' + strtrim(channel,1) + '.fits'


;fls = FILE_SEARCH( path + 'aia.lev1.' + channel + 'A_' + date + 'T*Z.image_lev1.fits' )
fls = FILE_SEARCH( path + fnames )

READ_SDO, fls, index, data
help, index
help, data


stop


print, strmid(index[1].date_obs, 8, 11)

im = IMAGE2( $
    imdata, $
    rgb_table = aia_gct(wave=channel), $
    buffer=buffer $
)


end
