#!/usr/bin/python

### Script for downloading articles from RSS feeds and outputting in a simple
### json format to stdout.
###
### JSON format: array of articles with the following fields
###   feed
###   article_title
###   article_link
###   article_date
###   article_summary
###   article_text
###   article_tags
###
### Usage: get_feed_data.py <url_file>
###
### Requires: http://code.google.com/p/feedparser/
###           http://code.google.com/p/python-calais/
###           http://pypi.python.org/pypi/simplejson/

import feedparser
from calais import Calais
import json
import os
import re
import time

CALAIS_API_KEY = "d259fgb64k9vf5j3v9mx3hg6"
calais = Calais(CALAIS_API_KEY, submitter="Seattle News Hackathon")

class RssEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, time.struct_time):
            return time.strftime('%Y-%m-%d %H:%M', obj)
        elif isinstance (obj, CharacterEncodingOverride):
            pass
        return json.JSONEncoder.default(self, obj)

def extract_image(html):
    '''Extracts the main image from the html, or returns None.'''
    match = re.search('<img\s+src="([^"]+)"', html)
    if match:
        return match.group(1)
    return None

def extract_tags(result):
    return result.get_tags()

def extract_topics(result):
    return result.get_topics()

def extract_location(result):
    entities = result.get_entities()
    location = ""
    
    for entity in entities:
        if "resolutions" in entity:
            if "latitude" in entity["resolutions"][0]:
              location = entity["resolutions"][0]["latitude"] + ", " + entity["resolutions"][0]["longitude"]
            break

    return location

def process_feed(feed_url):
    data = feedparser.parse(feed_url)
    # print json.dumps(data, indent=2, skipkeys=True, cls=RssEncoder)
    entries = []
    for entry in data['entries']:
        output = {}
        output['feed'] = data['feed']['title']
        output['article_title'] = entry['title']
        output['article_link'] = entry['link']
        if entry.has_key('updated_parsed'):
            output['article_date'] = entry['updated_parsed']
        output['article_summary'] = entry['summary_detail']['value']
        try:
          result = calais.analyze(repr(output['article_summary']))
          output['article_location'] = extract_location(result)
          output['article_tags'] = extract_tags(result)
          output['article_topics'] = extract_topics(result)
        except ValueError:
          output

        if entry.has_key('content'):
            output['article_text'] = entry['content'][0]['value']
            image_url = extract_image(output['article_text'])
            if image_url:
                output['article_image'] = image_url
        entries.append(output)
    return entries
        
def process_feeds(feed_url_file):
    feed_file = open(feed_url_file)
    entries = []
    for url in feed_file:
        entries.extend(process_feed(url))
    print json.dumps(entries, indent=2, skipkeys=True, cls=RssEncoder)
    feed_file.close()

def dump_raw_feed(feed_url):
    '''Dumps the raw feed for debugging'''
    data = feedparser.parse(feed_url)
    #print str(data)
    print json.dumps(data, indent=2, skipkeys=True, cls=RssEncoder)

# dump_raw_feed('http://feeds.feedburner.com/CityOfSeattleNewsReleases')
# dump_raw_feed('http://westseattleblog.com/feed')
process_feeds('urls')
