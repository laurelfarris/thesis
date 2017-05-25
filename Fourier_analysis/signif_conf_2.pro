;+
;   commented using http://cires.colorado.edu/geo_data_anal/assign/assign4.html
;   Assuming a Gaussian distribution for each point of your NINO3 timeseries, then each
;   point of the FFT Power Spectrum should have a chi-square
;   distribution with 2 degrees of freedom (DOF) (see Figure).
;   Looking at the curve, one can see that as one goes further to
;   the right (larger x), the probability of being greater than x
;   decreases. One can define the 95% level as that value of x
;   where there is only a 5% chance of being greater than x. This is referred to as either the
;   "95% significance level" or the "5% level of significance". Occasionally it is referred to as
;   the "95% confidence level", but the term "confidence" should really be reserved for
;   reference to "confidence intervals", which are the error bars seen on spectral plots. 
;
;   For the FFT Power Spectrum, this means that if one were to choose 20 frequencies at
;   random, then only 1 of these frequencies would be expected to have FFT Power greater
;   than this value. Therefore, if you look at your power spectrum, and several peaks are
;   above the 95% level, then you can be reasonably "confident" that these are "real" peaks,
;   not just random noise. 
;
;-



FUNCTION signif_conf, ts, p

s=stdev(ts)

N=n_elements(ts)

DOF=2

chi=chi_sqr(1.-p,DOF)

;   The value of chi-square with 2 DOF at the 5% level of significance (95% significance) is
;   5.99. To convert this into a Power that can be plotted on your FFT Power Spectrum,
;   one needs to divide by the DOF (=2), multiply by the timeseries variance s2, and divide
;   by the number of points in the spectrum N/2. 

;   In general, the formula for significance levels is:

;                  s^2 chi_sqr(1-p,DOF)
;        signif = --------------------
;                      0.5 N DOF

;   where s^2 is the variance, p is the desired significance level (such as 0.95), DOF is the
;   degrees of freedom (usually 2), and N is the number of points in the timeseries. 

signif=((s^2)*(chi))/((N/2)*DOF)




RETURN,signif
END


