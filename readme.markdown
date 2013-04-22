#Season Ticket Tracker

A project to handle managing season tickets.

##Environment Setup

The following describes the different pieces needed to get Season Ticket Tracker running on your machine. It is based on development using Mac OS X.

###Bundler

After cloning the repository, run bundler to retrieve dependencies:

    $ bundle install

###Pow

Use [Pow](http://pow.cx/) by [37signals](http://37signals.com/) to quickly access Season Ticket Tracker.

Follow instructions to download Pow from the main page.

To setup Season Ticket Tracker, run the following:

    $ cd ~/.pow
    $ ln -s /path/to/season-ticket-tracker/ stt
    
Now you will be able to access the site at `http://stt.dev/`.

##License

Season Ticket Tracker is released under the MIT license.