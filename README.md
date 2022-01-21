# yamlfixer-action

This github-action is based on the tool [Yamlfixer](https://github.com/opt-nc/yamlfixer) developed by @tamere-allo-peter.
It automatically fixes some errors and warnings reported by yamllint and create a pull request with fixes.

## Usage

See [action.yml](action.yml)

You need a Github account that is allowed to create pull request on the inspected repository.

Here an example, that allow to check yaml files on each push with verbose mode :

```yaml
name: Lint yaml files

on: [push]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout my app
        uses: actions/checkout@v2
      - name: Lint yaml files
        uses: opt-nc/yamlfixer-action
        with:
            yaml_file: .github/*.yml
            options: --verbose
            user: ${{secrets.my_user}}
            token: ${{secrets.my_user_password}}
```

The github-action creates a new branch named **yamlfixer/patch/$branch_name/$current_timestamp** and the pull request to be merged into the working branch.

## Licensing information

Copyright (C) 2021 OPT-NC

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
