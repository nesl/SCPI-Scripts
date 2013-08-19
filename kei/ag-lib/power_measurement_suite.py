import SCPI
import time
import numpy

totalSamples = 6000
sampleFreq = 100

freq= SCPI.SCPI("ag-fg0")
voltage = SCPI.SCPI("ag-mm1")
current = SCPI.SCPI("ag-mm0")

#setup freq gen
freq.setSquare()
freq.setVoltage(0,3)
freq.setFrequency(sampleFreq)

#setup voltage meter
voltage.setVoltageDC("10V", "MAX")
# set external trigger
voltage.setTriggerSource()
voltage.setTriggerCount(str(totalSamples))
# wait for trigger
voltage.setInitiate()

current.setCurrentDC("800mA", "MAX")
current.setTriggerSource()
current.setTriggerCount(str(totalSamples))
current.setInitiate()

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
