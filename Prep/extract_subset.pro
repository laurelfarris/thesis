;+
;- LAST MODIFIED:
;-   02 February 2021
;-
;-   18 July 2022
;-     Merged with ./Prep/save_data_cubes.pro (copied below, indented, and commented).
;-       relatively short code consisting of a procedure definition + one line of ML code.
;-
;- ROUTINE:
;-   extract_subset.pro
;-
;- PURPOSE:
;-   Read data and header from level 1.5 fits files, center on AR, trim to desired dimensions, and
;-     save cube + header to .sav file.
;-   1. read data/headers from level 1.5 data (processed with aia_prep.pro)
;-   2. extract subset centered on AR with dimensions padded with enough pixels beyond
;-       boundaries of AR to allow room for edge effects due to shifting
;-       (maximum shift most likely x-direction, ~70 pixels at the most for a 5-hr ts.
;-   3. SAVE subset (cube) + index from lvl 1.5 data to file.sav
;-
;- CALLING SEQUENCE:
;-
;- INPUT:
;-
;- OUTPUT:
;-
;- EXTERNAL SUBROUTINES:
;-
;- TO DO:
;-   []
;-   []
;-   []
;-

;=  Prep/save_data_cubes.pro ====================================================================
;

;    ; Last modified:   13 June 2018
;
;    pro SAVE_DATA_CUBES, channel
;
;
;        ; 2018-06-13
;        ; Crop data cubes and save to .sav file.
;        ; Intentionally made saved data cubes larger than AR because
;        ;  they haven't been aligned yet.
;
;
;        READ_MY_FITS, index, data, inst='aia', channel=channel, nodata=0;, /prepped
;
;        x0 = 2410
;        y0 = 1660
;        xl = 750
;        yl = 500
;
;        ; make sure center coords are correct
;        im = image2( crop_data(data[*,*,sz[2]/2], center=[x0,y0]))
;        stop
;
;        data = crop_data( data, center=[x0,y0], dimensions=[xl,yl] )
;        save, data, filename='aia' + channel + 'data.sav'
;
;    end
;
;    SAVE_DATA_CUBES, '1600'
;    ;SAVE_DATA_CUBES, '1700'
;
;    end
;
;
;=====================================================================


;== OLD
;buffer=1
;instr = 'aia'
;channel = '1600'
;channel = '1700'
;instr = 'hmi'
;channel = 'mag'
;channel = 'cont'
;channel = 'dop'
;@par2
;flare = multiflare.(0)
;flare = multiflare.c83

;== NEW
@main ; defines all variables listed above



;-
;--- § Read index and data from level 1.5 fits files

;resolve_routine, 'read_my_fits', /either
;READ_MY_FITS, index, data, fls, instr=instr, channel=channel, ind=[0], nodata=0, prepped=1

;- OR skip my subroutine and use READ_SDO directly
;-  (read_my_fits probably needs updating for new multiflare structures anyway...)

date = flare.year + flare.month + flare.day
print, date

;+
;- 'AIAyyyymmdd_hhmmss_1600.fits'
;- 'AIAyyyymmdd_hhmmss_0304.fits'
;-
;- 'HMIyyyymmdd_hhmmss_cont.fits'
;- 'HMIyyyymmdd_hhmmss_mag.fits'
;- 'HMIyyyymmdd_hhmmss_dop.fits'
;-

@path_temp
hmi_path = path + 'Data/' + strupcase(instr) + '_prepped/'
print, hmi_path

fnames = strupcase(instr) + date + '*' + strtrim(channel,1) + '.fits'
fls = FILE_SEARCH( hmi_path + fnames )
READ_SDO, fls, index, data, /nodata


;== Read full data cube with READ_SDO
;=    NOTE: this can take a long time.. may need to loop through subsets of fls

start_time = systime()
start_time_seconds = systime(/seconds)
READ_SDO, fls, index, data
;
print, "=========="
print, "Started at ", start_time
print, "Finished at ", systime()
print, "Took ", (systime(/seconds)-start_time_seconds)/60., "minutes to run."
print, "=========="
help, data

; 18 July 2022 -- took <~ 14 minutes for 400 HMI 'cont' images for C8.3 flare... not too bad.
; IDL> help, data
;   DATA   FLOAT  = Array [4069, 4069, 400]



;= Extract subset centered on AR from full disk images by cropping x and y pixels

; Convert center from arcsec to pixels   -> see subroutines in ./Modules/
;   [] need to rewriote these so subroutnes can be compiled individually from ML using resolve_routine
;        currently have to do this: IDL> .com arcsec_pixel_conversion
center = ARCSECONDS_TO_PIXELS( [flare.xcen,flare.ycen], index )
print, center
; Variables 'center' and 'dimensions' generally stay the same for all instr/channels for given flare,
; but subroutine is easier to understand when variables are defined where they're used.
;  e.g. center and dimensions used to crop the full disk (data) and define subset (cube).

; subset dimensions in pixels, centered on AR
dimensions = [800,800]
resolve_routine, 'crop_data', /either
cube = CROP_DATA( data, center=center, dimensions=dimensions )
help, cube

; check .sav filenames
header_savefile = class + '_' + strlowcase(instr) + strupcase(channel) + 'header.sav'
print, header_savefile
cube_savefile = class + '_' + strlowcase(instr) + strupcase(channel) + 'cube.sav'
print, cube_savefile

; save to file
save, index, filename=header_savefile
save, cube, filename=cube_savefile

;====


;= Graphics :: save FULL DISK image and SUBSET image centered on AR.
;
; first, center, & last image in time series of 400 images (45 second cadence = 5-hour time series)
;    CENTER ~ same time as reference image for AIA alignment (I think..)
z_ind = [0, 199, 399]


foreach zz, z_ind, ii do begin
    imdata = cube[*,*,zz]
    hmi_figfilename = class + '_' + instr + strupcase(channel) + '_SUBSET_' + strtrim(zz,1) + '_image'
    dw
    im = image2( $
        imdata, $
        title=index[zz].content + '  ' + index[zz].date_obs, $
        buffer=buffer $
    )
    ;
    save2, hmi_figfilename
endforeach


end
