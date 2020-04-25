#!/usr/bin/env python
# -*- coding: utf-8 -*-

site_url = 'http://www.thelatinlibrary.com/'


from urllib import request
from bs4 import BeautifulSoup
import re
import json
import codecs



def get_text_html (URL):
    
    header_size = 0
    read_size = 0
    
    req = request.Request(URL)
    req.add_header("User-Agent",
                       "CS 5970-995 Intro to Text Analytics,\
                       Gallogly College of Engineering,\
                       University of Oklahoma")
    response = request.urlopen(req)

    if (response.getcode() == 200):
        header_size += int(response
                                    .info()
                                    .get_all('Content-Length')[0])
        temp = response.read().decode('utf-8', 'replace')
        read_size += len(temp)
        response.close()
        return temp
    else:
        print ('Couldn\'t get the book at %s' % URL)
        response.close()
        
    return header_size, read_size



def update_chapter (link, child_data):
    
    chapters = []
    chapter = {}
    verses = []
    header_tag = child_data.find(class_='pagehead')
    chapter_name = header_tag.get_text(" ", strip=True)
    chapter.update({u'chapter' : chapter_name})
    data_tag = (child_data.find_all('p', class_=''))
    i = 1
    for tag in data_tag:
        if (tag.table):
            continue
        verse = {}
        verse.update({u'verse' : i})
        verse.update({u'passage' : ' '.join(tag.get_text(' ', strip=True)
                                            .split())})
        verse.update({u'link' : link})
        verses.append(verse)
        i += 1
    chapter.update({u'verses' : verses})
    chapters.append(chapter)
    return chapters



def download_book (bookName='plautus'):
     
    book_url = bookName + '.html'
    URL = site_url + book_url
    text_html = BeautifulSoup(get_text_html(URL), 'html.parser')
    
    if bookName == 'plautus':
        author_tag = text_html.find('h1')
        author_name = (author_tag.get_text(" ", strip=True))
        date = text_html.find(class_='date')
        date = date.get_text(' ', strip=True)[6:-1]
    else:
        author_tag = text_html.find(class_='pagehead')    
        author_tag_txt = (author_tag.get_text(" ", strip=True))
        author_name = ' '.join(re.findall(r'[a-zA-Z]+', author_tag_txt))
        date = (' '.join(re.findall(r'\([\s\S]+\)', author_tag_txt)))[1:-1]
        
    #print (text_html)
    
    book_json = {}    
    book_json.update({u'author_name' : author_name})
    book_json.update({u'title' : re.sub(r'.html', '', book_url)})
    book_json.update({u'dates' : date})
    book_json.update({u'language' : u'latin'})
    
    
    child_links = text_html.find_all(href=re.compile(bookName))
    booknames = []
    for link in child_links:
        child_url = link.get('href')
        child_data = BeautifulSoup (get_text_html(site_url+child_url),
                                    'html.parser')
        
        chapters = update_chapter(site_url+child_url, child_data)
        
        book = {}
        book.update({u'bookname' : link.get_text(strip=True)})
        book.update({u'chapters' : chapters})
        booknames.append(book)
    book_json.update({u'books' : booknames})
    
    
    with codecs.open('../'+bookName+'.txt', 'w', encoding='utf-8') as f:
        f.write(json.dumps(book_json, indent=4,
                           separators=(',', ': '),
                           ensure_ascii=False))

    return True
   
    
#download_book ('plautus')
#download_book ('alanus')
#download_book ('ottofreising')
