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
module DTK::Common; class GritAdapter
  class ObjectAccess  < self 
    def initialize(repo_dir,branch=nil)
      super
      @grit_index = @grit_repo.index
    end

    def read_tree()
      @grit_index.read_tree(@branch)
    end

    def add_or_replace_file(file_path,content)
      @grit_index.add(file_path,content)
    end

    def delete_file(file_path)
      @grit_index.delete(file_path)
    end

    def create_branch(new_branch)
      if branches().include?(new_branch)
        raise Error.new("Branch (#{new_branch}) already exists")
      end
      commit_msg = "adding new branch (#{new_branch})"
      @grit_index.commit(commit_msg,@grit_repo.commits,nil,nil,new_branch)
    end

    def commit(commit_msg)
      @grit_index.commit(commit_msg,@grit_repo.commits,nil,nil,@branch)
      git_command("write-tree".to_sym)
    end

    def commit_context(commit_msg,&block)
      read_tree()
      yield
      commit(commit_msg)
    end
  end
end;end