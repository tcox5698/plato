#!/bin/bash   

echo 'config timezone START'
echo "America/Chicago" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata
echo 'config timezone FINISH'

echo 'config repositories START'
if [ -e .repos_configged ]
  then echo 'repositories configured - skipping'
  else
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    touch .repos_configged
fi
echo 'config repositories FINISH'

echo 'install packages START'
if [ -e .packages_installed ]
  then echo 'packages installed - skipping'
  else
    sudo apt-get update
    sudo apt-get --assume-yes install xorg gnome-core gnome-system-tools gnome-app-install default-jre git postgresql curl zsh google-chrome-stable libpq-dev nodejs npm > /dev/null
    touch .packages_installed
fi
echo 'install packages FINISH'

echo 'install ruby and rails START'
if [ -e .ruby_rails_installed ]
  then echo 'ruby and rails installed - skipping'
  else  
    sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable --rails
    touch .ruby_rails_installed
fi
echo 'install ruby and rails FINISH'

echo 'install oh-my-zsh START'
if [ -e .oh_my_zsh_installed ]
  then echo 'oh-my-zsh installed - skipping'
  else
    su -l vagrant /vagrant/vm_config/install_oh_my_zsh.sh
    touch .oh_my_zsh_installed
fi
echo 'install oh-my-zsh FINISH'

echo 'install RubyMine START'
if [ -e .rubymine_installed ]
  then echo 'rubymine installed - skipping'
  else
    cp /vagrant/RubyMine-7.0.tar.gz ~/
    #wget 'http://download.jetbrains.com/ruby/RubyMine-7.0.tar.gz'
    tar xfz RubyMine-7.0.tar.gz
    touch .rubymine_installed
fi 
echo 'install RubyMine FINISH'

echo 'get permissions to rvm/rubies START'
sudo chmod -R a=rwx /usr/local/rvm/rubies
echo 'get permissions to rvm/rubies FINISH'
