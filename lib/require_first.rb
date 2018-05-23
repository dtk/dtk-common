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
module DTK
  module Common
    def self.r8_require_common(path)
      require File.expand_path(path, File.dirname(__FILE__))
    end

    def self.is_gem_installed?(gem_name)
      begin
        # if no exception gem is found
        gem gem_name
        return true
      rescue Gem::LoadError
        return false
      end
    end
  end
end
