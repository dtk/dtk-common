#
# Copyright (C) 2010-2016 dtk contributors
#
# This file is part of the dtk project.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require File.expand_path('common_patch',File.dirname(__FILE__))
require File.expand_path('dynamic_loader',File.dirname(__FILE__))
#TODO: this will eventually replace the grit_adapter classes
module DtkCommon
  class GitRepo
    class Adapter 
    end

    def initialize(repo_path)
      @repo_path = repo_path
      @adapters = Hash.new
    end

    class Branch < self
      def initialize(repo_path,branch='master')
        super(repo_path)
        @branch = branch
      end
      private
       def adapter_initialize_args()
         [@repo_path,@branch]
       end
    end

    def method_missing(method_name,*args,&block)
      if adapter_name = self.class.find_adapter_name(method_name)
        
        adapter = (@adapters[adapter_name] ||= Hash.new)[branch_index()] ||= self.class.load_and_return_adapter_class(adapter_name).new(*adapter_initialize_args())
        execution_wrapper do
          adapter.send(method_name,*args,&block)
        end
      else
        super
      end
    end

    def respond_to?(method_name)
      super(method_name) or self.class.find_adapter_name(method_name)
    end

    def self.implements_method?(method_name)
      !!find_adapter_name(method_name)
    end

   private
    def adapter_initialize_args()
      [@repo_path]
    end

    def branch_index()
      @branch||"---NONE"
    end

    def execution_wrapper(&block)
      begin
        yield
       rescue => e 
        Log.error(([e.to_s]+e.backtrace).join("\n"))
        error = (e.kind_of?(::DtkCommon::Error) ? e : ::DtkCommon::Error.new(e.to_s))
        raise error
      end
    end

    def self.load_and_return_adapter_class(adapter_name)
      (@adapter_classes ||= Hash.new)[adapter_name] ||= DynmamicLoader.load_and_return_adapter_class(:git_repo,adapter_name,:base_class => Adapter)
    end

    def self.find_adapter_name(method_name)
      @adapter_names ||= Hash.new
      return @adapter_names[method_name] if @adapter_names.has_key?(method_name)
      ret = Array(AdaptersForMethods[method_name]||[]).find do |adapter_name|
        condition = AdapterConditions[adapter_name]
        condition.nil? or condition.call()
      end
      @adapter_names[method_name] = ret 
    end

    #for each hash value form is scalar or array of adapters to try in order
    AdaptersForMethods = {
      :get_file_content => :rugged,
      :list_files => :rugged
    }

    AdapterConditions = {
#      TODO: too restrictive; wil delete
#      :rugged => proc{!::Gem::Specification::find_all_by_name('rugged',::Gem::Requirement.new(NailedRuggedVersion)).empty?}
    }
  end
end