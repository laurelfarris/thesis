;; Last modified:   10 April 2018

; Read headers
; Channel in STRING form (e.g. '1600')
; Similar to vsoget: uncomment lines you want

function hmi_files

    path = '/solarstorm/laurel07/Data/HMI/'

    ;m2 = { files : path+'*m_720s*magnetogram*.fits',  name: 'HMI B$_{vector}$' }
    m = { files : path+'*m_45s*magnetogram*.fits',  name: 'HMI B$_{LOS}$' }
    v = { files : path+'*v_45s*Dopplergram*.fits',  name: 'HMI velocity'  }
    c = { files : path+'*ic_45s*continuum*.fits',   name: 'HMI continuum' }

    return, { m:m, v:v, c:c }
end
function aia_files, channel

    ; AIA - Original fits files (level 1.0)
    path1 = '/solarstorm/laurel07/Data/AIA/'
    files1 = '*aia*' + channel + '*2011-02-15*.fits'

    ; AIA - New fits files (level 1.5)
    path2 = '/solarstorm/laurel07/Data/AIA_prepped/'
    files2 = 'AIA20110215_*_'  +  channel  +  '*.fits'

    return, {  $
        name:  'AIA ' + channel + '$\AA$', $
        unprepped : path1 + files1, $
        prepped : path2 + files2 }
end
