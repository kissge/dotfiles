package 'git'
package 'zsh'
package 'tmux'

execute 'git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh' do
  user node['user']
  not_if 'test -d ~/.oh-my-zsh'
end

execute 'Setup SAO' do
  user node['user']
  command <<EOS
      git clone https://github.com/kissge/SAO.git ~/.sao &&
      rm -f ~/.zshrc &&
      ln -s ~/.sao/shrc/eki.zshrc ~/.zshrc
EOS
  not_if 'test -d ~/.sao'
end

# Looks like Amazon Linux 2 doesn't have chsh?
execute "usermod --shell /bin/zsh #{node['user']}"
