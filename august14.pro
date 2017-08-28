;; Last modified:   14 August 2017 20:09:23


goto, START



restore, "Sav_files/hmi_aligned.sav"

hmi_path = '/solarstorm/laurel07/Data/HMI/'
fls = file_search(hmi_path + '*.fits')
fls = fls[22:*]
READ_SDO, fls, index, data, nodata=1

t = []
for i = 0, n_elements(index)-1 do begin
    t = [ t, get_timestamp(index[i].date_obs, /sunits) ]
endfor

dt = t - shift(t,1)
missing = ( where(dt ne 45.0) )[1:*]
; missing[i] - missing[i-1] = 90.0 seconds

cube2 = linear_interp(cube, missing)

;; ---> The above was copied as a general function into the same file as the
;;       linear interpolation (linear_interp.pro). Hopefully will work with AIA.



m = get_missing_indices( index, 45.0 )
;; It works :)




START:;-------------------------------------------------------------------------------------------

;; Code for restoring and prepping all data so it's interpolated and cropped.


end
