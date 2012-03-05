What is Dimensions?
===================

This web application is the winning entry from the [King5 News Hackathon](http://hackingseattlenews.com) 
held October 14-16th in Seattle, WA. The application is a local news aggregator with
highly customizable filtering system.

http://hackingseattlenews.com/2011/10/slides-from-the-winning-presentation/

Authors
-------

* Leon Wong https://github.com/leonwong
* Stephen Becker IV https://github.com/sbeckeriv
* Mohammad Almalkawi https://github.com/almalkawi
* Adam Loving https://github.com/adamloving
* Lewis Lin http://www.linkedin.com/in/lewislin

Prerequisites
=============

This project uses 

* Ruby on Rails 3.0 http://rubyonrails.org/
* Elastic Search http://www.elasticsearch.org/
* slim http://slim-lang.org/
* compass https://github.com/chriseppstein/compass/tree
* tire https://github.com/karmi/tire
* crack https://github.com/jnunemaker/crack
* barista https://github.com/Sutto/barista
* Adam Loving's Rails Bootstrap https://github.com/adamloving/rails-bootstrap
* Twitter's Bootstrap http://twitter.github.com/bootstrap

Elastic Search Notes
====================

`ruby script/es/load_es.rb  http://IP:9200/ && ruby script/es/load_file.rb data/articles.json http://IP:9200/`

* load_es - builds out schema for es. First arg is host
* load_file - parses json file and build out ES json. first arg file second arg host

Hosts default to local if not present

TangoSource Notes
====================

Installation

- Clone the repo
- Bundle install. Verify:
  - Rails version: 3.2.2
  - Use either mysql or postgresql in dev.
- Working routes (March, 5th, 2012)
  - /home

