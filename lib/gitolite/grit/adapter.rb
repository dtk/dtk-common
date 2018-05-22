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
require 'grit'

module Gitolite
  module Git
    class Adapter

      DEFAULT_BRANCH = 'master'

      def initialize(repo_dir,branch=DEFAULT_BRANCH)
        @repo_dir = repo_dir
        @branch = branch
        @grit_repo = nil
        begin
          @grit_repo = ::Grit::Repo.new(repo_dir)
         rescue ::Grit::NoSuchPathError
          repo_name = repo_dir.split("/").last.gsub("\.git","")
          #TODO: change to usage error
          raise ::Gitolite::NotFound, "Repo (#{repo_name}) - path '#{repo_dir}' does not exist"
         rescue => e
          raise e
        end
      end

      def branches()
        @grit_repo.branches.map{|h|h.name}
      end

      def ls_r(depth=nil,opts={})
        tree_contents = tree.contents
        ls_r_aux(depth,tree_contents,opts)
      end

      def path_exists?(path)
        not (tree/path).nil?
      end

      def file_content(path)
        tree_or_blob = tree/path
        tree_or_blob && tree_or_blob.kind_of?(::Grit::Blob) && tree_or_blob.data
      end

      def file_content_and_size(path)
        tree_or_blob = tree/path
        return nil unless tree_or_blob
        { :data => tree_or_blob.data, :size => tree_or_blob.size }
      end

      def push()
        Git_command__push_mutex.synchronize do
          git_command(:push,"origin", "#{@branch}:refs/heads/#{@branch}")
        end
      end

      def push_to_mirror_repo(mirror_repo)
        git_command(:push,"--mirror",mirror_repo)
      end

      Git_command__push_mutex = Mutex.new

      def pull()
        git_command(:pull,"origin",@branch)
      end

     private
      def tree()
        @grit_repo.tree(@branch)
      end

      def ls_r_aux(depth,tree_contents,opts={})
        ret = Array.new
        return ret if tree_contents.empty?
        if depth == 1
          ret = tree_contents.map do |tc|
            if opts[:file_only]
              tc.kind_of?(::Grit::Blob) && tc.name
            elsif opts[:directory_only]
              tc.kind_of?(::Grit::Tree) && tc.name
            else
              tc.name
            end
          end.compact
          return ret
        end

        tree_contents.each do |tc|
          if tc.kind_of?(::Grit::Blob)
            unless opts[:directory_only]
              ret << tc.name
            end
          else
            dir_name = tc.name
            ret += ls_r_aux(depth && depth-1,tc.contents).map{|r|"#{dir_name}/#{r}"}
          end
        end
        ret
      end

      def git_command(cmd,*args)
        @grit_repo.git.send(cmd, cmd_opts(),*args)
      end
      def cmd_opts()
        {:raise => true, :timeout => 60}
      end

    end
  end
end