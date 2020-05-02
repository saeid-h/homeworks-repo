
#!/usr/bin/env python


import csv
import random

random.seed(1000)

def generateIP ():
	p = random.randint(0,50)
	if not p:
		a = str(random.randint(1,255))
		b = str(random.randint(0,255))
		c = str(random.randint(0,255))
		d = str(random.randint(0,255))
		e = str(random.randint(1,24))
	else:
		e = 0
		p = random.randint(0,50)
		if not p:
			a = '*'
			b = '*'
			c = '*'
			d = '*'
		else:
			a = str(random.randint(1,255))
			p = random.randint(0,10)
			if not p:
				b = '*'
				c = '*'
				d = '*'
			else:
				b = str(random.randint(0,255))
				p = random.randint(0,5)
				if not p:
					c = '*'
					d = '*'
				else:
					c = str(random.randint(0,255))
					p = random.randint(0,2)
					if not p:
						d = '*'
					else:
						d = str(random.randint(0,255))

	if not e:
		ip = str(a) + '.' + str(b) + '.' + str(c) + '.' + str(d) 
	else:
		ip = str(a) + '.' + str(b) + '.' + str(c) + '.' + str(d) + '/' + str(e)
	return ip



ruleFile = open('Rules.csv', 'w')

Rules = [['*.*.*.*', '*.*.*.*', 'Allow']]
for i in range(999):
	p = random.randint(0,4)
	Action = 'Block' if p else 'Allow'
	Rules.append([generateIP(), generateIP(), Action])
	
print (Rules)


with ruleFile:
    writer = csv.writer(ruleFile)
    writer.writerows(Rules)
     
print("Writing complete")

