;+
;- 06 November 2020 (copied main code from 2020-10-21.pro)
;-
;- Make .sav files with "during" power maps (one for each flare)
;- and with header info for obs. time close to middle of map.



restore, '../BDAmaps.sav'

restore, '../multiflare_struc.sav'

c30_1600_powermap = aia1600maps[*,*,1]
c30_1700_powermap = aia1700maps[*,*,1]
m73_1600_powermap = aia1600maps[*,*,4]
m73_1700_powermap = aia1700maps[*,*,4]
x22_1600_powermap = aia1600maps[*,*,7]
x22_1700_powermap = aia1700maps[*,*,7]

;-------------------------------------------------

;-
;- Should be able to set this here as well.. much easier!
;-   flare_num=0
;-   flare_num=1
;-   flare_num=2
;-
instr='aia'
;channel=1600
channel=1700
;-
;
;- NOTE: read_my_fits runs @parameters, but locally, so needs to be run at ML.
@parameters
READ_MY_FITS, index, data, fls, instr=instr, channel=channel, $
    ;ind=[200:300], $
    nodata=1, prepped=1
;
time = strmid(index.date_obs, 11, 5)
;print, time[0]
;print, strmid(gpeak, 0, 5)
;print, where( time eq strmid(gpeak, 0, 5) )
;
;z_ind = 300
;
z_ind = (where( time eq strmid(gpeak, 0, 5) ))[0]
print, gpeak
print, time[z_ind]
;
print, index[z_ind].wavelnth
print, index[z_ind].date_obs
print, class


;-----------------------

;x22_1600_header = index[z_ind]
x22_1700_header = index[z_ind]
;help, x22_1600_header
;help, x22_1700_header
;save, x22_1600_powermap, filename='x22_1600_powermap.sav'
;save, x22_1600_header, filename='x22_1600_header.sav'
save, x22_1700_powermap, filename='x22_1700_powermap.sav'
save, x22_1700_header, filename='x22_1700_header.sav'

;c30_1600_header = index[z_ind]
;c30_1700_header = index[z_ind]
;help, c30_1600_header
;save, c30_1600_powermap, filename='c30_1600_powermap.sav'
;save, c30_1600_header, filename='c30_1600_header.sav'
;save, c30_1700_powermap, filename='c30_1700_powermap.sav'
;save, c30_1700_header, filename='c30_1700_header.sav'

;m73_1600_header = index[z_ind]
;m73_1700_header = index[z_ind]
;help, m73_1600_header
;help, m73_1700_header
;save, m73_1600_powermap, filename='m73_1600_powermap.sav'
;save, m73_1600_header, filename='m73_1600_header.sav'
;save, m73_1700_powermap, filename='m73_1700_powermap.sav'
;save, m73_1700_header, filename='m73_1700_header.sav'

;-----------------

buffer = 1
im = image(x22_1600_powermap, buffer=buffer )
save2, 'test_powermap_sav'

STOP

;-
;- Test my save2 procedure
;-

resolve_routine, 'save2_procedure', /either
;
testvar = 'blah'
SAVE2_PROCEDURE, testvar, filename='testsave.sav' 
;
testvar2 = 'blah again'
SAVE2_PROCEDURE, testvar2, filename='testsave.sav' 


end
