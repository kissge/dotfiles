package 'git'
package 'zsh'
package 'tmux'

execute 'Setup Oh My Zsh' do
  user node['user']
  command <<EOS
      git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
      git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
EOS
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

execute 'Install diff-so-fancy' do
  user node['user']
  command <<EOS
      mkdir -p ~/.local/bin &&
      cd ~/.local/bin &&
      curl -OL https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/diff-so-fancy &&
      chmod +x diff-so-fancy &&
      mkdir -p lib &&
      cd lib &&
      curl -OL https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/lib/DiffHighlight.pm
EOS
  not_if 'which diff-so-fancy'
end

execute 'Link .gitconfig' do
  user node['user']
  command 'ln -s ~/.sao/bootstrap/.gitconfig ~/'
  not_if 'test -f ~/.gitconfig'
end

execute 'Link .tmux.conf' do
  user node['user']
  command 'ln -s ~/.sao/bootstrap/.tmux.conf ~/'
  not_if 'test -f ~/.tmux.conf'
end
