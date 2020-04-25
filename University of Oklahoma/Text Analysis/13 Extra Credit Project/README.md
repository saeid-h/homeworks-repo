#Extra Credit Project

This project divided into two sections:

1.  Data Extraction
2.  Data Base Population

##Packages
The following packages have been used in two parts:

		urllib
		bs4
		re
		json
		codes
		sqlite3
		fnmatch
		os
	
##Data Extraction

For this part, data was fetched from given website. HTML file parsed by beautiful soup packe into different fields which were asked. Then data organized in a json format ant saved into a json text file.

##Data Base Population

A database has been created by using saved json files from previous section. It searches for the txt files which were saved before and converts them into predefined structured tuples and finally stores them into a table. If table is not available it creates a new table.
