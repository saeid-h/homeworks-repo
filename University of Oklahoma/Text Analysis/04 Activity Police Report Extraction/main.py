 #!/usr/bin/env python
 
# -*- coding: utf-8 -*-

import normanpd
from normanpd import normanpd

def main():
	# Download data
	normanpd.fetchincidents()
				
	# Extract Data
	incidents = normanpd.extractincidents()
				
	# Create Dataase
	normanpd.createdb()
				
	# Insert Data
	normanpd.populatedb(incidents)
				
	# Print Status
	normanpd.status()
				
if	__name__ == '__main__':
	main()
