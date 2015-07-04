#!/bin/bash
filewatcher '*/*.rb' 'rspec test/test.rb -f html > test.html'
