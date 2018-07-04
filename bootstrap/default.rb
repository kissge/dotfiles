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

execute 'Install diff-so-fancy' do
  user 'root'
  cwd '/usr/bin'
  command <<EOS
      curl -OL https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/diff-so-fancy &&
      chmod +x diff-so-fancy &&
      mkdir -p lib &&
      cd lib &&
      curl -OL https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/lib/DiffHighlight.pm
EOS
  not_if 'which diff-so-fancy'
end

remote_file "/home/#{node['user']}/.gitconfig" do
  source '.gitconfig'
  owner node['user']
  not_if "test -f /home/#{node['user']}/.gitconfig"
end

remote_file "/home/#{node['user']}/.tmux.conf" do
  source '.tmux.conf'
  owner node['user']
  not_if "test -f /home/#{node['user']}/.tmux.conf"
end
