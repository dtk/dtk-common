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
module DTK::Common; class GritAdapter; class FileAccess
  module StatusMixin
    def status()
      chdir_and_checkout do
        Status.new(@grit_repo.status)
      end
    end

    class Status < Hash
      def initialize(grit_status_obj)
        super()
        FileStates.each do |file_state|
          paths_with_file_state = grit_status_obj.send(file_state).map{|info|info[1].path} 
          self[file_state] = paths_with_file_state unless paths_with_file_state.empty?
        end
      end
      
      def any_changes?()
        !!FileStates.find{|fs|self[fs]}
      end
      
      FileStates = [:added,:deleted,:changed,:untracked]
    end
  end                                         
end; end; end