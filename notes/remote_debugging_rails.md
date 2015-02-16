# Debugging Rails on Vagrant guest from Rubymine on host

## Overview

I am experimenting with RubyMine's ability to use a "remote" Ruby sdk on a vagrant guest for all its Ruby
operations. I had already figured out performing `bundle install` and `rspec` commands _through the RubyMine interface_.

I have not figured out how to start up `rails s` through RubyMine - it does not appear to have set up
my project as a "Rails" project - so there's no `test/dummy` and it complains about not being able to find
the launcher.

This was not a problem - it is easy enough to start `rails s` from the command line of the vagrant guest.

But then I wanted to debug by setting break points in the RubyMine IDE and using its debugging features.

So here are the steps I went through to accomplish that.

## The Steps

1. Edit Vagrantfile to add a new port mapping for debugger communication to the vagrant guest and __restart vagrant__.
`config.vm.network "forwarded_port", guest: 1234, host: 61234, auto_correct: true`

1. Edit Gemfile to add gems for debugging
```
gem 'ruby-debug-ide', group: [:development,:test]
gem 'debase', group: [:development,:test]
```
1. `bundle install`
1. On vagrant instance, in /vagrant, run the debugger server (this accepts remote calls to execute a process)
`rdebug-ide --host 0.0.0.0 --port 1234 --dispatcher-port 26162 -- bin/rails s`
1. on host, in RubyMine
    1. configure a "Ruby Remote Debug" runner
        1. set port to 61234 - the one vagrant is mapping to the guests 1234 port
        1. set root folder to project root
    1. use your new Runner in Debug mode. This will tell the debugger server on your vagrant guest to
        execute `bin/rails s` and establish communication with that rails process.

## WARNING: The dialog box provides a helpful but INCORRECT example for starting the debugger server (see steps above)
The BAD example command copied from RubyMine dialog box: `rdebug-ide --host 0.0.0.0--port 61234 --dispatcher-port 26162 -- $COMMAND$`

It is WRONG in two ways:

1. PORT is wrong - on the vagrant guest instance, you need the guest port, not the mapped host port
1. SYNTAX is wrong - there must be a space before --port