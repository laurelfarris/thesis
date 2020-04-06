;+
;- DATES MODIFIED:
;-  03 May 2019 (created)
;-
;-  04 April 2020
;-    NOTE (no modification to this code):
;-    Pretty sure this was copied from ML code in struc_aia.pro (or similar)
;-    to enable cleanup of that code... is a mess.
;-
;- ROUTINE:
;-
;- PURPOSE:
;-
;- USEAGE (aka calling syntax):
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-
;- AUTHOR:
;-
;- KNOWN BUGS:
;-





goto, start

start:;---------------------------------------------------------------------------------------------

;--- AIA

;- 1.
;- initialize 'A' as a !NULL variable,
;A = []
;A = [A, STRUC_AIA( aia1600index, aia1600data, cadence=24., instr='aia', channel='1600' ) ]
;A = [A, STRUC_AIA( aia1700index, aia1700data, cadence=24., instr='aia', channel='1700' ) ]


;- 2.
;- Define individual structure for each channel, use to create 'A',
;-  then set = 0 to clear memory.
aia1600 = DATA_STRUC( aia1600index, aia1600data, cadence=24., instr='aia', channel='1600' )
aia1700 = DATA_STRUC( aia1700index, aia1700data, cadence=24., instr='aia', channel='1700' )
;aia1600.color = 'dark orange'
;aia1700.color = 'dark cyan'
A = [ aia1600, aia1700 ]



for cc = 0, n_elements(A)-1 do begin
    A[cc].name = 'AIA ' + A[cc].channel + '$\AA$'
        ;- Probably don't need loop for this..
        ;-  --> A.name = 'AIA' + A.channel + '$\AA$'
        ;-  A.name and A.channel are both 2-element string arrays;
        ;-    appending a single string to a string array should append it to every
        ;-    element in the array. Not that it matters, since both values are
        ;-    now defined inside the function, one channel at a time.
        ;-  (16 March 2020)
    aia_lct, r, g, b, wave=fix(A[cc].channel);, /load
    ct = [ [r], [g], [b] ]
    A[cc].ct = ct
endfor

;A[0].color = 'dark orange'
;A[1].color = 'dark cyan'
A[0].color = 'blue'
A[1].color = 'red'


;- !NULL vs DELVAR vs UNDEFINE
print, ''
print, 'NOTE: aia1600index, aia1600data, aia1700index, and aia1700data'
print, '         still exist at ML. '
print, 'Type ".c" to undefine redundant variables.'
stop

undefine, aia1600
undefine, aia1600index
undefine, aia1600data
undefine, aia1700
undefine, aia1700index
undefine, aia1700data
stop


;-----------------------------------------------------------------------------------------------




;--- HMI


;hmi_mag = STRUC_HMI( hmi_mag_index, hmi_mag_data, cadence=45., instr='hmi', channel='mag' )
;hmi_cont = STRUC_HMI( hmi_cont_index, hmi_cont_data, cadence=45., instr='hmi', channel='cont' )

H = []
H = [H, STRUC_HMI( hmi_mag_index, hmi_mag_data, cadence=45., instr='hmi', channel='mag' )]
H = [H, STRUC_HMI( hmi_cont_index, hmi_cont_data, cadence=45., instr='hmi', channel='cont' )]



for cc = 0, n_elements(H)-1 do begin

    if H[cc].channel eq 'mag'  then H[cc].name = 'HMI B$_{LOS}$'
    if H[cc].channel eq 'cont' then H[cc].name = 'HMI intensity'

endfor

stop



;-------------------------------------------------------------


;- Create different routine for doing this. Leave comment here directing user
;-  to this routine to avoid confusion.
print, ''
print, '   Type ".CONTINUE" to restore power maps.'
print, ''
stop
help, A[0].data
help, A[1].data

@restore_maps

;for cc = 0, 1 do begin
;    restore, '../aia' + A[cc].channel + 'map_2.sav'
;    A[cc].map = map
;endfor
stop

; To do: save variables with same name so can call this from subroutine.
restore, '../power_from_maps.sav'
;power_from_maps = aia1600power_from_maps
;save, power_from_maps, filename='aia1600power_from_maps.sav'
;power_from_maps = aia1700power_from_maps
;save, power_from_maps, filename='aia1700power_from_maps.sav'

;A[0].power_maps = aia1600power_from_maps
;A[1].power_maps = aia1700power_from_maps

;------------------------------------------------------------------------------------

; A = replicate( struc, 2 )
; ... potentially useful?
; need to re-read data, but not headers... commented in subroutine for now.

;------------------------------------------------------------------------------------

;- 23 September 2018
A[0].data = A[0].data > 0
;  thought aia_prep produced data with no negative numbers, but not
;   sure why I thought so...

    resolve_routine, 'get_power_from_flux', /either
    power_flux = GET_POWER_FROM_FLUX( $
        flux=flux, $
        cadence=cadence, $
        dz=64, $
        fmin=0.005, $
        fmax=0.006, $
        norm=0, $
        data=cube )

    restore, '../aia' + channel + 'map.sav'

        ;power_flux: power_flux, $
        ;power_maps: fltarr(685), $
        ;map: fltarr(sz[0],sz[1],685), $
        ;map: map, $
end
