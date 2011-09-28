Unhyperbole
================

Background
----------

Who doesn't like MG Siegler? He gets great scoops, likes Apple and is a good writer.

However, every good writer needs a good editor and we gather that, with the breakneck speed at which Techcrunch needs to write posts, people just don't have time to glance over his work. You see, as much as we love us some Siegler, we wish he'd just lay off the rhetorical questions. Or the three-word declarative statements. Or the use of conjunctions to begin a sentence.

So we figured that, since Erick Schonfeld is probably pretty busy at the moment, we'd write some software to solve our problem. Unhyperbole is the autoediting software of the future!

Unhyperbole scans through MG Siegler's posts and makes the following corrections:

- eliminates rhetorical questions;
- joins two sentences together if the second sentence begins with 'And' and the previous sentence did not contain 'and';
- removes sentences with less than three words in them;
- removes the 'Yes, ' with which Siegler often begins a statement; and
- replaces the 'But ' at the beginning of a sentence with 'However, '.

We think the result is prose that communicates the same information but with a more considered tone.

Usage
-----

Unhyperbole is just a simple Sinatra application.

```bash
git clone git://github.com/pyrmont/unhyperbole.git  # Warning: read-only.
cd unhyperbole
bundle install
be ruby app.rb
```

You can of course deploy Unhyperbole to [Heroku](http://heroku.com/) in a snap. That's what we're [doing](http://unhyperbole.heroku.com/).

Licence
-------

&copy; 2011 Robert Howard and Michael Camilleri. Unhyperbole is distributed under an [MIT Licence](http://en.wikipedia.org/wiki/MIT_License).