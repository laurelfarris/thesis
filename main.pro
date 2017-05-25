;; Last modified:  22 May 2017 16:27:34


;; Download data
vsoget


;; Read fits files
path = '/solarstorm/laurel07/data/hmi/hmi.ic*.2011.*continuum.fits'
cube = READ_MY_FITS( path, z=5 )


;; Align data (may need to adjust according to xcen, ycen, but only if using
;;    data from different instruments... which I probably won't be.)

ALIGN, cube


;; Analyze data!
