# Redactor
## Packages
The following packages were imported in the code:

	OptionParser
	glob
	re
	codecs
	nltk
	sys
	BeautifulSoup
	xml.etree.ElementTree
	reportlab
	textwrap
	sklearn
	
## General
### Package Structure
The package has the following directory structure:

 	redactor/          redactor/              __init__.py              redactor.py              unredactor.py          tests/
          	 pythontest.py              test_download.py              test_flagrecognition.py              test_stats.py              test_train.py              test_unredact.py              test_names.py
              test_stats.py
              test_phones.py
              test_email.py
              test_concepts.py
              test_genders.py
              test_street.py
              test_times.py
              test_places.py          docs/
          samples/
          	*.txt
          	*.html
          	...
          train/
          	nn_nn.txt (some files for training unredactor)
          	...          README.md          requirements.txt          setup.cfg          setup.py
          
The best way to insatall the project after unzipping the package is to run:

	pip3 install --editable .
	
### Execution 

The execution of the python code is exactly instructed in the problem statement:

	python3 redactor.py --input 'samples/*.html' \                    --input 'samples/*.txt' \                    --names --dates --places --phones \                    --concept 'crimes' \                    --output 'samples/' \                    --stats stderr

For each flag other types of flages have been defined to cover operator's mistakes. For example standard flag for ***Name*** redaction is `--names` but other forms of `--names` and `-n` are accpted. The other form and equivalent to above command is:

	python3 redactor.py --input 'samples/*.html' \                    -i 'samples/*.txt' \                    -ndlpc 'crimes' \                    -o 'samples/' \                    -s stderr

It could be ran in more different ways.

## Options


The python code accepts the optoions as flag like unix command type flags starting with "-" or "--". Any flag is responsible to call a function in order to performe a specfied task. 

### --names:
	(redacted_text, count, list) = redact_names (text)
It takse text as an argument, then finds all the names in the text  and counts them as ***count***, list them in ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.

For this section *get_entity()* function serches and finds the preson names and combines them into a group of names. The output is a list of simple or complex names. This list is the base for redacting names in the text. 


### --dates:
	(redacted_text, count, list) = redact_dates (text)
It takse text as an argument, then finds all the dates using **RegEx** in the text and counts them as ***count***, list them in a ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.

### --times:
	(redacted_text, count, list) = redact_times (text)
It takse text as an argument, then finds all the times using **RegEx** in the text and counts them as ***count***, list them in ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.


### --phones:
	(redacted_text, count, list) = redact_phones (text)
It takse text as an argument, then finds all the phone numbers using **RegEx** in the text and counts them as ***count***, list them in ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.

### --addresses:
	(redacted_text, count, list) = redact_streets (text)
It takse text as an argument, then finds all the street adresses using **RegEx** in the text and counts them as ***count***, list them in ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.

  
### --places:
	(redacted_text, count, list) = redact_places (text)
It takse text as an argument, then finds all the places using **RegEx** in the text and counts them as ***count***, list them in ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.

This function also uses *get_entity()* function to serche and find the locations and combines them into a group of names. The output is a list of simple or complex location names. This list is the base for redacting locations in the text. 



### --emailes:
	(redacted_text, count, list) = redact_emailes (text)
It takse text as an argument, then finds all the email addresses using **RegEx** in the text and counts them as ***count***, list them in ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.


### --genders:
	(redacted_text, count, list) = redact_genders (text)
It takse text as an argument, then finds all the gender related words in the text using a defined set and counts them as ***count***, list them in ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.


### --concepts:
	(redacted_text, count, list) = redact_concepts (text, concepts)
It takse text and concepts as arguments, then finds all the words in the text which are same as concepts or availble in their **WordNet** and counts them as ***count***, list them in ***list***, and convert the orginal text redacted by the list items with █ character and return it into ***redacted_text***.
   

### --stats:
If stats is ***on*** prints the ***count*** from other functions into output. This option helps us to trace and debug the code and get information about the process and redacting text.


## Output
Prints into a pdf file as same as input file name + '.pdf'. 


# Unredactor

This section is coded for unredacting the a text which was redacted in terms of names. In this section we tried to find the clusters of the recated words like "████ ██ █████" and guess what name could be replaced by █ character.

For this part, a set of reviews on movies considered as training set. Using *get_entity()* function, clusters of names was extracted and then a *Gaussian Naive Bayse* model was trined to predict the redacted names. Different algorithm including *MultinomialNB* and *Nearset Neighborhood* were examined but there was no better results than *GaussianNB*.

The information about the redacted names are very limeted to number of replaced charaters and spaces between them. Some information is achiveable from the contents taht the recated phrase is in surounded by.

The following features have been considered (numbers in brackets are weight of each feature):
	
	- Total Number of Characters 	[2]
	- Number of Words 				[10] (How many parts are in a phrase?)
	- Length of Part 1 				[3]
	- Length of Part 2 				[2]
	- Length of Part 3+ 			[1]
	- Hashed Left Word 				[0.1]
	- Hashed Right Word 			[0.05]
	- Hashed Left Left Word 		[0.01]
	- Hashed Right Right Word 		[0.005]

A very simple hash function converts the words after and before the keys into a integer number between 0 and 99. The weight normalizes this number into a continuous and small number. According to the vectorization, the phrase of "████ ██ █████" would be converted into **(13, 3, 4, 2, 5, x1, x2, x3, x4)** vector. The number of parts implicitly carry information about the spaces between the parts. 

Data vectorized based on the features using *Dictionary Vectorizer*, then trained model was impleneted to predict the missing names. The estimated accuracy was calculated by *accuracy_score()* between **30 - 90%** varied by the training pool size.

This method works based on the word's letter counts and results the most probable name based on statistics. It could gives the k most probable names as output. 

	redactList, prediction, text = unredact (text, k=1)

default value for k is 1 and if it is not specified it returns the most probable name. If the probabilities are same, the first one in the list would be returned. It also returns the unredacted text based on k = 1. The redactedList item is redacted words found in the text.

   
   
   
 

