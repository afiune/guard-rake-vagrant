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
						::Guard::UI.info("Vagrant box failed with #{e.to_s}")
						throw :task_has_failed
					end
				end

				def destroy
					::Guard::UI.info("Guard::Rake::Vagrant is stopping")
					cmd = Mixlib::ShellOut.new("vagrant destroy -f")
					cmd.live_stream = STDOUT
					cmd.run_command
					begin
						cmd.error!
					rescue Mixlib::ShellOut::ShellCommandFailed => e
						::Guard::UI.info("Vagrant BOX failed #{e.to_s}")
						throw :task_has_failed
					ensure
						# Sometimes, we leave the occasional shell process unreaped!
						Process.waitall
					end
				end

				def provision
					# Box is running?
					UI.info "Guard::Vagrant provision"
					cmd = Mixlib::ShellOut.new("vagrant provision", :timeout => 10800)
					cmd.live_stream = STDOUT
					cmd.run_command

					begin
						cmd.error!
						Notifier.notify('Vagrant provisioned', :title => 'guard-vagrant', :image => :success)
					rescue Mixlib::ShellOut::ShellCommandFailed => e
						Notifier.notify('Vagrant provision failed', :title => 'guard-vagrant', :image => :failed)
						::Guard::UI.info("Vagrant provision failed with #{e.to_s}")
						throw :task_has_failed
					end
				end
			end
		end
	end
end