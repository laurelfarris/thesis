;+
;- 14 August 2021
;-
;- TO DO:
;-   [] image flare at z[0]
;-   [] plot pre-flare LCs (~2 hours) -> center of umbra (single pixel to start)
;-   [] zoom in to LC to see small-amplitude variations
;-   [] fourier2( signal )
;-   [] fourier2( signal, /NORM ) -> should have same pattern, but smaller numbers on y-axis
;-   [] fourier2( signal ) / "spectral maximum"
;-   []
;-   []
;-
;- C8.3 2013-08-30 T~02:04:00
;- M1.0 2014-11-07 T~10:13:00
;- M1.5 2013-08-12 T~10:21:00
;-


;- Need to rename variable saved in these files for C8.3 flare...
;restore, '../flares/c83_20130830/c83_aia1700header.sav'
;index = c83_aia1700header
;help, index
;save, index, filename='c83_aia1700header.sav'

;path='/home/astrobackup3/preupgradebackups/solarstorm/laurel07/'
;path='/solarstorm/laurel07/'
;testfiles = 'Data/HMI_prepped/*20140418*.fits'
;if not file_test(path + testfiles) then print, 'files not found'

buffer = 1
@par2
;
flare = multiflare.m73



print, flare.class
class = strlowcase((flare.class).Replace('.',''))
print, class

;path_temp = '/home/astrobackup3/preupgradebackups' + path

dims = [300,300]

;========
;= HMI

;hmi_channel = 'cont'
hmi_channel = 'mag'
;
READ_MY_FITS, hmiindex, hmidata, fls, flare=flare, instr='hmi', channel=hmi_channel, ind=0, nodata=0, prepped=1
;
hmifilename = class + '_HMI_' + hmichannel
print, hmifilename

;
;center = ([flare.xcen, flare.ycen] / [hmiindex.cdelt1, hmiindex.cdelt2]) + 2048.
center = [2890, 1700]
;
x1 = fix(center[0] - (dims[0]/2))
x2 = fix(center[0] + (dims[0]/2))
y1 = fix(center[1] - (dims[1]/2))
y2 = fix(center[1] + (dims[1]/2))
;
imdata = hmidata[ x1:x2, y1:y2 ]
;
dw
im = image2( imdata, buffer=buffer )
save2, hmifilename


;========
;= AIA

instr = 'aia'
cc = 0
;cc = 1
;
aiafilename = class + '_' + instr + A[cc].channel + '_intensity'
;
dims=[200,200]
center = [370,170]
x1 = fix(center[0] - (dims[0]/2))
x2 = fix(center[0] + (dims[0]/2))
y1 = fix(center[1] - (dims[1]/2))
y2 = fix(center[1] + (dims[1]/2))
;
subset = aia1600data[x1:x2,y1:y2,0]
;
imdata = aia_intscale( $
    subset, $
    wave=fix(A[cc].channel), $
    exptime=A[cc].exptime $
)

;x_arcsec = ([x1:x2] - 2048.) * 0.6
;print, x_arcsec[0]
;print, x_arcsec[-1]
;

loc = [105, 95]
;
dw
im = image2( imdata, rgb_table=A[cc].ct, buffer=buffer )
;sym = symbol( center[0], center[1], 'asterisk' )
sym = symbol( loc[0], loc[1], 'plus', /data, sym_color='white', sym_size=1 )
;
save2, aiafilename



;============================
;= plot LCs


cc = 0

lcfilename = class + '_' + instr + A[cc].channel + '_umbra_intensity'

trange = [0:149]
;
subset = aia1600data[x1:x2,y1:y2,*]
;
npix = 2
flux = reform( total( total(subset[ (loc[0]-npix):(loc[0]+npix), (loc[1]-npix):(loc[1]+npix), trange ], 1), 1 ) )
help, flux
;
xtickname=aia1600index[trange].date_obs
;
dw
plt = plot2( $
    flux, $
    color=A[cc].color, $
    buffer=buffer $
)
;
plt.xtickname = strmid(aia1600index[fix(plt.xtickvalues)].date_obs,11,5)
;
save2, lcfilename

;============
;= plot FFT

cc = 0
;
flux = A[cc].flux
delt = 24
norm = 0
;norm = 1
;
result1 = fourier2( flux[  0:349], delt, norm=norm )
result2 = fourier2( flux[350:699], delt, norm=norm )
;
frequency = reform(result1[0,*])
;frequency = 1000.*reform(result1[0,*])
power1 = reform(result1[1,*])
power2 = reform(result2[1,*])
;
fftfilename = class + '_' + instr + A[cc].channel + '_powerspec'
;fftfilename = class + '_' + instr + A[cc].channel + '_umbra_powerspec'
;fftfilename = [ $
;    class + '_' + instr + A[cc].channel + '_powerspec_before', $
;    class + '_' + instr + A[cc].channel + '_powerspec_during' $
;]
;
;
;power_3min = power2[where(frequency gt 5.2 and frequency lt 5.8)]
;print, power_3min
;
;ind = [20:n_elements(frequency)-1]
;ind = where( (frequency gt 4.0) and (frequency lt 10.0))
;ydata = [ [power1[ind]], [power2[ind]] ]
;xdata = [ [frequency[ind]], [frequency[ind]] ]
;
ydata = [ [power1], [power2] ]
xdata = [ [frequency], [frequency] ]
;
color=['purple','orange']
name=['pre-flare', 'flare']
;
dw
plt = objarr(2)
for ii = 0, 1 do begin
    plt[ii] = plot2( $
        xdata, $
        ydata[*,ii], $
        overplot=ii<1, $
        ylog=1, $
        xtitle='frequency (mHz)', $
        ytitle='power', $
        color=color[ii], $
        name=name[ii], $
        buffer=buffer $
    )
    ;save2, fftfilename[ii]
endfor
;
leg = legend2(target=plt, /upperright)
;
save2, fftfilename
;

ydata = [ [power1], [power2] ]
;ydata = [ [power1/max(power1)], [power2/max(power2)] ]
resolve_routine, 'plot_spectra', /is_function
plt = PLOT_SPECTRA( $
    xdata, $
    ydata, $
    leg=leg, $
    name=name, $
    ylog=1, $
    buffer=buffer $
)
;
leg[0].label=name[0]
leg[1].label=name[1]
;
save2, 'testOldSubroutine'
;save2, 'testOldSubroutine_norm'




print, moment(flux)

print, max(flux - mean(flux))
print, max(power)


;==================
;-
;- compute dP (before vs during) for 3-minute power, plus  a couple other periods with noticable
;-   power changes or peaks at either time.
;- Compare dP in each frequency to same values for other flares.
;-    => does change in 3-minute power stay roughly the same, regardless of flare size, while other
;-     frequencies (possibly those that reflect energy deposition rates in HXR data??) have perhaps
;-    a greater increase in power for larger flares... ??
;-


;power_5min = where( frequency gt 0.0032 and frequency lt 0.0036 )
print, 1./frequency[power_5min]
;print, power_5min

loc_3min = where( frequency gt 0.0054 and frequency lt 0.0058 )
print, frequency[loc_3min]
print, mean(power1[loc_3min])
print, mean(power2[loc_3min])

end
