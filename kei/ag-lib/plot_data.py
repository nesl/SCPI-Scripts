#!/bin/python

import matplotlib.pyplot as plt
import numpy
import scipy

time = []
current = []

def main():
	#open file
	for line in open('log.txt'):
		a,b,c = line.split()
		time.append(a)
		current.append(b)
	plt.plot(time,current)
	plt.show()
		

if __name__ == '__main__':
	main()
