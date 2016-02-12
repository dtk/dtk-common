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
module DtkCommon; module DSL
  class DirectoryParser
    class Linux < self
      def initialize(directory_type,directory_root)
        super(directory_type)
        @directory_root = directory_root
      end
     private
      def all_files_from_root()
        Dir.chdir(@directory_root) do
          Dir["**/*"]
        end
      end

      def get_content(rel_file_path)
        file_path = "#{@directory_root}/#{rel_file_path}"
        File.open(file_path).read()
      end
    end
  end
end; end