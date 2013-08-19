import SCPI
import time

# Sampling frequency in Hz
sampleFreq = 1000

freq= SCPI.SCPI("172.17.5.121")
#left
voltage = SCPI.SCPI("172.17.5.124") 
#right
temperature = SCPI.SCPI("172.17.5.125")

#setup freq gen
freq.setSquare()
freq.setVoltage(0,3)
freq.setFrequency(sampleFreq)

#setup voltage meter
voltage.setVoltageDC("100mV", "MAX")
# set external trigger
voltage.setTriggerSource()
voltage.setTriggerCount()
# wait for trigger
voltage.setInitiate()

temperature.setTemperature()
temperature.setTriggerSource()
temperature.setTriggerCount()
temperature.setInitiate()

time.sleep(1)

freq.setOutput(1)
curr_t = time.time()

temperatureMeasurements = []
voltageMeasurements = []

f = open("data/readings_" + str(time.time()) + ".dat", 'w')

try:
    while 1:
        temperatureMeasurements += temperature.getMeasurements()
        voltageMeasurements += voltage.getMeasurements()
        # Flush first min_len common V, I measurements 
        c_len = len(temperatureMeasurements)
        v_len = len(voltageMeasurements)
        if c_len < v_len:
            min_len = c_len
        else:
            min_len = v_len
        for i in range(min_len):
            writestr = str(curr_t) + "\t" + str(temperatureMeasurements[i]) + "\t" 
            writestr += str(voltageMeasurements[i]) + "\n"
            f.write(writestr)
            curr_t += (1.0/sampleFreq)
        # truncate the first min_len samples from both arrays
        temperatureMeasurements = temperatureMeasurements[min_len:]
        voltageMeasurements = voltageMeasurements[min_len:]
        f.flush()
        time.sleep(0.1)

except KeyboardInterrupt:
    freq.setOutput(0)
    f.close()

