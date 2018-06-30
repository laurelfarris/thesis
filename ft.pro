
; Last modified:   29 June 2018

; Structure of user-input values. Mostly just examples.
; Use short variable/tag names to just feed individual values into routines,
; E.G. plot, ft.flux, xrange=ft.xrange...
FT = {$
    flux: A[0].flux, $
    norm: 1, $
    cadence: 24, $
    fcenter: 1./180, $
    fwidth: 1./(170) - 1./(190), $
    fmin: 0.004, $
    fmax: 0.006, $
    ;fmin: 1./50, $
    ;fmax: 1./400, $
    z_start: [0:200:5], $
    dz: 64, $
    time: ['01:30','02:30'], $
    periods: [120, 180, 200, 300] $
}
; NOTE: regarding fwidth,
 ; period width not constant as frequency resolution,
 ; but this is based on specific central period, so others don't matter.

end
