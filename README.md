# ❔ About

This github-action is based on the tool [`Yamlfixer`](https://github.com/opt-nc/yamlfixer) : 

- Developed by [`@tamere-allo-peter`](https://github.com/tamere-allo-peter)
- Integrated as a Github Action by [`@mbarre`](https://github.com/mbarre)

It **automatically fixes** some errors and warnings reported by `yamllint` and creates **a pull request that embeds the fixes**.

## 🧰 Usage

See [action.yml](action.yml)

You need a Github account that is allowed to create pull request on the inspected repository.

Find below an example that allows to check `yaml` files **on each push** with verbose mode :

```yaml
name: Lint yaml files

on: [push]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout my app
        uses: actions/checkout@v3
      - name: Lint yaml files
        uses: opt-nc/yamlfixer-action
        with:
            options: --summary
            user: ${{secrets.my_user}}
            token: ${{secrets.my_user_password}}
```

The github-action creates :

1. A new branch named `yamlfixer/patch/$branch_name`
2. The pull request to be merged into the working branch

# 🔖 Resources

Here are some useful resources : 

- 📖 [Why and how this Gh Action has been developed](https://dev.to/adriens/let-ci-check-fix-your-yamls-kfa) : 2' read
- 🎦 [Video demo of a whole usecase](https://youtu.be/GuloRWeTavY) : 7' read

## 📖 Licensing information

```
Copyright (C) 2021 OPT-NC

This program is free software: you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program. If not, see https://www.gnu.org/licenses/.
```
