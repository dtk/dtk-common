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
require 'thread'

module DtkCommon
  class DynmamicLoader
    def self.load_and_return_adapter_class(adapter_type,adapter_name,opts={})
      begin
        caller_dir = caller.first.gsub(/\/[^\/]+$/,"")
        Lock.synchronize{nested_require_with_caller_dir(caller_dir,"#{adapter_type}/adapters",adapter_name)}
      rescue LoadError
        raise Error.new("cannot find #{adapter_type} adapter (#{adapter_name})")
      end
      base_class = opts[:base_class] || DtkCommon.const_get(camel_case(adapter_type))
      base_class.const_get(camel_case(adapter_name))
    end

   private
    Lock = Mutex.new
    def self.nested_require_with_caller_dir(caller_dir,dir,*files_x)
      files = (files_x.first.kind_of?(Array) ? files_x.first : files_x) 
      files.each{|f|require File.expand_path("#{dir}/#{f}",caller_dir)}
    end
    def self.camel_case(x)
      Aux.snake_to_camel_case(x.to_s)
    end
  end
end