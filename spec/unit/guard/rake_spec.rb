require 'spec_helper'
require 'guard/rake'

describe "Guard::Rake" do
	let(:rake) do
	Guard::Rake.new
	end

	describe "start" do
		before(:each) do
		  @shellout = double('shellout')
		  @shellout.stub(:live_stream=).with(STDOUT)
		  @shellout.stub(:run_command)
		  @shellout.stub(:error!)
		  Guard::UI.stub(:info).with('Guard::Rake::Vagrant box is starting')
		  Guard::UI.stub(:info).with('Starting guard-rake-vagrant')
		  Mixlib::ShellOut.stub(:new).with("vagrant up").and_return(@shellout)
		end

		it "runs vagrant up" do
		  Mixlib::ShellOut.should_receive(:new).with("vagrant up").and_return(@shellout)
		  Guard::UI.should_receive(:info).with('Guard::Rake::Vagrant box is starting')
		  Guard::Notifier.should_receive(:notify).with('Vagrant box created', :title => 'guard-rake-vagrant', :image => :success)
		  rake.start
		end

		it "notifies on failure" do
		  @shellout.should_receive(:error!).and_raise(Mixlib::ShellOut::ShellCommandFailed)
		  Guard::UI.should_receive(:info).with('Guard::Rake::Vagrant box is starting')
		  Guard::Notifier.should_receive(:notify).with('Vagrant box create failed', :title => 'guard-rake-vagrant', :image => :failed)
		  Guard::UI.should_receive(:info).with('Vagrant box failed with Mixlib::ShellOut::ShellCommandFailed')
		  expect { rake.start }.to throw_symbol(:task_has_failed)
		end
	end
	describe "reload" do
		it "calls stop and start" do
			rake.should_receive(:stop)
			rake.should_receive(:start)
			rake.reload
		end
	end

	describe "stop" do
		before(:each) do
		  @shellout = double('shellout')
		  @shellout.stub(:live_stream=).with(STDOUT)
		  @shellout.stub(:run_command)
		  @shellout.stub(:error!)
		  Guard::UI.stub(:info).with('Guard::Rake::Vagrant box is stopping')
		  Guard::UI.stub(:info).with('Stopping guard-rake-vagrant')
		  Mixlib::ShellOut.stub(:new).with("vagrant destroy -f").and_return(@shellout)
		end
		it "runs vagrant destroy -f" do
		  Mixlib::ShellOut.should_receive(:new).with("vagrant destroy -f").and_return(@shellout)
		  Guard::UI.should_receive(:info).with('Guard::Rake::Vagrant box is stopping')
		  Guard::Notifier.should_receive(:notify).with('Vagrant box destroyed', :title => 'guard-rake-vagrant', :image => :success)
		  rake.stop
		end

		it "notifies on failure" do
		  @shellout.should_receive(:error!).and_raise(Mixlib::ShellOut::ShellCommandFailed)
		  Guard::UI.should_receive(:info).with('Guard::Rake::Vagrant box is stopping')
		  Guard::Notifier.should_receive(:notify).with('Vagrant box destroy failed', :title => 'guard-rake-vagrant', :image => :failed)
		  Guard::UI.should_receive(:info).with('Vagrant box failed with Mixlib::ShellOut::ShellCommandFailed')
		  expect { rake.stop }.to throw_symbol(:task_has_failed)
		end
	end
end