;
;Function to expand or contract an array in all dimensions, populating all new
;entries with 0.  Designed for 2 dimensional arrays.
;


;Function to expand array in a single dimension
function array_extend,array,extension,edge,value=value

new_array=array

IF NOT keyword_set(value) THEN value=0

arr_size=size(new_array)

IF edge eq 0 or edge eq 2 THEN BEGIN
    empty=replicate(value,extension,arr_size(2))
    IF edge eq 0 THEN new_array=[empty,new_array] ELSE $
       new_array=[new_array,empty]
ENDIF ELSE IF edge eq 1 or edge eq 3 THEN BEGIN
    empty=replicate(value,arr_size(1),extension)
    IF edge eq 1 THEN new_array=[[empty],[new_array]] ELSE $
       new_array=[[new_array],[empty]]
ENDIF ELSE print,'Invalid edge.  Edge must be between 0 (left) and 3(top).'

return,new_array

end


;fiunction to contract array in a single dimension
function array_contract,array,contraction,edge

new_array=array

arr_size=size(new_array)

CASE edge OF
    0: new_array=new_array[contraction:arr_size(1)-1,*]
    1: new_array=new_array[*,contraction:arr_size(2)-1]
    2: new_array=new_array[0:arr_size(1)-contraction-1,*]
    3: new_array=new_array[*,0:arr_size(2)-contraction-1]
    ELSE: print,'Invalid edge.  Edge must be between 0 (left) and 3(top).'
ENDCASE

return,new_array
    
end

;Function to perform complete dilation or contraction of array.
function array_dilate,array,dilation,contract=contract,value=value

new_array=array

FOR edge=0,3 DO BEGIN
    IF keyword_set(contract) THEN BEGIN
        new_array=array_contract(new_array,dilation,edge)
    ENDIF ELSE new_array=array_extend(new_array,dilation,edge,value=value)
ENDFOR

return,new_array

end
