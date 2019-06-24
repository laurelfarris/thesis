;+
; ROUTINE:    horline
;
; PURPOSE:    Draw a horizontal line through a given data point
;
; USEAGE:     horline,y
;
; INPUT:
;  y          y-coord of point through which line is to be drawn
;
; OUTPUT:    
 
; Example:    CURSOR,x,y,/data,/down
;   	      HORLINE,y
;             
; AUTHOR:     Peter T. Gallagher, May. '98
;
;-

PRO horline,y,_extra=_extra

    PLOTS,[min(!x.crange),max(!x.crange)],[y,y],_extra=_extra
    
END
