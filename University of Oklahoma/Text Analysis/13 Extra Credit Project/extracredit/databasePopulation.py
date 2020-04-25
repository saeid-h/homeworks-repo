#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sqlite3 as db
import codecs
import json
import fnmatch
import os


def extract_tuples (sourceFile='plautus.txt'):
    tuples = []
    with codecs.open(sourceFile, 'r', encoding='utf-8') as file:
        data = json.loads(file.read())
        date = data['dates']
        book = data['books']
        language = data['language']
        author_name = data['author_name']
        title = data['title']
        for book in data['books']:
            bookname = book['bookname']
            for chapter in book['chapters']:
                chaptername = chapter['chapter']
                for verse in chapter['verses']:
                    verseid = verse['verse']
                    passage = verse['passage']
                    link = verse['link']
                    t = (title, bookname, language, author_name
                             , date, chaptername, verseid, passage, link)
                    tuples.append(t)
    
    return tuples


def populate_data_base(tuples):
    conn = db.connect('../extraCredit.db')
    with conn:
        cur = conn.cursor()
        cur.executescript("""
                          DROP TABLE IF EXISTS extraCredit;
                          CREATE TABLE extraCredit(
                              title text,
                              book text,
                              language text,
                              author text,
                              dates text,
                              chapter text,
                              verse text,
                              passage text,
                              link text);
                          """)
        cur.executemany("""INSERT INTO extraCredit
                        VALUES(?,?,?,?,?,?,?,?,?)
                        """, tuples)
        return True


def create_tuples (source='../*.txt'):
    tuples = []    
    for file in os.listdir('.'):
        if fnmatch.fnmatch(file, source):
            tuples += extract_tuples (file)
    return tuples



#tuples = create_tuples('*.txt')
#populate_data_base(tuples)

