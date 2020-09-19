;- 19 September 2020



@parameters
print, date
print, class

;flare = '20110215'
;flare = '20131228'
;flare = '20140418'

flare = year + month + day
print, flare

savefile = 'rhessi_' + class
print, savefile



stop

;-------------------------------------




;
path = '/solarstorm/laurel07/thesis/RHESSI/hsi_images/' + flare + '/'
;
;clean_filename = 'hsi_clean_image_' + flare + '_131330_64sec_2.3arcsec_resolution_20-30keV.fits'
;pixon_filename = 'hsi_pixon_image_20131228_131330_64sec_2.3arcsec_resolution_20-30keV.fits'

fls = file_search(path + '*.fits')
;

rhessi_data = []
rhessi_header = []
for ii = 0, n_elements(fls)-1 do begin
    FITS_READ, fls[ii], data, header
    rhessi_data = [ [[rhessi_data]], [[data]] ]
    rhessi_header = [ [rhessi_header], [header] ]
endfor
;-  19 September 2020:
;-    data and header overwritten each iteration...
;-    [] is there a way to pass an array of filenames, and return
;-    data and headers for all files in one variable, like
;-    read_sdo? Special RHESSI fits reading routine probably
;-    does this, but I can't find it :(
;-
;help, rhessi_data
help, rhessi_header

;FITS_READ, path + clean_filename, cleandata, cleanheader
;FITS_READ, path + pixon_filename, pixondata, pixonheader
;FITS_READ, fls[0], cleandata, cleanheader
;FITS_READ, fls[1], pixondata, pixonheader
;rhessi_data =  [ [[cleandata]], [[pixondata]] ]

;-----

;e_l =  STRTRIM( FIX( rhessi_header.ENERGY_L ), 1 )
;e_h =  STRTRIM( FIX( rhessi_header.ENERGY_H ), 1 )
;title = e_l + '-' + e_h + ' keV '
;-  ... for later, after figure out RHESSI fits read routine..

for ii = 0, 5 do begin
    print, rhessi_header[12,ii] ;- DATE_OBS
;    print, rhessi_header[15,ii] ;- ENERGY_L
;    print, rhessi_header[16,ii] ;- ENERGY_H
endfor


;title = '20-30 keV ' + ['(clean)', '(pixon)'] + ' ' + flare
;title = '20-30 keV ' + ['(clean)', '(pixon)'] + ' ' + date

date_obs = '2011-02-15T' + $
    ['01:49:16', '01:53:30', '01:53:30', '01:53:30', '01:55:30', '01:55:30']
print, date_obs[-1]
    

energy_l = strtrim([25, 25, 35, 50, 25, 50],1)
energy_h = strtrim([50, 50, 70,100, 50,100],1)


title = energy_l + '-' + energy_h + ' keV ' + date_obs
print, title


;------------------

sz = size(rhessi_data, /dimensions)
print, sz[2]

buffer = 1
;imdata = [ [[cleandata]], [[pixondata]] ]
wx = 8.5
wy = 11.0
dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
im = objarr(sz[2])
for ii = 0, n_elements(im)-1 do begin
    im = image2( $
        rhessi_data[*,*,ii], $
        /current, $
        layout=[2,3,ii+1], $
        margin=0.01, $
        title=title[ii], $
        buffer=buffer $
    )
    c_value=[0.25, 0.50, 0.75, 0.90]*max(rhessi_data[*,*,ii])
;    help, c_value
;    print, c_value
    cdata = contour2( $
        rhessi_data[*,*,ii], $
        c_value=c_value, $
        /overplot, $
        color='red', $
        buffer=buffer $
    )
endfor
;-
SAVE2, savefile
;-


stop


;- Image AIA, and oplot RHESSI contours


READ_MY_FITS, index, aiadata, instr='aia', channel=1600, /nodata, prepped=1
help, index
time = strmid( index.date_obs, 11, 5 )
print, time[0]

;print, where( time eq '13:13' OR time eq '13:14' )
;print, time[ where( time eq '13:13' ) ]
;print, index[ where( time eq '13:13' ) ].date_obs

locs = where( time eq '13:13' OR time eq '13:14' )
print, locs
aia_time = index[locs].date_obs
help, aia_time

ind=479
print, index[ind].date_obs
READ_MY_FITS, aiaindex, aiadata, instr='aia', channel=1600, ind=ind, prepped=1

help, aiaindex
print, aiaindex.date_obs


win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
ii = 0
im = image2( $
    aiadata, $
    /current, $
    layout=[2,1,ii+1], $
    rgb_table=aia_gct( wave=1600 ), $
    buffer=buffer $
)


print, aiaindex

;-

end
