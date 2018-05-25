



goto, start






; 21 May 2018
; Start running aia_prep.pro on aia1600 data.


start_time = systime(/seconds)

read_my_fits, '1600', index, data, nodata=0, /aia

print, (systime(/seconds) - start_time) / 60.




index_old = index
data_old = data


start_time = systime(/seconds)

aia_prep, index_old, data_old, index, data


print, (systime(/seconds) - start_time) / 60.

; This took an hour, so need to save data. What about index?
; Does anything change other than LVL_NUM?


print, n_tags(index_old[0])
print, n_tags(index[0])
; Same number of tags...


old_tags = tag_names( index_old )
new_tags = tag_names( index )
print, where( old_tags ne new_tags )
; Same tag names...

stop

print, index_old[0].(67)
print, index[0].(67)
stop

tags = tag_names( index )

counter=0
;for i = 0, 186 do begin
for i = 189, n_tags(index[0])-1 do begin
    old_value = index_old[0].(i)
    new_value = index[0].(i)
    if ( old_value ne new_value ) then begin
        print, i, '  ', new_tags[i], old_value, new_value
        counter = counter+1
    endif
endfor


; 16 tags total are changed after running aia_prep


aia_prep, index_old[0], data_old[*,*,0], /do_write_fits, $
    outdir='/solarstorm/laurel07/Data/AIA_prepped/'

path='/solarstorm/laurel07/Data/AIA_prepped/'
fls = file_search( path + '*.fits' )
read_sdo, fls, index3, data3, /nodata
; seems to work!


START:;---------------------------------------------------------------------------------

path = '/solarstorm/laurel07/Data/AIA_prepped/'

read_my_fits, '1600', index, data, nodata=0, /aia
aia_prep, index, data, /do_write_fits, outdir=path

read_my_fits, '1700', index, data, nodata=0, /aia
aia_prep, index, data, /do_write_fits, outdir=path


;xstepper, data^0.5

end
