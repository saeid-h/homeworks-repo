# Norman PD 

from urllib import request
import re
import PyPDF2
from PyPDF2 import PdfFileReader
from io import StringIO, BytesIO
import sqlite3
import random

normanpdurl = 'http://normanpd.normanok.gov/content/daily-activity'
#normanpd = 'normanpd.db'

def fetchincidents():
	return request.urlopen(normanpdurl).read().decode('utf-8')



def extractincidents():

	s = fetchincidents()
	m = re.findall(r'(?<=href=").*Incident.*pdf',s)
	
	remoteFiles = list()
	memoryFiles = list()
	pdfFiles = list()
	for i in range(0, len(m)):
		m[i] = 'http://normanpd.normanok.gov' + m[i]
		# http://stackoverflow.com/questions/9751197/opening-pdf-urls-with-pypdf
		remoteFiles.append (request.urlopen(m[i]).read())
		memoryFiles.append (BytesIO(remoteFiles[i]))
		pdfFiles.append (PdfFileReader(memoryFiles[i]))
	
	# http://stackoverflow.com/questions/28726255/
	# converting-a-pdf-file-consisting-of-tables-into-text-document-containings-tables
	dbString = []
	for pdf in pdfFiles:
		content = ""
		text = ""
		for page in range(0, pdf.getNumPages()):
			# Extract text from page and add to content
			content = pdf.getPage(page).extractText()
			text+=content
			tokens=content.split("\n")
			if page == 0:
				#print(tokens)
				dbString+=tokens[5:-3]
			else:
				dbString+=tokens[:-1]
		dbString=dbString[:-1]
		
	dblist = []
	i = 0
	while (i+5 < len(dbString)):
		if (re.match(r'.*/.*/.*:.*', dbString[i+5])):
			dblist.append(dbString[i:i+5])
			i += 5
		else:
			dblist.append([dbString[i], dbString[i+1], dbString[i+2]+" "+dbString[i+3], 
			dbString[i+4], dbString[i+5]])
			i += 6

	return dblist


	
def createdb():
	
	conn = sqlite3.connect('normanpd.db')

	# https://docs.python.org/2/library/sqlite3.html
	c = conn.cursor()
	
	# http://stackoverflow.com/questions/1601151/how-do-i-check-in-sqlite-whether-a-table-exists
	# Create table
	c.execute('''CREATE TABLE if not exists incidents(
				id INTEGER, 
				number TEXT, 
				date_time TEXT, 
				location TEXT, 
				nature TEXT, 
				ORI	TEXT)''')
	
	# Save (commit) the changes
	conn.commit()
	
	conn.close()

	return


	
def populatedb(incidents):

	# https://docs.python.org/2/library/sqlite3.html
	conn = sqlite3.connect('normanpd.db')
	c = conn.cursor()
	
	# Insert a row of data
	r = c.execute("select max(id) from incidents").fetchone()
	if (r[0] == None):
		id = 1
	else:
		id = r[0]+1
	for field in incidents:
		c.execute("INSERT INTO incidents VALUES (" + str(id) + ",'" + field[1] + 
					"','" + field[0] + "','" + field[2] + "','" + field[3] + "','" + 
					field[4] + "')")
		id += 1

	# Save (commit) the changes
	conn.commit()
	
	conn.close()
	
	return


	
def status():

	# https://docs.python.org/2/library/sqlite3.html
	conn = sqlite3.connect('normanpd.db')
	c = conn.cursor()
	
	r = c.execute("select count(*)  from incidents").fetchone()

	max_row = r[0]
	print ("\n\nTotal number of rows are = ", max_row)
	print("\n\n5 random rows of norman.db database:\n\n")
	st = ["ID:             ", 
		  "Incident Numer: ",
		  "Date/Time:      ",
		  "Location:       ",
		  "Nature:         ",
		  "Incident ROI:   "]
	for i in range(0,5):
		row = random.randint(0,max_row)
		r = c.execute("select * from incidents where id = " + str(row)).fetchone()
		for j in range(0,5):
			print (st[j], r[j])
		print ("\n")
		
	conn.close()
	
	return

def signature():
	print("\n")
	print ("normanpd version 2.0 imported into Python environment successfully!")
	print ("Code by Saeid Hosseinipoor")
	print ("email: saied@ou.edu")
	print("\n")
	return
	
	
signature()
