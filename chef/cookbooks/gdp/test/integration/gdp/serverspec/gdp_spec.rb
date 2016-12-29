require 'spec_helper'

expected_packages    = %w(git curl unzip docker-engine jq vim )

expected_binaries    = %w(docker docker-compose )

expected_services    = [ 'docker' ]

expected_proccesses  = { }

expected_ports       = [ 9000 ]

expected_directories = [ '/home/vagrant/rvi_sota_server' ]

expected_files       = { '/home/vagrant/rvi_sota_server/deploy/docker-compose/docker-compose.yml' => '' }

expected_users       = [ ]

expected_commands    = { "docker version" => "1.12.3" }

expected_packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

expected_binaries.each do |b|
  describe file(`which #{b}`) do
    it { should be_executable.by_user('root') }
  end
end

expected_directories.each do |d|
  describe file(d) do
    it { should be_directory }
  end
end

expected_files.each do |f, strings|
  describe file(f) do
    it { should be_file }
    it { should be_readable }

    unless strings.empty?
      strings.each do |s|
        its(:content) { should match(/#{s}/) }
      end
    end
  end
end

expected_services.each do |srv|
  describe service(srv) do
    it { should be_enabled }
    it { should be_running }
  end
end

expected_proccesses.each do |p, owner|
  unless owner.empty?
    describe command("ps -u #{owner}") do
      its(:stdout) { should match(/#{p}/) }
    end
  end
end

expected_ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

expected_users.each do |user|
  describe user(user[:name]) do
    it { should exist }
    it { should have_home_directory user[:home_directory] }
    it { should have_login_shell user[:login_shell] }

    unless user[:groups].empty?
      user[:groups].each do |group|
        it { should belong_to_group group }
      end
    end
  end
end

expected_commands.each do |cmd, output|
  describe command(cmd) do
    its(:stdout) { should match(/#{output}/) }
  end
end
