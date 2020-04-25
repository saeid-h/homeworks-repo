#!/usr/bin/python3
# coding=utf-8
# ^^ because https://www.python.org/dev/peps/pep-0263/

from __future__ import division

import codecs

import json

import nltk
from nltk import sent_tokenize
from nltk import word_tokenize

# It is okay to include tokenization and symbols in the average word size count.
# Use the Thorn character (þ) to separate the fields
# Be sure to include coding=utf-8 to the first or second line

# Note, when printing to a non unicode terminal or using linux to write to a file
# http://stackoverflow.com/questions/4545661/unicodedecodeerror-when-redirecting-to-file

# Usage: python3 process-data.py > output.txt


with codecs.open("twitter.txt", encoding='utf-8') as f:
    for i, sent in enumerate(sent_tokenize(f.read())):
        print("%dþ\"%s\"þ%f" % (i, sent.strip().replace("\n", " "), sum(map(len,word_tokenize(sent)))/len(word_tokenize(sent))))


with codecs.open("twitter.txt", encoding='utf-8') as f:
    print("<document>\n\t<sentences>")
    for i, sent in enumerate(sent_tokenize(f.read())):
        print("\t\t<sentence id=\"%d\">" % i)
        print("\t\t\t<text>%s</text>" % sent.strip().replace("\n", " "))
        print("\t\t\t<avg>%d</avg>" % (sum(map(len,word_tokenize(sent))) / len(word_tokenize(sent))))
        print("\t\t</sentence>")
    print("\t</sentences>\n<document>")


with codecs.open("twitter.txt", encoding='utf-8') as f:
    sentences = []

    for i, sent in enumerate(sent_tokenize(f.read())):
        s = {"id": i, "text": sent.strip().replace("\n", " "),\
            "avg" : (sum(map(len,word_tokenize(sent))) / len(word_tokenize(sent)))}
        sentences.append(s)
    
    print(json.dumps({"documents" : {"sentences" : sentences}}, ensure_ascii=False, indent=2))

