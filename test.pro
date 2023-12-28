;+
;- LAST UPDATED:
;-   27 December 2023 ( organization / comments / documentation )
;-   13 December 2022 ( actual code )
;-
;- PURPOSE:
;-   Display current flare id (if set) to confirm (or simply lost track..),
;-    & provide option to enter differnt flare id if another is desired,
;-    followed by (hopefully) automatic running of relevant Modules to redefine
;-    flare structures and other variables specific to each event.
;-
;- INPUT:
;-   flare_id = string of length = 3, e.g. 'x22'
;-    ==>> What is purpose of user-input id if checking existance/def of current one?
;-          Forgot primary reasons for starting this code.
;-      -- 27 Dec 2023
;=


;pro TEST, testid  ; ???

pro TEST

    ; test using hardcoded flare id
    ;  final code would pull this value from current IDL session somehow,
    ;  and compare against

    test_flare_id = 'x22'

    ; display nesting level of procedures/function
    help, /traceback
    ;
    print, 'The current flare id is: ', test_flare_id
    print, '  Is this correct?'
    ;read, 'Is this the flare you want?  ', response
    response = ''
    help, response
    read, response;, format='(A1)'
    help, response
    ;
    testid = ''
    ;testid = 'n'
    ;testid = 'y'
    testid = 'q'
    ;
    if ( strlowcase(testid) ne ( 'n' || 'y' || 'q' ) ) then begin
        print, "Incorrect input."
    endif else print, 'Great job!'
    ;
    testid = 'm73'
    print, 'Flare ID = ', testid
    ;
    read, testid, 'Type desired flare (or "enter" if already correct): '
    print, ''
    print, 'Flare ID = ', testid
    print, ''
    ;
    ;help, testid
end

test, 'm73'

end
