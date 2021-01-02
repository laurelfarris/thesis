;Copied from clipboard


;dir='/solarstorm/laurel07/Data/AIA/'
;dir='/solarstorm/laurel07/Data/HMI/'
dir='/solarstorm/laurel07/Data/' + download_dir
;- Too easy to forget to set the right path when this line is this far
;-  down in the file (24 July 2019)
;
;
status = VSO_GET(dat, /force, out_dir=dir)

end

