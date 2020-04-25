#!/usr/bin/python
# -*- coding: utf-8 -*-

# Author:       Saied Hosseinipoor
# email:        saied@ou.edu
# Date:         April 2nd, 2017


# Reqferences ------------------------------------------------------------------

# RegExLib.com
# StackOverFlow.com

# Required Packages ------------------------------------------------------------

from optparse import OptionParser
import glob
import re
import codecs
import nltk
import sys
from bs4 import BeautifulSoup
import xml.etree.ElementTree as ET

from nltk import sent_tokenize
from nltk import word_tokenize
from nltk import pos_tag
from nltk import ne_chunk

from reportlab.pdfgen import canvas

from nltk.corpus import wordnet as wn



# Functions:  ------------------------------------------------------------------

# Convert redacted word:  -----------------------------------------------------

def convertWord (Word, ch='\u2588'):
    newWord = ''
    for letter in Word:
        if letter == ' ':
            newWord += ' '
        else:
            newWord += ch
            
    return newWord
    


# Get entities in a text:  -----------------------------------------------------

def get_entity(text, find='PERSON'):
    """Prints the entity inside of the text."""
    names = list()
    for sent in sent_tokenize(text):
        for chunk in ne_chunk(pos_tag(word_tokenize(sent))):
            if hasattr(chunk, 'label') and chunk.label() == find:
                #print(chunk.label(), ' '.join(c[0] for c in chunk.leaves()))
                names.append(' '.join(c[0] for c in chunk.leaves()))
    return set(names)
                
    
# Reading file functions:  -----------------------------------------------------

def read_html_file (target_file):
    html = codecs.open (target_file, 'r', 'utf-8').read()
    soup = BeautifulSoup(html, "lxml")
    for script in soup(["script", "style"]):
        script.extract()
    text = soup.get_text()
    return text

def read_text_file (target_file):
    return codecs.open (target_file, 'r', 'utf-8').read()

def read_xml_file (target_file):
    tree = ET.parse (target_file) 
    text = ET.tostring(tree, encoding='utf-8', method='text')
    return text



# Make a gender-related set  ---------------------------------------------------

def gender_related_set():
    s = {'she', 'he', 'She', 'He', 'Him', 'Her', 'His', 'Her', 'Hers'}
    s = s | {'himself', 'herself','him', 'Himself', 'Herself'}
    s = s | {'her', 'his', 'hers'}
    return s



# Redact Dates:  ---------------------------------------------------------------

def redact_dates (text):
    
    count = 0
    total_found = list()
    
    regEx = r'\d{1,2}\/\d{1,2}\/\d{4}'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    found.sort (key =len, reverse=True)
    for item in found:
        text = text.replace (item, convertWord(item))
    
    regEx = r'(?:J[aAuU][nNlL][uUAarRyeEY]*|F[Ee][bB][RrAaUuRrYy]*|M[Aa][RryY][cChH]*|A[pPuU][rRgG][iIlLstTeE]*|S[eE][pP][eEtTMmBbRr]*|O[cC][Tt][oObBEeRr]*|N[oO][vV][eEmMbBrR]*|D[eE][cC][mMbBeErR]*)[\s\.,\?]*\d{,2}\s*,?\s*\d{,4}'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    #print (found)
    found.sort (key =len, reverse=True)
    for item in found:
        text = text.replace (item, convertWord(item))
    
    regEx = r'20\d{2}(-|\/|\.)((0[1-9])|(1[0-2]))(-|\/)((0[1-9])|([1-2][0-9])|(3[0-1]))(T|\s)(([0-1][0-9])|(2[0-3])):([0-5][0-9]):([0-5][0-9])'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    found.sort (key =len, reverse=True)
    for item in found:
        text = text.replace (item, convertWord(item))
    
    return text, count, total_found
  


# Redact Dates:  ---------------------------------------------------------------

def redact_times (text):
    
    count = 0
    total_found = list()
    
    regEx = r'(?:\.|\s)*(?:[0-1]?[0-9]|[2][0-3]):[0-5][0-9](?::\d{2})?\s*(?:[pPaA][mM])?(?:\.|\s)*'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    found.sort (key =len, reverse=True)
    for item in found:
        text = text.replace (item, convertWord(item))
    
    regEx = r'\s+20\d{2}(-|\/|\.)((0[1-9])|(1[0-2]))(-|\/)((0[1-9])|([1-2][0-9])|(3[0-1]))(T|\s)(([0-1][0-9])|(2[0-3])):([0-5][0-9]):([0-5][0-9])'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    found.sort (key =len, reverse=True)
    for item in found:
        text = text.replace (item, convertWord(item))
    
    return text, count, total_found
     


# Redact Phone Numbers:  -------------------------------------------------------

def redact_phones (text):
    
    count = 0
    total_found = list()
    
    regEx = r'(?:\s+(?:\+|00)?[1-9]\d{,2}(?:\s+|\-|\.)?)?\(?\d{2,4}\)?(?:\s|\-|\.)+(?:(?:\d{3,4}(?:\s|\-|\.)+\d{4})|[a-zA-Z0-9]{3}\-[a-zA-Z0-9]{4})'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    found.sort (key =len, reverse=True)
    for item in found:
        text = text.replace (item, convertWord(item))
       
    return text, count, total_found
     


# Redact Street Addresses:  ----------------------------------------------------

def redact_streets (text):
    
    count = 0
    total_found = list()
    
    regEx = r'\d+[a-zA-z]?[\s,\\\.]+(?:[A-Z][a-z|\d]*[\s,\\\.]+)+(?:A[LKSZRAP]|C[AOT]|D[EC]|F[LM]|G[AU]|HI|I[ADLN]|K[SY]|LA|M[ADEHINOPST]|N[CDEHJMVY]|O[HKR]|P[ARW]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY])[\s,\\\.]+(?:\d{5})?'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    found.sort (key =len, reverse=True)
    for item in found:
        text = text.replace (item, convertWord(item))
           
    return text, count, total_found
             


# Redact Places:  --------------------------------------------------------------

def redact_places (text):
    
    count = 0
    total_found = list()
    
    regEx = r'[A-Z]\w+[\s,]+(?:A[LKSZRAP]|C[AOT]|D[EC]|F[LM]|G[AU]|HI|I[ADLN]|K[SY]|LA|M[ADEHINOPST]|N[CDEHJMVY]|O[HKR]|P[ARW]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY])\s*'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    found.sort (key =len, reverse=True)
    for item in found:
        text = text.replace (item, convertWord(item))
        
    found_places = get_entity(text, find='GPE')
    total_found.append(found_places) 
    
    for found_place in found_places:
        count += len(re.findall(found_place, text))
        text = text.replace (found_place, convertWord(found_place))
    
    
    return text, count, total_found
             

# Redact Emails:  --------------------------------------------------------------

def redact_emails (text):
    
    count = 0
    total_found = list()
    
    regEx = r'\s*(?:\w|\d|[\!#\%\$&_\.])*@(?:\w|\d)*\.(?:\w|\d){1,4}'
    found = re.findall (regEx, text)
    total_found += found
    count = count + len(found)
    found.sort (key =len, reverse=True)
    for item in found:
        print (item)
        text = text.replace (item, '\u2588'*len(item))
    
    return text, count, total_found
             


# Redact Names:  ---------------------------------------------------------------

def redact_names (text):
    
    #from nltk.corpus import names
    #name_list = names.words('male.txt')
    #name_list += names.words('female.txt')
        
    #words = nltk.word_tokenize(text)  
    #found_names = set(name_list) & set(words) 
    
    found_names = get_entity(text)
    
    count = 0
 
    for found_name in found_names:
        count += len(re.findall(found_name, text))
        #print (found_name)
        text = text.replace (found_name, convertWord(found_name))
        #text = text.replace (found_name, '\u2588' * len (found_name))
    
    return text, count, found_names
             


# Redact Concepts:  ------------------------------------------------------------

def redact_concepts (text, concepts_list):
    
    concepts = list(concepts_list)
    for concept in concepts_list:
        for synset in wn.synsets(concept):
            for word in synset.lemma_names():
                concepts.append(word) 
    concepts = set(concepts)
    concepts = concepts & set(nltk.word_tokenize(text))
    #print (concepts)
    
    sents = nltk.sent_tokenize(text)
    count = 0
    found_sents = list()
    
    for concept in concepts:
        count += len(re.findall(concept, text))
        for i in range(len(sents)):
            if sents[i].lower().find(concept) != -1:
                found_sents.append (sents[i])
                #print (sents[i])
                sents[i] = '\u2588' * len(sents[i])
    
    text = ''
    for sent in sents:
        text += sent    
     
    return text, count, found_sents



# Redact Gender-Related Words:  ------------------------------------------------

def redact_genders (text):
    
    g_set = gender_related_set()
    
    words = nltk.word_tokenize(text)  
    #words = [x.lower() for x in words]
    found_words = g_set & set(words) 

    count = 0
    
    for found_word in found_words:
        count += len(re.findall(' '+found_word+' ', text))
        text = text.replace (' '+found_word+' ', convertWord(' '+found_word+' '))
            
    return text, count, found_words



# Redact Export Text to PDF:  --------------------------------------------------

def export_to_pdf (text, destination):
    
    from reportlab.lib.units import inch
    from textwrap import wrap
    
    if len (text) > 0:
        x = 0.8*inch
        y = 11.0*inch
        c = canvas.Canvas (destination + '.pdf')
        wraped_text = "\n".join(wrap(text, 80)) # 80 is line width
        for line in wraped_text.split('\n'):
            c.drawString(x, y, line)
            y -= 16
            if y < 30:
                c.showPage()
                y = 11.0*inch
        c.save()
        return 0
    else:
        return -1








# Parse the Command-line Options  ----------------------------------------------

def flagRecognition ():
    
    parser = OptionParser()

    parser.add_option("-i", "-I", "--input", "--inputs", 
                        type="string", dest="inputFile",  action="append",
                        help="Input file(s) name", metavar="FILES")
                                 
    parser.add_option("-o", "-O", "--output",
                        type="string", dest="outputFile",
                        help="Output filename/destination")

    parser.add_option("-c", "--concept", "--concepts",
                        type="string", dest="concepts",  action="append",
                        help="Redact concepts")

    parser.add_option("-s", "--stat", "--stats",
                        type="string", dest="stats",  action="append",
                        help="Get the statatistics ???")

    parser.add_option("-d", "--dates", "--date",
                        action="store_true", dest="dates", default=False,
                        help="Redact dates")

    parser.add_option("-t", "--times", "--time",
                        action="store_true", dest="times", default=False,
                        help="Redact times")

    parser.add_option("-a", "--stree-address", "--addresses",
                        action="store_true", dest="streets", default=False,
                        help="Redact street addresses")

    parser.add_option("-l", "--places", "--palce",
                        action="store_true", dest="places", default=False,
                        help="Redact genders")

    parser.add_option("-n", "--names", "--name",
                        action="store_true", dest="names", default=False,
                        help="Redact names")

    parser.add_option("-e", "--emails", "--email",
                        action="store_true", dest="emails", default=False,
                        help="Redact emails and net IDs")

    parser.add_option("-p", "--phones", "--phone",
                        action="store_true", dest="phones", default=False,
                        help="Redact phone numbers")
                    
    parser.add_option("-g", "--genders", "--gender", 
                        action="store_true", dest="genders", default=False,
                        help="Redact genders")
  
    (options, args) = parser.parse_args()
    
    return options, args



# Parse the target files  ------------------------------------------------------

def downloadFiles (options, inputFile_list=[]):

    #inputFile_list = list()

    if options.inputFile is None:
        print ("There is no file to redact ...")
    else: 
        for file_mask in options.inputFile:
            inputFile_list += glob.glob(file_mask)
        
    if inputFile_list == '':
        print ("There is no file to redact ...")
    
    #print ("File list: ", inputFile_list)
    
    return inputFile_list



# Read the input files  --------------------------------------------------------

def getText (options, target_file):
    
    if options.stats:
        print ('Operation on {} is in progress ...'.format(target_file))
        
    if re.search(r'.*html$', target_file):
        text = read_html_file (target_file)
      
    elif re.search(r'.*txt$', target_file):
        text = read_text_file (target_file)  
    
    elif re.search(r'.*xml$', target_file):
        text = read_xml_file (target_file)
    
    else:
        if options.stats:
         print (target_file + "format is not supported!")   
        
    return text
    
    

# Redact the target files  -----------------------------------------------------

def doRedaction (options, text):
           
    if options.dates:
        (text, stats, items) = redact_dates (text)
        if options.stats:
            print ('{} dates redacted. The found items are:'.format(stats))
            print (items)
  
    if options.times:
        (text, stats, items) = redact_times (text)
        if options.stats:
            print ('{} times redacted. The found items are:'.format(stats))
            print (items)
          
    if options.phones:
        (text, stats, items) = redact_phones (text)
        if options.stats:
            print ('{} phone numbers redacted. The found items are:'.format(stats))
            print (items)
                    
    if options.streets:
        (text, stats, items) = redact_streets (text)
        if options.stats:
            print ('{} street addresses redacted. The found items are:'.format(stats))
            print (items)
        
    if options.places:
        (text, stats, items) = redact_places (text)
        if options.stats:
            print ('{} places redacted. The found items are:'.format(stats))
            print (items)
             
    if options.emails:
        (text, stats, items) = redact_emails (text)
        if options.stats:
            print ('{} emails. The found items are:'.format(stats))
            print (items)      
    
    if options.names:
        (text, stats, items) = redact_names (text)
        if options.stats:
            print ('{} names redacted. The found items are:'.format(stats))
            print (items)
      
    if not options.concepts is None:
        (text, stats, items) = redact_concepts (text, options.concepts)
        if options.stats:
            print ('{} concepts redacted. The found items are:'.format(stats))
            print (items)

    if options.genders:
        (text, stats, items) = redact_genders (text)
        if options.stats:
            print ('{} gender-related concepts redacted. The found items are:'.format(stats))
            print (items)

    
    return text
    
# Send output to pdf files  ----------------------------------------------------

def export2pdf (options, text):
            
    if options.outputFile is None:
        output_path = ''
    else: 
        output_path = options.outputFile 
              
           
    file_name = target_file.split('/')
    file_name = file_name [-1]
    file_name = output_path + file_name
    ex = export_to_pdf (text, file_name)       
    if options.stats:
        print ('Writting in output file is on progress ...')
        if ex == 0:
            print ('File exported into a pdf format.')
        else:
            print ('Error in exporting to pdf.')
        




# Main part --------------------------------------------------------------------

options, args = flagRecognition ()
inputFile_list = downloadFiles (options)

for target_file in inputFile_list: 
    
    text = getText (options, target_file)
    
    text = doRedaction (options, text)
    
    export2pdf (options, text)