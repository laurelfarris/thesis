;Program to take an image (data) and header structure (header) and
;save them to a .fits file (filename).  If no header is provided then
;the generic .fits header will be inserted

pro sfitswrite,filename,data,header

  IF n_params() lt 2 THEN print,'Call: sfitswrite,filename,data[,header]'$
  ELSE BEGIN
     
     IF n_params() ge 3 THEN header_arr=struct2fitshead(header)
     
     mwrfits,data,filename,header_arr,/create
     
  ENDELSE
end
