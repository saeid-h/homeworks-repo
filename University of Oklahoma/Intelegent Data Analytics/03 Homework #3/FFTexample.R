
#helper function to plot the frequency spectrum based 
plot.frequency.spectrum <- function(X.k, xlimits=c(0,length(X.k)/2)) {
  plot.data  <- cbind(0:(length(X.k)-1), Mod(X.k))
 
  plot(plot.data, t="h", lwd=2, main="", 
       xlab="Frequency (Hz)", ylab="Strength", 
       xlim=xlimits, ylim=c(0,max(Mod(plot.data[,2]))))
}


#create some fake data for an example
#this data will be composed of exactly 3 sine waves with a known amplitude and frequency

acq.freq <- 100                    # data acquisition (sample) frequency (Hz)
time     <- 6                      # measuring time interval (seconds)
ts       <- seq(0,time-1/acq.freq,1/acq.freq) # vector of sampling time-points (s) 
w   <- 2*pi/time

#create the fake wave data
wave<-1.5*sin(3*w*ts) + 0.5*sin(7*w*ts) + 0.75*sin(10*w*ts)

#and plot
plot(ts,wave,type="l"); title("Eg complex wave"); abline(h=0,lty=3)


#apply the fast fourier transform
X.k <- fft(wave)    

#plot the frequency spectrum 
# -- notice we will recover the frequencies 3, 7, and 10
# -- as well as their relative strengths
plot.frequency.spectrum(X.k,xlimits=c(0,20))

