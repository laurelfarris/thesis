;- 21 October 2018

;- After trying a bunch of different ways to do this, got tired
;- havnig a ton of commented lines cluttering up code, so
;- copied them here.

;- Normalize power between 0.0 and 1.0
;aia1600map = map[*,*,0]
;aia1600map = aia1600map - min(aia1600map)
;aia1600map = aia1600map / max(aia1600map)
;aia1700map = map[*,*,1]
;aia1700map = aia1700map - min(aia1700map)
;aia1700map = aia1700map / max(aia1700map)
;map = [ [[aia1600map]], [[aia1700map]] ]


;- Exclude values less than S/N ratio
;SNR_1600 = mean(map[*,*,0])/mean(map[0:9,0:9,0])
;SNR_1700 = mean(map[*,*,1])/mean(map[0:9,0:9,1])
;aia1600map = map[*,*,0]
;aia1600map[where(aia1600map lt SNR_1600)] = 0
;aia1700map = map[*,*,1]
;aia1700map[where(aia1700map lt SNR_1700)] = 0
;map = [ [[aia1600map]], [[aia1700map]] ]
;map[*,*,0] = map[*,*,0] > SNR_1600
;map[*,*,1] = map[*,*,1] > SNR_1700


;- Set values that are way too high to zero
;threshold = 20.0
;aia1600map = map[*,*,0]
;aia1600map[ where( map[*,*,0] gt threshold ) ] = 0.0
;map[*,*,0] = aia1600map

image_data = map
;cbar_title = '5-minute power (normalized)'
cbar_title = '3-minute power (normalized)'
;image_data = alog10(map)
;cbar_title = 'log 3-minute power'
;image_data = AIA_INTSCALE( map[*,*,*,cc], wave=fix(A[cc].channel), exptime=A[cc].exptime )
;image_data = (map[*,*,*,cc])^0.2

