#!/bin/zsh

echo I AM `whoami`

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  echo LINKING PREZTO CONFIG
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

cp /vagrant/vm_config/.zpreztorc /home/vagrant

#chsh -s /bin/zsh
