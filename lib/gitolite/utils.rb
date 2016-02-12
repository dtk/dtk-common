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
module Gitolite
  module Utils
    def validate_gitolite_conf_file(content)
      # first line that is not empty
      first_line = true

      content.split(/\n|\r/).each_with_index do |line, i|
        next if line.strip().empty?
        next if line.strip().match(/^include/)

        if first_line
          raise_gitolite_error("Gitolite conf repo header is not valid", content) unless line.match(/repo *[a-zA-Z\-0-9]+/)
          first_line = !first_line
          next
        end

        # line must start with R/W/RW+
        raise_gitolite_error("Gitolite conf repo line must start with R/RW/W(+)", content) unless line.match(/^ *(R|W|RW)\+? *=/m)

        # must be matched only once
        raise_gitolite_error("Gitolite conf repo line must containt ONLY one entry of R/RW/W(+)=", content) if line.scan(/(R|W|RW)\+? *=/).size > 1
      end

      return content
    end

    def raise_gitolite_error(msg, content)
      Rails.logger.debug "Gitolite validation failed with: #{msg}"
      Rails.logger.debug content
      raise ::Error::GitoliteValidation.new(msg)
    end

    #
    # Checks to see if array2 is subset of array1
    #
    def is_subset?(array1, array2)
      result = array1 & array2
      (array2.length == result.length)
    end

    #
    # Converts permission to gitolite friendly permission
    # 
    def gitolite_friendly(permission)
      if permission.empty?
        return nil
      elsif permission.match(/^RWDP?/)
        return "RW+"
      elsif permission.match(/^RW/)
        return "RW+"
      elsif permission.match(/^R/)
        return 'R'
      else
        return nil
      end
    end

  end
end