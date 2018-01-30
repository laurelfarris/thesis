;; Last modified:   30 January 2018 11:36:33

;+
; ROUTINE:      Data_analysis.pro
;
; PURPOSE:
;
; USEAGE:       IDL> .run Main2
;
; AUTHOR:       Laurel Farris
;
;-


data = 'AIA'
bandpass = '1700'

;-------------------------------------------------------------------------------
sav_path = '../Sav_files/'
flare_start = '01:30'
flare_end   = '02:30'

CASE data OF
    'HMI' : $
        hmi_path = '/solarstorm/laurel07/Data/HMI/*hmi*.fits'
        hmi_cadence = 45.0
        RESTORE_HMI, hmi_index, hmi_data
        LINEAR_INTERP, hmi_data, hmi_index, hmi_cadence, hmi_coords
        hmi_flux      = total( total(hmi,1), 1 )
        get_bda_indices, hmi_index, ht1, ht2

    'AIA' : $
        aia_cadence = 24.0
        CASE bandpass OF
            '1600' : $
                aia_1600_path = '/solarstorm/laurel07/Data/AIA/*aia*1600*.fits'
                RESTORE_AIA, aia_1600_index, aia_1600_data, wave=1600
                LINEAR_INTERP, aia_1600_data, aia_1600_index, aia_cadence, a6_coords
                aia_1600_flux = total( total(a6, 1), 1 )
                get_bda_indices, aia_1600_index, a6t1, a6t2
            '1700_placeholder' : $
                aia_1700_path = '/solarstorm/laurel07/Data/AIA/*aia*1700*.fits'
                RESTORE_AIA, aia_1700_index, aia_1700_data, wave=1700
                LINEAR_INTERP, aia_1700_data, aia_1700_index, aia_cadence, a7_coords
                aia_1700_flux = total( total(a7, 1), 1 )
                get_bda_indices, aia_1700_index, a7t1, a7t2
            '1700' : $
                path = '/solarstorm/laurel07/Data/AIA/*aia*1700*.fits'
                RESTORE_AIA, index, data, wave=1700
                flux = total( total(a7, 1), 1 )
                GET_BDA_INDICES, index, t1, t2
        ENDCASE

ENDCASE


end
