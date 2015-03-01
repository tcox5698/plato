#!/bin/bash   

set -e

echo 'config timezone START'
echo "America/Chicago" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata
echo 'config timezone FINISH'


echo 'install packages START'
if [ -e .packages_installed ]
  then echo 'packages installed - skipping'
  else
    sudo apt-get update
    sudo apt-get --assume-yes install default-jre git postgresql curl zsh libpq-dev nodejs npm > /dev/null
    touch .packages_installed
fi
echo 'install packages FINISH'

echo 'install prezto START'
if [ -e .prezto_installed ]
  then echo 'prezto installed - skipping'
  else
    su -c '/bin/zsh /vagrant/vm_config/install_prezto.sh' vagrant
    touch .prezto_installed
fi
echo 'install prezto FINISH'

echo 'install ruby and rails START'
if [ -e .ruby_rails_installed ]
  then echo 'ruby and rails installed - skipping'
  else
    su -l vagrant /vagrant/vm_config/install_ruby_rails.sh
    touch .ruby_rails_installed
fi
echo 'install ruby and rails FINISH'


echo 'install RubyMine START'
if [ -e .rubymine_installed ]
  then echo 'rubymine installed - skipping'
  else
    cp /vagrant/RubyMine-7.0.tar.gz ~/
#    #wget 'http://download.jetbrains.com/ruby/RubyMine-7.0.tar.gz'
    tar xzf RubyMine-7.0.tar.gz
    touch .rubymine_installed
fi
echo 'install RubyMine FINISH'

#echo 'get permissions to rvm/rubies START'
#sudo chmod -R a=rwx /usr/local/rvm/rubies
#echo 'get permissions to rvm/rubies FINISH'

echo 'install heroku toolbelt'
if [ -e .heroku_toolbelt_installed ]
  then echo 'heroku toolbelt installed - skipping'
  else
    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    touch .heroku_toolbelt_installed
fi
echo 'install heroku toolbelt FINISH'
