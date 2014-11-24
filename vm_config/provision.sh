#!/bin/bash   


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
    sudo apt-get --assume-yes install xorg gnome-core gnome-system-tools gnome-app-install default-jre git postgresql curl zsh google-chrome-stable  > /dev/null
    touch .packages_installed
fi
echo 'install packages FINISH'

echo 'install ruby and rails START'
if [ -e .ruby_rails_installed ]
  then echo 'ruby and rails installed - skipping'
  else  
    \curl -sSL https://get.rvm.io | bash -s stable --rails
    touch .ruby_rails_installed
fi
echo 'install ruby and rails FINISH'

echo 'install oh-my-zsh START'
if [ -e .oh_my_zsh_installed ]
  then echo 'oh-my-zsh installed - skipping'
  else
    curl -L http://install.ohmyz.sh | sh
    touch .oh_my_zsh_installed
fi
echo 'install oh-my-zsh FINISH'
