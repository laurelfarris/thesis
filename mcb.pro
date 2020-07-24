;Copied from clipboard


format='(e0.2)'
;
for ii = 0, 8 do begin
    ;print, n_elements(where(aia1600mask[*,*,ii] eq 0.0))
    print, max(aia1700maps[*,*,ii]), format=format
endfor
;
;imdata = aia1600maps * aia1600mask
;filename = 'aia1600_BDA_histogram'
imdata = aia1700maps * aia1700mask
filename = 'aia1700_BDA_histogram'
;
nbins = 500
ydata = LONARR(nbins, 9)
xdata = LONARR(nbins, 9)
;help, ydata[0,0]
;
;
for ii = 0, 8 do begin
    ydata[*,ii] = HISTOGRAM( $
        ;imdata, $
        imdata[*,*,ii], $
        locations=locations, $
        nbins=nbins, $
        binsize=binsize, $
        ;min=0.0, $
        omax=omax, $
        omin=omin $
    )
    xdata[*,ii] = locations
endfor

end

