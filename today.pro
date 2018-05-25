;; Last modified:   23 May 2018 23:00:49

goto, start


; 23 May 2018


;; Wanted to record which tags were changed, and how
path = '/solarstorm/laurel07/Data/AIA/'
channel = '1600'
files = '*aia*' + channel + '*2011-02-15*.fits'
fls = (file_search( path + files ))[0]
read_sdo, fls, oldindex, olddata
aia_prep, oldindex, olddata, newindex, newdata
oldtags = tag_names(oldindex)
newtags = tag_names(newindex)
print, where( oldtags ne newtags )
for i = 0, 186 do begin
    if (oldindex.(i) ne newindex.(i)) then $
        print, i, '  ', (tag_names(oldindex))[i], $
            oldindex.(i), newindex.(i)
endfor
for i = 189, n_tags(oldindex)-1 do begin
    if (oldindex.(i) ne newindex.(i)) then $
        print, i, '  ', (tag_names(oldindex))[i], $
            oldindex.(i), newindex.(i)
endfor





START:;--------------------------------------------------------------------



end
