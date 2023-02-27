[![CI](https://github.com/isweluiz/ansible-in-docker-action/actions/workflows/00.docker_build.yml/badge.svg)](https://github.com/isweluiz/ansible-in-docker-action/actions/workflows/00.docker_build.yml)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/isweluiz/ansible-in-docker-action)
![GitHub issues](https://img.shields.io/github/issues/isweluiz/ansible-in-docker-action)

## Table Of content
[About](ansible-in-docker-action)
[Usage](usage)
[Inputs](inputs)
[Inputs](license)
[Copyright](sopyright)

## Ansible In Docker Action
👋 Ahoy there, fellow GitHubber! Are you tired of constantly configuring Ansible for your GitHub Actions workflows? Well, have no fear, the Ansible-in-Docker action is here! 🐳

Say goodbye to the days of configuring Ansible manually - this project is here to make your life easier! With our action, you can easily run Ansible in your GitHub Actions workflows, saving you time and effort. 😎

And the best part? Our project is safe and secure, so you can use it with peace of mind. Plus, you can even fork it and collaborate with me to make it even better. 🤝

So what are you waiting for? Let's make Ansible a breeze with the Ansible-in-Docker action! ⚡️

### Usage
To use this action, you will need to provide the name of the playbook in your workspace as the required input. Other inputs are optional but can be provided to customize the execution of the playbook.

```yaml
name: Run Ansible playbook
on:
  push:
    branches:
      - main
jobs:
  ansible-in-docker:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Run Ansible playbook
        uses: isweluiz/action-ansible-in-docker@v1.0.0
        with:
          playbookName: myplaybook.yml
          inventoryFile: myinventory.yml
          requirementsFile: requirements.yml
          galaxyGithubUser: mygithubusername
          galaxyGithubToken: ${{ secrets.GALAXY_GITHUB_TOKEN }}
          rolesPath: /opt/ansible/roles
          keyFile: mykeyfile.pem
          keyFileVaultPass: ${{ secrets.mykeyfilepassword }} 
          extraVars: '{"foo": "bar", "baz": 42}'
          extraFile: vars.yml
          verbosity: vvv
```

For example, you can specify a custom inventory file, a requirements file to install necessary roles, a custom roles path, a key file to use for host connections, and extra vars to inject into the run. You can also specify the verbosity level of Ansible, choosing from one of four levels.

This action supports private Github repositories in your requirements file by setting the galaxyGithubUser and galaxyGithubToken inputs. Additionally, if you need to use a key file for host connections, you can provide a key file and its vault password.

### Inputs

The action has several input parameters:

| Option            | Description                                                                                                                                |   |
|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------|---|
| playbookName      | Name of the playbook in your workspace.                                                                                                    |   |
| inventoryFile     | Name of the inventory file to use.                                                                                                         |   |
| requirementsFile  | Name of the requirements file to use.                                                                                                      |   |
| galaxyGithubUser  | If you use private GitHub repositories in your requirements file you need to set galaxyGithubUser and galaxyGithubToken.                   |   |
| galaxyGithubToken | Token to access git source of roles to download. Only needed for private git sources. GitHub Account needs to be linked to Ansible Galaxy. |   |
| rolesPath         | If inventoryFile is set, you can also specify a custom roles path to install your required roles in.                                       |   |
| keyFile           | Keyfile to use for host connections.                                                                                                       |   |
| keyFileVaultPass  | Vault Password to decrypt keyFile.                                                                                                         |   |
| extraVars         | String containing all extraVars which you want to be injected into the run.                                                                |   |
| extraFile         | File containing extra vars.                                                                                                                |   |
| verbosity         | Choose one of 4 verbosity levels. See Ansible documentation for details.                                                                   |   |

All of these parameters are optional except playbookName, which is required.
### 🎉🎉🎉 Contributing 🎉🎉🎉
Contributions are welcome! See [Contributor's Guide](.github/CONTRIBUTING.md)

### License
This project is licensed under the MIT License.

### Copyright
(c) 2023, Luiz
