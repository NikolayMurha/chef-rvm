# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.trigger.before :reload, stdout: true do
    puts "Remove 'synced_folders' file"
    `rm .vagrant/machines/default/virtualbox/synced_folders`
  end
  # config.vm.hostname = "rvm-berkshelf"
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = 'bento/ubuntu-14.04'
  # config.omnibus.chef_version = :latest
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "33.33.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.

  # config.vm.network :public_network

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./", "/chef_rvm"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true
    vb.memory = 1024
    vb.cpus = 2
    # Use VBoxManage to customize the VM. For example to change memory:
    # vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

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
      # chef_rvm: {
      #   # verbose: true,
      #   users: {
      #     ubuntu: {
      #       rubies: {
      #         '1.9.3' => { action: 'install', patch: 'falcon' },
      #         '2.0' => 'install',
      #         'opal' => {},
      #         'jruby' => {},
      #         'rbx' => {},
      #         'mruby' => {},
      #         'opal' => {},
      #       },
      #       gems: {
      #         '1.9.3@eye_unicorn' => %w(eye unicorn),
      #         '1.9.3@eye' => [
      #           { gem: 'eye', version: '0.6', action: 'install' }
      #         ],
      #         '1.9.3@unicorn' => 'unicorn',
      #       },
      #       wrappers: {
      #         :'1.9.3@eye' => {
      #           bootup: [
      #             {
      #               binary: 'eye',
      #               action: 'create_or_update'
      #             }
      #           ]
      #         },
      #         :'1.9.3@eye_unicorn' => {
      #           bootup: %w(eye unicorn)
      #         },
      #         :'1.9.3@unicorn' => {
      #           bootup: 'unicorn'
      #         }
      #       },
      #       aliases: {
      #         'my_alias_200' => '2.0.0',
      #         'my_alias_193' => '1.9.3@eye_unicorn'
      #       }
      #     }
      #   }
      # }
    }

    # java::default
    # maven::default
    # nodejs::default
    # chef_rvm_example::user
    # chef_rvm::default
    chef.run_list = %w(
        chef_rvm_example::default
      )
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_KEY']
    aws.session_token = ENV['AWS_SESSION_TOKEN']
    aws.keypair_name = ENV['AWS_SSH_KEY_ID']
    aws.ami = ENV['AWS_DEFAULT_AMI'] || "ami-7747d01e"
    aws.region = ENV['AWS_DEFAULT_REGION'] || 'us-east-1'
    override.ssh.username = ENV['AWS_USERNAME'] || 'ubuntu'
    override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY']
    override.vm.box = "dummy"
  end
end
