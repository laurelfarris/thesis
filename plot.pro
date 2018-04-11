;+
; :Description:
;    Create IDL Plot graphic.
;
; :Params:
;    arg1 : optional generic argument
;    arg2 : optional generic argument
;
; :Keywords:
;    _REF_EXTRA
;
;-
function plot, arg1, arg2, arg3, COLOR=color, $ 
                                 DEBUG=debug, $ 
                                 LAYOUT=layoutIn, $
                                 LINESTYLE=linestyle, $
                                 SYMBOL=SYMBOL, $
                                 TEST=test, $
                                 THICK=thick, $
                                 _REF_EXTRA=ex

  compile_opt idl2, hidden
@graphic_error

  nparams = n_params()
  hasTestKW = KEYWORD_SET(test)
  if (nparams eq 0 && ~hasTestKW) then $
    MESSAGE, 'Incorrect number of arguments.'
  
  if (~hasTestKW && ISA(arg1, 'STRING') && N_ELEMENTS(arg1) eq 1) then begin
    if (ISA(arg2, 'STRING') && N_ELEMENTS(arg2) eq 1) then begin
      style = arg2[0]
    endif
    equation = arg1[0]
    arg1 = [-10,10]
    arg2 = [1,1]
    nparams = 2
  endif

  switch (nparams) of
  3: if ~ISA(arg3, 'STRING') then MESSAGE, 'Format argument must be a string.'
  2: if (~ISA(arg2, /ARRAY) && ~ISA(arg2, 'STRING')) then $
    MESSAGE, 'Input must be an array or a Format string.'
  1: if ~ISA(arg1, /ARRAY) && ~hasTestKW then MESSAGE, 'Input must be an array.'
  endswitch
  
  nmin = 1
  n1 = N_ELEMENTS(arg1)
  n2 = N_ELEMENTS(arg2)

  if (isa(arg1, 'STRING')) then begin
    if (~hasTestKW) then $
      MESSAGE, 'Format argument must be passed in after data.'
    style = arg1
    nparams--
  endif else if (isa(arg1, /ARRAY)) then begin
    nmin = n1
  endif

  if (isa(arg2, 'STRING'))  then begin
    if (isa(arg3)) then $
      MESSAGE, 'Format argument must be passed in after data.'
    style = arg2
    nparams--
  endif else if (isa(arg2, /ARRAY)) then begin
    nmin = nmin < n2
  endif

  if (isa(arg3, 'STRING')) then begin
    style = arg3
    nparams--
  endif
  
  if (n_elements(style)) then begin
    style_convert, style, COLOR=color, LINESTYLE=linestyle, $
      SYMBOL=SYMBOL, THICK=thick
  endif
  
  layout = N_ELEMENTS(layoutIn) eq 3 ? layoutIn : [1,1,1]
  
  name = 'Plot'
  case nparams of
    0: Graphic, name, /AUTO_CROSSHAIR, COLOR=color, LINESTYLE=linestyle, $
      SYMBOL=SYMBOL, THICK=thick, LAYOUT=layout, TEST=test, _EXTRA=ex, $
      GRAPHIC=graphic
    1: Graphic, name, arg1, /AUTO_CROSSHAIR, COLOR=color, LINESTYLE=linestyle, $
      SYMBOL=SYMBOL, THICK=thick, LAYOUT=layout, TEST=test, _EXTRA=ex, $
      GRAPHIC=graphic
    2: if (nmin ne n1 || nmin ne n2) then begin
        Graphic, name, arg1[0:nmin-1], arg2[0:nmin-1], $
          /AUTO_CROSSHAIR, COLOR=color, LINESTYLE=linestyle, $
          SYMBOL=SYMBOL, THICK=thick, LAYOUT=layout, TEST=test, _EXTRA=ex, $
          GRAPHIC=graphic
       endif else begin
        Graphic, name, arg1, arg2, $
          /AUTO_CROSSHAIR, COLOR=color, LINESTYLE=linestyle, $
          SYMBOL=SYMBOL, THICK=thick, LAYOUT=layout, TEST=test, _EXTRA=ex, $
          GRAPHIC=graphic
       endelse
    3: if (nmin ne n1 || nmin ne n2) then begin
        Graphic, name, arg1[0:nmin-1], arg2[0:nmin-1], arg3, $
          /AUTO_CROSSHAIR, COLOR=color, LINESTYLE=linestyle, $
          SYMBOL=SYMBOL, THICK=thick, LAYOUT=layout, TEST=test, _EXTRA=ex, $
          GRAPHIC=graphic
       endif else begin
        Graphic, name, arg1, arg2, arg3, $
          /AUTO_CROSSHAIR, COLOR=color, LINESTYLE=linestyle, $
          SYMBOL=SYMBOL, THICK=thick, LAYOUT=layout, TEST=test, _EXTRA=ex, $
          GRAPHIC=graphic
       endelse
  endcase

  if (ISA(equation)) then begin
    graphic.SetProperty, EQUATION=equation
    arg1 = equation
    if (ISA(style)) then arg2 = style
  endif

  return, graphic
end
