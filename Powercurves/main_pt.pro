;+
;- LAST MODIFIED:
;-   08 August 2022
;-
;- PURPOSE
;-   main level (ML) code to play with values (dt, d\nu, multiflares, etc.),
;-   compute P(t), and call subroutines to create plots.
;-


function POWER_IN_STRUC, struc

    ;- 21 April 2019: moved from prep_aia.pro
    ;- 08 August 2022: moved from Modules/ to here
    ;-   ("here" being code "main_pt.pro" in Powercurves/)


    ;power_flux = GET_POWER( $
    ;    struc.flux, cadence=struc.cadence, channel=struc.channel, data=struc.data)
    ;struc = create_struct( struc, 'power_flux', power_flux )

;    power_maps = GET_POWER_FROM_MAPS( $
;        struc.data, struc.channel, threshold=10000, dz=64)
;    struc = create_struct( struc, 'power_maps', power_maps )

    return, struc
end
