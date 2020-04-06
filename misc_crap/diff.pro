



z_start = [16,58,196]
imdata = fltarr(500,330,3)
title = strarr(3)

foreach zz, z_start, ii do begin
    imdata[*,*,ii] = A[cc].data[*,*,zz+1] - A[cc].data[*,*,zz]
    title[ii] = A[cc].name + ' (' + time[zz] + '-' + time[zz+1] + ')'
endforeach


im = image3( imdata, rows=1, cols=3, title=title, buffer=1, rgb_table=A[cc].ct )
save2, 'diff_images'



end
