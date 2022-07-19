;Copied from clipboard


cc = 0
dw
plt = PLOT_SPECTRA( $
    frequency[ fmin:fmax, cc ], $
    power[ fmin:fmax, cc ], $
;    xrange=[3.0, 10.0]/1000.0, $
    leg=leg, $
    /stairstep, $
    buffer=buffer $
)
print, plt[0].xtickvalues
;
fft_filename = 'c83_' + strlowcase(instr) + A[0].channel +  '_FFT_pre-flare'
;print, fft_filename
save2, fft_filename

end

