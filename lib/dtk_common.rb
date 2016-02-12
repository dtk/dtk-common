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

    # we are refering to dtk-common-repo folder here
    POSSIBLE_COMMON_CORE_FOLDERS = ['dtk-common-repo','dtk-common-core']

    require File.expand_path('require_first.rb', File.dirname(__FILE__))

    # this gem needs dtk-common-repo to work we load it
    unless is_gem_installed?('dtk-common-core')
      dtk_common_core_folder = POSSIBLE_COMMON_CORE_FOLDERS.find do |folder|
        path = File.join(File.dirname(__FILE__),'..','..',folder)
        File.directory?(path)
      end

      if dtk_common_core_folder
        require File.expand_path("../../#{dtk_common_core_folder}/lib/dtk_common_core.rb", File.dirname(__FILE__))
      else
        raise "Not able to find 'dtk-common-core' gem!"
      end
    else
      # gem installed load from here
      require 'dtk_common_core'
    end


    # we use sorting to establish deterministic behavior accross systems
    # Dir.glob will not return list of files in same order each time is run, which led to some bug being present
    # on some systems and not on the others
    file_list = Dir.glob("#{File.dirname(__FILE__)}/**/*.rb").sort { |a,b| a <=> b }

    file_list.each do |file|
      require file unless file.include?('dtk-common.rb') || file.include?('file_access/') || file.include?('require_first.rb') || file.include?('postgres.rb') || file.include?('rugged/')
    end
  end
end