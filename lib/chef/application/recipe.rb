#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Author:: Daniel DeLeo (<dan@kallistec.com>)
# Copyright:: Copyright (c) 2012 Bryan W. Berry
# Copyright:: Copyright (c) 2012 Daniel DeLeo
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef'
require 'chef/application'
require 'chef/client'
require 'chef/config'
require 'chef/log'
require 'fileutils'
require 'chef/providers'
require 'chef/resources'

class Chef::Application::Recipe < Chef::Application

  banner "Usage: chef-recipe RECIPE_FILE"

  option :stdin,
  :short        => "-",
  :long         => "-",
  :description  => "Receive recipe input from STDIN",
  :on           => :tail,
  :boolean      => true,
  :show_options => true,
  :default => false,
  :exit         => 0

  
  option :log_level,
    :short        => "-l LEVEL",
    :long         => "--log_level LEVEL",
    :description  => "Set the log level (debug, info, warn, error, fatal)",
    :proc         => lambda { |l| l.to_sym }

  option :help,
    :short        => "-h",
    :long         => "--help",
    :description  => "Show this message",
    :on           => :tail,
    :boolean      => true,
    :show_options => true,
    :exit         => 0

  
  option :version,
    :short        => "-v",
    :long         => "--version",
    :description  => "Show chef version",
    :boolean      => true,
    :proc         => lambda {|v| puts "Chef: #{::Chef::VERSION}"},
    :exit         => 0

  option :why_run,
    :short        => '-W',
    :long         => '--why-run',
    :description  => 'Enable whyrun mode',
    :boolean      => true

  def initialize
    super
  end

  def reconfigure
    configure_logging
  end

  
  class Chef::Client
    attr_reader :events
  end
  
  def find_recipe(recipe_path)
    if recipe_path.nil?
      STDERR.puts banner
      exit 1
    elsif !::File.exist?(recipe_path)
      STDERR.puts "No file at #{recipe_path}"
      STDERR.puts banner
      exit 1
    end
    recipe_path = File.expand_path(recipe_path)
  end
  
  def run_chef_recipe
    recipe_path = ARGV[0]
    unless Chef::Config[:stdin]
      recipe_path = find_recipe recipe_path
    end
    
    Chef::Config[:solo] = true
    client = Chef::Client.new
    client.run_ohai
    client.load_node
    client.build_node
    run_context = if client.events.nil?
                    Chef::RunContext.new(client.node, {})
                  else
                    Chef::RunContext.new(client.node, {}, client.events)
                  end
    
    recipe = Chef::Recipe.new("(chef-recipe cookbook)", "(chef-recipe recipe)", run_context)

    unless Chef::Config[:stdin]
      recipe.from_file(recipe_path)
    else
      recipe.instance_eval(ARGF.read)
    end
      
    runner = Chef::Runner.new(run_context)
    runner.converge
  end

  def run_application
    begin
      run_chef_recipe
      Chef::Application.exit! "Exiting", 0
    rescue SystemExit => e
      raise
    rescue Exception => e
      Chef::Application.debug_stacktrace(e)
      Chef::Application.fatal!("#{e.class}: #{e.message}", 1)
     end
  end

    # Get this party started
  def run
    reconfigure
    run_application
  end
  
end
