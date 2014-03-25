require 'guard'
require 'guard/guard'
require "mixlib/shellout"

module Guard
	class Rake
		class Vagrant 
			class << self
				def up
					UI.info "Guard::Rake::Vagrant box is starting"
					cmd = Mixlib::ShellOut.new("vagrant up", :timeout => 10800)
					cmd.live_stream = STDOUT
					cmd.run_command

					begin
						cmd.error!
						Notifier.notify('Vagrant box created', :title => 'guard-rake-vagrant', :image => :success)
					rescue Mixlib::ShellOut::ShellCommandFailed => e
						Notifier.notify('Vagrant box create failed', :title => 'guard-rake-vagrant', :image => :failed)
						UI.info("Vagrant box failed with #{e.to_s}")
						throw :task_has_failed
					end
				end

				def destroy
					UI.info("Guard::Rake::Vagrant box is stopping")
					cmd = Mixlib::ShellOut.new("vagrant destroy -f", :timeout => 300)
					cmd.live_stream = STDOUT
					cmd.run_command

					begin
						cmd.error!
						Notifier.notify('Vagrant box destroyed', :title => 'guard-rake-vagrant', :image => :success)
					rescue Mixlib::ShellOut::ShellCommandFailed => e
						Notifier.notify('Vagrant box destroy failed', :title => 'guard-rake-vagrant', :image => :failed)
						UI.info("Vagrant box failed #{e.to_s}")
						throw :task_has_failed
					end
				end

				def provision
					UI.info "Guard::Rake::Vagrant box is provisioning"
					cmd = Mixlib::ShellOut.new("vagrant provision", :timeout => 10800)
					cmd.live_stream = STDOUT
					cmd.run_command

					begin
						cmd.error!
						Notifier.notify('Vagrant box provisioned', :title => 'guard-vagrant', :image => :success)
					rescue Mixlib::ShellOut::ShellCommandFailed => e
						Notifier.notify('Vagrant box provision failed', :title => 'guard-vagrant', :image => :failed)
						UI.info("Vagrant box provision failed with #{e.to_s}")
						throw :task_has_failed
					end

					if cmd.stdout =~ /VM is not currently running/
						UI.info "Guard::Rake::Vagrant box is not running"
						self.up
					end
				end
			end
		end
	end
end