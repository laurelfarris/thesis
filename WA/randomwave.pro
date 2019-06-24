
PRO randomwave,series,conf,delt=delt

    ; create the wavelet transform of the original series
    ; we compare the transform of each subsequent random series against this one
    origwave = wavelet(series,delt,period=period,$
	    /pad,mother=mother)

    ; the power transform is the square of the complex `amplitude' transform
    power=(ABS(origwave))^2
    ; sticking with the old notation for the array of frequencies
    ; N.B. -- this runs from large values to small
    f_inver = 1./period
    
    ; find the frequency at which the POWER is greatest for every time increment
    ; output the array of frequencies to ORIGMAXFREQ, and the array of power values
    ; to ORIGFREQPOWER
    pickpeakpower,power,origmaxfreq,f_inver,origfreqpower

    ; set a default timestep (SECIS)
    IF NOT KEYWORD_SET(delt) THEN delt = 0.022121

    nel = N_ELEMENTS(series)

    ; define the number of randomly shuffled time series we want to sample
    nshuff = 150
    
    ; define an array like ORIGFREQPOWER (number of columns = nel), but for every
    ; shuffled series (number of rows = nshuff)
    allfreqpowers = DBLARR(nel,nshuff)

    for i=0,nshuff-1 DO BEGIN

	; reshuffle the series inside this loop so we don't have to keep 150 in an
	; external array during execution
	seriesnew = shuffle(series,nel)
	
	; find the wavelet transform of this random series
	shuffwave = wavelet(seriesnew,delt,period=period,$
	    /pad,mother=mother)
    
    	; square it to get the power transform
    	shuffpower = (ABS(shuffwave))^2
        
	; find the frequency of maximum power for each time step
    	pickpeakpower,shuffpower,maxfreq,f_inver,freqpower

    	; store the power at the maximum frequency (for each t-step) in a row of ALLFREQPOWERS
    	allfreqpowers(*,i) = freqpower

    END

    ; now compare, for each timestep, how many times the peak of the power transform
    ; of a shuffled series exceeded the original power of the original peak. If you follow...
    
    ; store the *number of times* this event (or `fluke') happened for each t-step
    ; in an array called NFLUKES
    nflukes=fltarr(nel)

    ; for each timestep 
    FOR j=0,nel-1 do BEGIN
    
    	fluke=where(allfreqpowers(j,*) GE origfreqpower(j))
	nflukes(j)=n_elements(fluke)
    END

;STOP
    ; convert to a percentage of the number of `shuffles'
    nflukes = (100*nflukes) / (FLOAT(nshuff))
    conf = 100 - nflukes

END
