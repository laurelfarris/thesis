;+
;- 02 August 2022
;-
;- Calling syntax:
;-   IDL> @main
;- (run as a script, i.e. no 'end' statement at bottom of file.)
;-


@path_temp

buffer = 1
;display = 0 ??

;instr = 'hmi'
;channel = 'mag'
;channel = 'cont'
;channel = 'dop'

instr = 'aia'
;channel = '1600'
;channel = '1700'

cadence = 24
;cadence = 45



;class = 'c30'
;class = 'c46'
;class = 'm10'
;class = 'm15'

class = 'c83'
;class = 'm73'
;class = 'x22'

;flare = multiflare_struc(flare_id=class)


flare = MULTIFLARE_STRUC( flare_id=class )

;flare_path = path + 'flares/' + class + '/'
;  maybe...

stop

; 13 July 2022
;   NOTE: In order to call flare.class, flare.date, etc.,
;     must first define multiflare_struc (i.e. call function and return to ML...)
;     AND define variable "flare" as multiflare.<flare_id>
;     (restricts where these lines can go, basically).

help, flare.class
help, flare.date

;=
;= Class: change format to all lowercase with no period delimiter
;=     e.g. flare.class = 'M1.5' --> class = 'm15'

; Two steps:
;   1) Extract class into 2-element string array (without period)
;   2) Combine elements into one (lowercase) string
;class = strsplit(flare.class, '.', /extract)
;class = strlowcase(class[0] + class[1])

; Or accomplish this using a single line of code by
;   splitting and re-joining string elements in one go,
;   OR use IDL's "Replace" method for strings:
;class = strlowcase(strjoin(strsplit(flare.class, '.', /extract)))
class = strlowcase((flare.class).Replace('.',''))
help, class

;=
;= Date: change format to 'yyyymmdd' for beginning of filenames so files are ordered by flare date.
;=   e.g. flare.date = '12-Aug-2013' --> date = '20130812'

date = flare.year + flare.month + flare.day
help, date
