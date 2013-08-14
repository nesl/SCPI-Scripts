import SCPI
import time
import numpy

totalSamples = 5000
sampleFreq = 500

freq= SCPI.SCPI("172.17.5.121")
dmm = SCPI.SCPI("172.17.5.125")

#setup freq gen
freq.setSquare()
freq.setVoltage(0,3)
freq.setFrequency(sampleFreq)

#setup voltage meter
dmm.setVoltageDC("10V", "MAX")
# set external trigger
dmm.setTriggerSource()
dmm.setTriggerCount(str(totalSamples))
# wait for trigger
dmm.setInitiate()

dmm.setCurrentDC("100mA", "MAX")
dmm.setTriggerSource()
dmm.setTriggerCount(str(totalSamples))
dmm.setInitiate()

time.sleep(1)

freq.setOutput(1)

currentMeasurements = []
voltageMeasurements = []

while 1:

    if len(currentMeasurements) < totalSamples:
        currentMeasurements += current.getMeasurements()
    if len(voltageMeasurements) < totalSamples:
        voltageMeasurements += voltage.getMeasurements()

    if (len(currentMeasurements) >= totalSamples) and (len(voltageMeasurements) >= totalSamples):
        break
    time.sleep(0.1)

freq.setOutput(0)

s = 0
for i in range(0, totalSamples):
	s += currentMeasurements[i] * voltageMeasurements[i]
	print float(i)/float(sampleFreq), currentMeasurements[i], voltageMeasurements[i]

#print "Average Power Consumption: ", s/float(totalSamples), "W avg volt: ", numpy.mean(voltageMeasurements), "V avg current: ", numpy.mean(currentMeasurements), "A"
