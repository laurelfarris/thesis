

;- 21 November 2018


z_start = 196
dz = 64
cc = 0
title = A[cc].name + ' (' + time[z_start] + '-' + time[z_start+dz-1] + ' UT)'

imdata = alog10(A[cc].map[*,*,z_start])
im = image3( imdata, title=title )

file = 'big_map'
save2, file


end
