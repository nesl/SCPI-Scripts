import SCPI
import time
import numpy

totalSamples = 10
sampleFreq = 100

#freq= SCPI.SCPI("172.17.5.121")
dmm = SCPI.SCPI("172.17.5.131")

#setup freq gen
#freq.setSquare()
#freq.setVoltage(0,3)
#freq.setFrequency(sampleFreq)

#setup voltage meter
#dmm.setVoltageDC("10V", "MAX")
# set external trigger
#dmm.setTriggerSource("INT")
#dmm.setTriggerCount(str(totalSamples))
# wait for trigger
dmm.setInitiate()

dmm.setCurrentDC("500mA", "MAX")
dmm.setTriggerSource("INT")
dmm.setTriggerCount(str(totalSamples))
dmm.setInitiate()

time.sleep(1)

#freq.setOutput(1)

currentMeasurements = []
#voltageMeasurements = []

while 1:

    if len(currentMeasurements) < totalSamples:
        currentMeasurements += dmm.getMeasurements()

    if (len(currentMeasurements) >= totalSamples):
        break
    time.sleep(0.1)

#freq.setOutput(0)

s = 0
for i in range(0, totalSamples):
	print float(currentMeasurements[i])

#print "Average Power Consumption: ", s/float(totalSamples), "W avg volt: ", numpy.mean(voltageMeasurements), "V avg current: ", numpy.mean(currentMeasurements), "A"
