#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require "dropbox-api/tasks"

Scrooge::Application.load_tasks

Dropbox::API::Tasks.install # this is required for link your apps.
