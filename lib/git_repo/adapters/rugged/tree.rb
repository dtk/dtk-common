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
  class GitRepo::Adapter::Rugged
    class Tree < Obj
      def initialize(repo_branch,rugged_tree)
        super(repo_branch)
        @rugged_tree = rugged_tree
      end

      def get_file_content(path)
        if blob = get_blob(path)
          blob.content
        end
      end

      def list_files()
        ret = Array.new
        @rugged_tree.walk_blobs do |root,entry|
          ret << "#{root}#{entry[:name]}"
        end
        ret
      end

     private
      def get_blob(path)
        ret = nil
        dir = ""; file_part = path
        if path =~ /(.+\/)([^\/]+$)/
          dir = $1; file_part = $2
        end
        @rugged_tree.walk_blobs do |root,entry|
          if root == dir and entry[:name] == file_part
            return Blob.new(@repo_branch,entry)
          end
        end
        ret
      end

    end
  end
end