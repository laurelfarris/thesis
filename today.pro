;+
;- 21 October 2020
;-
;- Make .sav files with "during" power maps (one for each flare)
;- and with header info for obs. time close to middle of map.



restore, '../BDAmaps.sav'

restore, '../multiflare_struc.sav'

c30_1600_powermap = aia1600maps[*,*,1]
c30_1700_powermap = aia1700maps[*,*,1]
m73_1600_powermap = aia1600maps[*,*,4]
m73_1700_powermap = aia1700maps[*,*,4]
x22_1600_powermap = aia1600maps[*,*,7]
x22_1700_powermap = aia1700maps[*,*,7]




read_my_fits, index, data, fls, instr='aia', channel=1600, $
    ;ind=[200:300], $
    nodata=1, prepped=1

print, index[300].date_obs

x22_1600_header = index[300]
help, x22_1600_header

save, x22_1600_powermap, filename='x22_1600_powermap.sav'

save, x22_1600_header, filename='x22_1600_header.sav'

;-----------------

buffer = 1
im = image(x22_1600_powermap, buffer=buffer )
save2, 'test_powermap_sav'



end
