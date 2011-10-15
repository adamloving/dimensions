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
###
### Usage: get_feed_data.py <url_file>
###
### Requires: http://code.google.com/p/feedparser/

import feedparser
import json
import os
import time

class RssEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, time.struct_time):
            return time.strftime('%Y-%m-%d %H:%M', obj)
        elif isinstance (obj, CharacterEncodingOverride):
            pass
        return json.JSONEncoder.default(self, obj)

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
        if entry.has_key('content'):
            output['article_text'] = entry['content'][0]['value']
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
    data = feedparser.parse(feed_url)
    #print str(data)
    print json.dumps(data, indent=2, skipkeys=True, cls=RssEncoder)

# dump_raw_feed('http://feeds.feedburner.com/CityOfSeattleNewsReleases')
# dump_raw_feed('http://westseattleblog.com/feed')
process_feeds('urls')
