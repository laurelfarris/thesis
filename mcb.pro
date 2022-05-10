;Copied from clipboard


;
; Chage axis labels from pixels to arcsec
im.xtickname = string( fix(im.xtickvalues * index[0].cdelt1 ))
im.ytickname = string( fix(im.ytickvalues * index[0].cdelt2 ))
im.xtitle = 'X (arcsec)'
im.ytitle = 'Y (arcsec)'
;
;- Intensity image title
im.title = strupcase(instr) + ' ' + strtrim(channel,1) + "$\AA$ " + strmid(index[z_ind].date_obs,11,8) + ' UT'
;
savefile = class + '_' + instr + strtrim(channel,1) + 'intensity'
save2, savefile

end

