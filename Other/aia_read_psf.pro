;
;Program designed to read in AIA data and convert to level 1.5.
;Combines PSF correction from Poduval and DeForest et al 2013 and
;aia_prep.pro to convert jsoc level 1 to PSF corrected level 1.5.
;
;Kernal is inverse of PSF provided by Poduval 2013
;

pro aia_read_psf,image_filename,inversePSF_filename,index,data,kernal=kernal
  
;Read AIA file
  sfitsread,image_filename,dat,ind
  
  IF NOT keyword_set(kernal) THEN BEGIN
;If needed read and manipulate the Kernal file
     sfitsread,inversePSF_filename,kernal,kernal_ind
     
;Reverse kernal because convol.pro performs the correlation rather
;than the convolution
     kernal=reverse(reverse(kernal,2))     ;reverse in both dimensions
  ENDIF
  
  kernal_size=size(kernal)
  
;Perform convolution of PSF Kernal and image
;array_dilate used to add buffer so that convolution is performed
;without removing edges of image
  dat_ext=array_dilate(dat,kernal_size(1))
  dat_conv=convol(dat_ext,kernal,/center,missing=0,/nan)
  dat_conv=array_dilate(dat_conv,kernal_size(1),/contract)
  
  aia_prep,ind,dat_conv,index,data,/use_hdr_pnt
  
end
