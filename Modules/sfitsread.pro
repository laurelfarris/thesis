;Program to read the .fits file (filename) into an image (data) and a
;header structure (header).  If no variable is provided for the header
;then only the data is returned

pro sfitsread,filename,data,header
  
  IF n_params() lt 2 THEN print,'Call: sfitsread,filename,data[,header]' $
  ELSE BEGIN
     
     data=mrdfits(filename,0,header_arr)
     
     IF n_params() ge 3 THEN header=fitshead2struct(header_arr)
     
  ENDELSE 
end

