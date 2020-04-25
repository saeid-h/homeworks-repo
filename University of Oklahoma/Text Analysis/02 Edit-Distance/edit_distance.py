#!/usr/bin/python
# coding=utf-8
# ^^ because https://www.python.org/dev/peps/pep-0263/

from __future__ import division

# Source: https://en.wikipedia.org/wiki/Levenshtein_distance

def  distance (StrA, StrB):
	
	# base case: empty strings
	if len(StrA) == 0:
		return len(StrB)
	if len(StrB) == 0:
		return len(StrA)
		
	# test if last characters of the strings match	
	if StrA[-1] == StrB[-1]:
		cost = 0
	else:
		cost = 1
	
	# return minimum of delete char from s, delete char from t, and delete char from both */
	return min(distance(StrA[:-1], StrB) + 1, distance(StrA, StrB[:-1]) + 1, distance(StrA[:-1], StrB[:-1]) + cost)	