;+
;- 20 August 2021
;-  copied from interwebs to read RHESSI lightcurve text files, but ended up
;-   using READCOL procedure instead. Can probably delete this.


;
;A first IDL procedure: an example reading data from a file The IDL functions we
;have used so far return a single variable. It is often useful to return
;multiple variables. We use procedures to do this. They are hardly different
;from functions, and you could always use procedures instead of functions in
;fact. For example, we have a file of radiosonde data that contains a header
;line and then six columns of data in ascii format. We want to define a general
;piece of code to read this

;Open a file read_ascii_cols. pro and insert,

pro read_my_datafile, infile, data, width, head_length=head_length

    ;+
    ;pro read_ascii_cols,infile,data,head_length=head_length
    ;read a file of columns of asciii data of unknown length
    ;width specifies number of data values in a line of data
    ;Keyword: head_length specifies number of lines in header
    ;JOHN MARSHAM 10/02/04
    ;-

    data_line=fltarr(width) ; Creates an empty array of floating point numbers 
    head_line='' ; Creates an empty string (for text) 
    header=strarr(head_length) ; Creates an empty array of strings 

    i=0 

    openr,12,infile ; open the file to read from 

    ;If there's a header then read to header string array 
    if keyword_Set(head_length) then begin
       for k=0,head_length-1 do begin
           readf,12,head_line
           header[k]=head_line
      endfor 
    endif

    ;Read data 
    repeat begin
        readf,12,data_line
        ;If first line then data=data_line else add data_line to the existing data
        if i eq 0 then data = data_line else data=[[data],[data_line]]
        i=i+1l
    endrep until eof(12) ;read until end of the file (eof) 
    close,12

end


;    .compile read_ascii_cols
;    read_ascii_cols,'/nfs/see-fs-02_users/lecjm/public_html/Teaching/IDL_course/New_Course_v1/Data/larkhill_200506241022.txt',data,7,head_length=5
;    This should read the five header lines, then read the data into a 7 column
;    array (use ``help,data''). Although the header does not tell you(!) the
;    data is: Linenumber (column 0),pressure (column 1, Pa), height (column 2,
;    m), temp (column 3, K), dew-point (column 4, K), wind direction (column 5,
;    degrees), windspeed (column 6, m/s). Try to plot temperature against
;    height,

    window,0,retain=2
    plot,data(3,*),data(2,*)
;    Not a very useful graph! Look at the data (print data). There are lots of bad data values (9999999s). We need to exclude these.
;    next up previous contents
;    Next: Using where Up: Section 2: Introduction to Previous: Using keywords   Contents
;    John Marsham 2009-12-07
end
