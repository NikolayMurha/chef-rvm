user 'ubuntu' do
  manage_home true
  comment 'Ubuntu User'
  home '/home/ubuntu'
  shell '/bin/bash'
end
