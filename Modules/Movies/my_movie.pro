;+
;- LAST MODIFIED:
;-   06 September 2019
;-
;- ROUTINE:
;-   my_movie.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-
;- USEAGE:
;-   result = routine_name( arg1, arg2, kw=kw )
;-
;- INPUT:
;-   arg1   e.g. input time series
;-   arg2   e.g. time separation (cadence)
;-
;- KEYWORDS (optional):
;-   kw     set <kw> to ...
;-
;- OUTPUT:
;-   result     blah
;-
;- TO DO:
;-   [] item 1
;-   [] item 2
;-   [] ...
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+



;- file "movie.pro"
;-   already exists in directory /usr/local/exelis/idl85/lib/obsolete/
;-   discovered by running
;-     IDL> which, 'movie'
;-   to see if there already existed a routine by this name.
;-   (added "my_" to filename of my movie routine...)
;-  Pretty sure it just shows movie without creating a file.
;-



;-
;-
;-



;- Two ways to set format of output file (e.g. MPEG-4 or AVI):
;-   include appropriate extension with filename, or set FORMAT.
;-       (format probably only preferred if file type is likely to change)
oVid = IDLffVideoWrite( 'test_video.mp4' )
;oVid = IDLffVideoWrite( 'test_video', FORMAT='mp4'|'avi' )
;- mp4 file is created in current directory after call to IDLffVideoWrite.
;-
;-
;- result = obj.[IDLffVideoWrite::]AddVideoStream( w, h, Fps [, kws... ] )
;-  result = index of new stream
;-  w (width) & h (height) of video frame, in pixels
;-  Fps (Frames per second) desired for playback
width = 500
height = 330
Fps = 15
vidStream = oVid.AddVideoStream( width, height, Fps )
;-  --> LONG data type, = 0
;-      (initialization of stream, but no value(s) yet... )  ?
;-


;- result = obj.[IDLffVideoWrite::]Put( $
;-     index, data )
;-  index = data stream index --> returned by AddVideoStream method
;-  data = image arrays that make video,
;-      must be BYTE in format [3,w,h]
;- index and data --> input or output??
;vidStream = oVid.Put(vidStream, vidData)



;-- vidStream ==> index, returned from AddVideoStream,
;--                 (which OPENS video stream, but doesn't write to it).
;--
;-- What is a "stream" ??
;--



frames = 10
;- Test
surf = surface( /test, dimensions=[width,height] )
    ;- surf datatype is SURFACE (~ OBJREF or INT)
speed = 2
for ii = 0, frames-1 do begin
    time = oVid.Put(vidStream, surf.CopyWindow())
    surf.Rotate, speed
endfor
;surf.Close



frames = 50
for ii = 0, frames-1 do begin
    im = image( A[0].data[*,*,ii], dimensions=[width,height], buffer=0 )
    test = oVid.Put(vidStream, im.CopyWindow())
endfor


;-
;- destroy object, close file
;- result = obj.[IDLffVideoWrite::]Cleanup
;-
oVid.Cleanup


end
