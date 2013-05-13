#Season Ticket Tracker

A project to handle managing season tickets.

##Environment Setup

The following describes the different pieces needed to get Season Ticket Tracker running on your machine. It is based on development using Mac OS X.

You will need a local instance of Postgres to connect to.

###Bundler

After cloning the repository, run bundler to retrieve dependencies:

    $ bundle install

###MLB Schedules Gem

Currently, this project is using my [MLBSchedules](http://github.com/borwahs/mlbschedules/) gem which has not been officially released. Make sure to pull down the repo and  install it if you plan to run the schedule_loader.

###Database Configuration

From command line, connect to `psql`:

    $ psql -h localhost
    
Add a new database via `psql`:

    localhost=# CREATE DATABASE stt;

Modify config.yml to setup database connection:

    dbopts:
      :adapter: postgres
      :host: localhost
      :port: 5432
      :database: stt

###Schema

Run the schema script to create the necessary database structure:

    $ ruby schema.rb
    
In the future, migrations will be used to better handle changes. For now, when a table definition changes, it will have to be dropped (which would lose existing data) or the changes will have to be manually applied.

###Pow

Use [Pow](http://pow.cx/) by [37signals](http://37signals.com/) to quickly access Season Ticket Tracker.

Follow instructions to download Pow from the main page.

To setup Season Ticket Tracker, run the following:

    $ cd ~/.pow
    $ ln -s /path/to/season-ticket-tracker/ stt
    
Now you will be able to access the site at `http://stt.dev/`.

##Schedule Loader

You can load the team's schedule using schedule_loader. At the moment, you can just run it with the following command:

    $ ruby schedule_loader.rb
    
If you want to use a different year or team, you will have to change the class before running. This will be more robust in the future.

##Open Source Usage

The following is a list of open-source components used:

* [Normalize.css](http://necolas.github.io/normalize.css/)
* [Gridism](http://cobyism.com/gridism/)
* [jQuery](http://jquery.com/)
* [Knockout.js](http://knockoutjs.com/)

##License

Season Ticket Tracker is released under the MIT license.