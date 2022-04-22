;+
; DATE:         22 April 2022
;
; ROUTINE:      period_freq_conversion.pro
;
; PURPOSE:      Convert freq (mHz, Hz) to period (min, sec)
;               (Canned routine probably exists... don't know what it is tho).
;
; USEAGE:       define freq_mHz, then
;               IDL> .RUN period_freq_conversion
;
; AUTHOR:       Laurel Farris
;
; TO DO:        Add nicely formatted output to display each value + units
;
;-

freq_mHz = 5.5

freq_Hz = freq_mHz / 1000.

period_seconds = 1. / freq_Hz

period_minutes = period_seconds / 60.

end
