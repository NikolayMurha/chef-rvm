
# rubocop:disable Metrics/BlockLength
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.trigger.before :reload, stdout: true do
    puts "Remove 'synced_folders' file"
    `rm .vagrant/machines/default/virtualbox/synced_folders`
  end
  config.vm.box = 'bento/ubuntu-14.04'
  config.vm.network :private_network, ip: '33.33.33.10'
  config.vm.synced_folder './', '/chef_rvm'
  config.vm.provider :virtualbox do |vb|
    vb.memory = 1024
    vb.cpus = 2
  end
  config.berkshelf.berksfile_path = './Berksfile'
  config.berkshelf.enabled = true
  config.vm.provision :chef_zero do |chef|
    chef.log_level = :info
    chef.nodes_path = '.vagrant/nodes'

    chef.json = {
      :'build-essential' => {
        compile_time: true
      },
      apt: {
        compile_time_update: true
      },
    }
    chef.run_list = %w[
      chef_rvm_example::default
    ]
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_KEY']
    aws.session_token = ENV['AWS_SESSION_TOKEN']
    aws.keypair_name = ENV['AWS_SSH_KEY_ID']
    aws.ami = ENV['AWS_DEFAULT_AMI'] || 'ami-7747d01e'
    aws.region = ENV['AWS_DEFAULT_REGION'] || 'us-east-1'
    override.ssh.username = ENV['AWS_USERNAME'] || 'ubuntu'
    override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY']
    override.vm.box = 'dummy'
  end
end
