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
    class Branch
      attr_reader :rugged_repo,:branch
      def initialize(rugged_repo,branch)
        @rugged_repo = rugged_repo
        @branch = branch
      end
    end

    module CommonMixin
     private
      def branch()
        @repo_branch.branch()
      end
      def rugged_repo()
        @repo_branch.rugged_repo()
      end

      def lookup(sha)
        rugged_repo().lookup(sha)
      end
    end

    class Obj
      include CommonMixin

      def initialize(repo_branch)
        @repo_branch = repo_branch
      end
    end
  end
end