;+ 
;- From Todoist:
;-   [] write IDL routine or shell script to show number of fits files,
;-   prepped and UNprepped, with given year/month/day, t-range, and wavelength
;-   (may seem low priority, but can pull from main focus for too long..)
;-
;- From Prep/struc_aia.pro (03 November 2020)
;-    Unprepped filename:
;-      aia.lev1.channelA_yyyy-mm-ddThh_mm_ss.ssZ.image_lev1.fits
;-    Prepped filename:
;-      AIAyyyymmdd_hhmmss_channel.fits
;- NOTE: Channel in prepped filenames padded with leading zeros so all files
;-   have 4 characters in that spot.. NOT the case with UNprepped filenames,
;-   which consequently have different character lengths
;-   (differ by 1 or 2 chars; AIA channels range from 94Ā to 4500Ā).
;-


@parameters

print, year
print, month
print, day


unprepped_path = '/solarstorm/laurel07/Data/AIA/'
unprepped_file = 'aia.lev1.1600A_2011-02-15T00_00_41.12Z.image_lev1.fits'
unprepped_file = 'aia.lev1.304A_2011-02-15T00_00_41.12Z.image_lev1.fits'
print, file_test( unprepped_path + unprepped_file )


unprepped_filename = 'aia.lev1.' + wave + 'A_'

prepped_path = '/solarstorm/laurel07/Data/AIA_prepped/'

prepped_file = 'AIA20110215_000041_1600.fits'
prepped_file = 'AIA20110215_000041_0304.fits'

;-----
;- FINAL:
;-

instr = 'aia'
channel = '1600'
;


;-
;- UNprepped -- level 1.0
unprepped_file = $
    STRLOWCASE(instr) + '.lev1.' + channel + 'A_' + $
    year + '-' + month + '-' + day + 'T*' + 'Z.image_lev1.fits'
print, FILE_TEST( unprepped_path + unprepped_file )
fls = FILE_SEARCH( unprepped_path + unprepped_file )


;-
;- Prepped -- level 1.5
prepped_file = $
    STRUPCASE(instr) + $
    year + month + day + '_*' + '_' + channel + '.fits' 
print, FILE_TEST( prepped_path + prepped_file )
fls = FILE_SEARCH( prepped_path + prepped_file )

help, fls
;-  STRING   = Array[749]
;-  In other words, file/path naems are correct, including use of wildcrds
;-    in place of hour, minute, second of observations, which isn't included
;-   in parameters.pro
;-


;- Task : write routine to print NUMBER of files
print, N_ELEMENTS(fls)

print, N_ELEMENTS( unprepped_path + unprepped_file )
print, N_ELEMENTS( prepped_path + prepped_file )

end
