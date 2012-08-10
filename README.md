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
* Ignacio de la Madrid https://github.com/inakidelamadrid
* Alejandro Espinoza https://github.com/AlejandroEspinoza
* Antonio Chávez https://github.com/TheNaoX
* Federico Ramallo https://github.com/framallo

Prerequisites
=============

This project uses 

* Ruby on Rails 3.0 http://rubyonrails.org/
* Searchify (Heroku Add-On) http://www.searchify.com/
* compass https://github.com/chriseppstein/compass/tree
* Adam Loving's Rails Bootstrap https://github.com/adamloving/rails-bootstrap
* Twitter's Bootstrap http://twitter.github.com/bootstrap

Tweet streaming
===============

To run the tweet streaming process run on your dev environment

`rake tweetstream:start_streaming`

For heroku
`heroku run:detached rake tweetstream:start_streaming`

For deployment 
`git remote add staging dimensions@66.175.219.248:/home/dimensions/application`
`git push staging staging`

