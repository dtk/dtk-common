dtk-common
==========

What it is?
----------------------
This is helper library used across DTK components (dtk-server, dtk-repo-manager). Since it is included as dependency on DTK components, there is no need for installing/configuring it separately. We use [Gitolite](https://github.com/sitaramc/gitolite) for fine-grained access control to our component and service modules. One of the functionalities that dtk-common exposes is interaction with Gitolite via Gitolite Manager. Below is an example why and how Gitolite manager is used.

Gitolite manager usage
----------------------
Manager takes responsibility of handling all gitolite methods (or at least most of them). Reason is simple, gitolite commit / push are expensive operations and we want to mitigate that fact by using manager, and making sure that all our changes are under one commit / push.

Example: Adding user/user group/all to repo configuration

    manager = Gitolite::Manager.new('/home/git/gitolite-admin')

    repo_conf = manager.open_repo('r8--cm--java')
    repo_conf.add_username_with_rights(
      'dtk-instance-dtk9', 
      'RW+'
    )

    repo_conf.add_user_group_with_rights(
      'tenants', 
      'R'
    )

    repo_conf.add_all_with_rights(
      gitolite_friendly('RW')
    )

    manager.push()


## License

dtk-common is copyright (C) 2010-2016 dtk contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this work except in compliance with the License.
You may obtain a copy of the License in the [LICENSE](LICENSE) file, or at:

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
