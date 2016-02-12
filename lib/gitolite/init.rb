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
# use to require all needed files needed for running dtk-common gitolite lib
require 'grit'; require 'erubis'

Grit.debug = false

require File.expand_path('manager.rb', File.dirname(__FILE__))
require File.expand_path('configuration.rb', File.dirname(__FILE__))
require File.expand_path('errors.rb', File.dirname(__FILE__))

require File.expand_path('grit/adapter.rb', File.dirname(__FILE__))
require File.expand_path('grit/file_access.rb', File.dirname(__FILE__))

require File.expand_path('utils.rb', File.dirname(__FILE__))
require File.expand_path('repo.rb', File.dirname(__FILE__))
require File.expand_path('user_group.rb', File.dirname(__FILE__))