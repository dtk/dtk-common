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

module DtkCommon
  module DSL    

    #TODO: just putting in hooks for errors and logs
    #need to figure out how to hook calling library's errors
    Error = ::DTK::Error
    ErrorUsage = ::DTK::ErrorUsage

    Log = ::DTK::Log
    SimpleHashObject = ::DTK::Common::SimpleHashObject
    module Aux
      extend ::DTK::Common::AuxMixin
    end

    require File.expand_path('dsl/directory_parser', File.dirname(__FILE__))
    require File.expand_path('dsl/file_parser', File.dirname(__FILE__))
  end
end