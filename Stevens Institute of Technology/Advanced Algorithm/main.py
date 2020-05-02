#!/usr/bin/python3

import csv
import SimpleFirewallDataStructure as SF
import time





# Translate IP from standard format to binary format
def ipTranslation (ip):
	[a, b, c, d] = ip.split(".")
	if not d.isnumeric() and not d == '*':
		[d, e] = d.split("/")
		e = int(e)
	else:
		e = 0
	
	ipb = ""
	if a == "*":
		ipb = ipb + "*"
	else:
		ipb = ipb + '{0:08b}'.format(int(a))
		if b == "*":
			ipb = ipb + "*"
		else:
			ipb = ipb + '{0:08b}'.format(int(b))
			if c == "*":
				ipb = ipb + "*"
			else:
				ipb = ipb + '{0:08b}'.format(int(c))
				if d == "*":
					ipb = ipb + "*"
				else:
					ipb = ipb + '{0:08b}'.format(int(d))
	
	if e:
		ipb = ipb[:-e] + "*"

	return ipb





# Read rule set from file
def readRules (filename):
	Rules = []
	p = 100000-1
	with open(filename, newline='') as ruleFile:
		spamreader = csv.reader(ruleFile)
		for row in spamreader:
			if row[2] == 'Allow' or row[2] == 'ALLOW':
				A = 1
			else:
				A = 0
			Rules.append([p, ipTranslation(row[0]), ipTranslation(row[1]), A])
			p = p - 1

	return Rules



# Read traffic from file
def readTraffic (filename):
	Traffics = []
	with open(filename, newline='') as testFile:
		spamreader = csv.reader(testFile)
		for row in spamreader:
			Traffics.append([ipTranslation(row[0]), ipTranslation(row[1])])

	return Traffics





# main

# Read reuls and traffics from file
# Rules = readRules ('Rules.csv')
originalRuleSetA = readRules ('RuleSetA.txt')
originalRuleSetB = readRules ('RuleSetB.txt')
originalRuleSetC = readRules ('RuleSetA.txt')
Traffics = readTraffic ('TestIP.csv')

M = 100000
# originalRuleSetA.append([M, '*', '*', 0])
originalRuleSetB.append([M, '*', '*', 0])
# originalRuleSetC.append([M, '*', '*', 0])

# print ("start")
RuleSetC = SF.splitRules (originalRuleSetC)
# for i in range(len(RuleSetC)):
# 	print (RuleSetC[i])

Tree = SF.RuleTree()
# Tree.insertRule([100000, '*', '*', 1])
for i in range(len(RuleSetC)):
	Tree.insertRule(RuleSetC[i])
# for i in range(len(RuleSetC)):
# 	Tree.insertRule(RuleSetC[i])
# print ([RuleSetC[i] for i in range(len(RuleSetC)) if len(RuleSetC[i][1]) > 32 or len(RuleSetC[i][2]) > 32])

cacheList = list()
chacheSize = 50

# Tree.printTree()
# print (Tree.srcIP.findNode('111000110001*').rootid)

max_time = 0
for i in range(len(Traffics)):
	start_time = time.time()
	if cacheList != []:
		shortList = [cacheList[j] for j in range(len(cacheList)) \
		if cacheList[j][0] == Traffics[i][0] and cacheList[j][1] == Traffics[i][1]]
		if shortList == []:
			rule = [Traffics[i][0], Traffics[i][1], Tree.getRule(Traffics[i][0], Traffics[i][1])]
			if len(cacheList) >= chacheSize:
				del cacheList[0]
			cacheList.append(rule)
		else:
			rule = shortList[0]
	else:
		rule = [Traffics[i][0], Traffics[i][1], Tree.getRule(Traffics[i][0], Traffics[i][1])]
		cacheList.append(rule)

	end_time = time.time()
	if max_time < (end_time - start_time):
		max_time = (end_time - start_time)

	# if rule[2] == 2:
	# 	print (rule)

print ("The maximum time to find a rule for pairs of IP is:", max_time, "sec")

# Check if there is a redundancy in reul set A
c = 0
for i in range(len(originalRuleSetA)):
	for j in range(i+1,len(originalRuleSetA)):
		result = SF.detectConflict(originalRuleSetA[i],originalRuleSetA[j])
		if result[0] == 'Redundant' and result[1] == 'No Conflict':
			# print (M-originalRuleSetA[i][0],M-originalRuleSetA[j][0])
			# print (originalRuleSetA[i],originalRuleSetA[j])
			c = c + 1
print ("Number of redundant rules in RuleSetA:", c)

# Check if there is some rules is set A and B that behaves differently
# c = 0
# for i in range(len(originalRuleSetA)):
# 	for j in range(len(originalRuleSetB)):
# 		result = SF.detectConflict(originalRuleSetA[i],originalRuleSetB[j])
# 		if result[0] != 'No Coverage' and result[1] == 'Conflict':
# 			if (len(originalRuleSetA[i][1]) == 32 and len(originalRuleSetA[i][2]) == 32) or \
# 			(len(originalRuleSetB[j][1]) == 32 and len(originalRuleSetB[j][2]) == 32) and \
# 			originalRuleSetA[i][3] == 1:
# 				# print (RuleSetA[i],RuleSetB[j])
# 				c = c + 1
# print ("Partially or totally conflicted rules in RuleSetA and RuleSetB: ", c)


c = 0
for i in range(len(originalRuleSetA)):
	for j in range(len(originalRuleSetB)):
		result = SF.detectConflict(originalRuleSetA[i],originalRuleSetB[j])
		if result[0] == 'Redundant' and result[1] == 'Conflict':
			# print (originalRuleSetA[i],originalRuleSetA[j])
			c = c + 1
print ("Redundant and conflicted rules in RuleSetA and RuleSetB: ",c)


c = 0
for i in range(len(RuleSetC)):
	for j in range(i+1,len(RuleSetC)):
		result = SF.detectConflict(RuleSetC[i],RuleSetC[j])
		if result[0] == 'Coverage':
			# print (RuleSetC[i],RuleSetC[j])
			c = c + 1
print ("Partially or totally covered rules in RuleSetA: ",c)


c = 0
for i in range(len(originalRuleSetA)):
	for j in range(len(RuleSetC)):
		result = SF.detectConflict(originalRuleSetA[i],RuleSetC[j])
		if result[0] == 'Redundant' and result[1] == 'Conflict':
			# print (RuleSetA[i],RuleSetC[j])
			c = c + 1
print ("Redundant and conflicted rules in RuleSetA after breaking down: ", c)

# print ([RuleSetC[i] for i in range(len(RuleSetC)) if len(RuleSetC[i][1]) < 3 or len(RuleSetC[i][2]) < 3])


RuleSetA = SF.splitRules (originalRuleSetA)
RuleSetB = SF.splitRules (originalRuleSetB)

# print (len(RuleSetA))
# print (len(RuleSetB))

TreeA = SF.RuleTree()
# TreeA.insertRule([100000, '*', '*', 1])
for i in range(len(RuleSetA)):
	TreeA.insertRule(RuleSetA[i])

# TreeA.printTree()

TreeB = SF.RuleTree()
# TreeB.insertRule([100000, '*', '*', 1])
for i in range(len(RuleSetB)):
	TreeB.insertRule(RuleSetB[i])

# TreeB.printTree()

# Check if there is some rules is set A and B that behaves differently
c = 0
for i in range(len(RuleSetA)):
	for j in range(len(RuleSetB)):
		result = SF.detectConflict(RuleSetA[i],RuleSetB[j])
		if result[0] != 'No Coverage' and result[1] == 'Conflict':
			# print (M-RuleSetA[i][0], M-RuleSetB[j][0])
			c = c + 1
if c == 0:
	print ("RuleSetA and RuleSetB are equivalant.")
else:
	print ("RuleSetA and RuleSetB are not equivalant. There are", c, "Conflict.")

# Traffics.append([ipTranslation('1.1.1.1'), ipTranslation('1.1.1.1')])
# # print(Traffics)
# c = 0
# for i in range(len(Traffics)):
# 	rA = TreeA.getRule(Traffics[i][0], Traffics[i][1])
# 	rB = TreeB.getRule(Traffics[i][0], Traffics[i][1])
# 	print (rA, rB)
# 	if rA != rB:
# 		print (Traffics[i])
# 		c = c + 1
# print ("Conflicted traffic nemubers:", c)		
			
# TreeA.printTree()
# TreeB.printTree()