[![CI](https://github.com/isweluiz/ansible-in-docker-action/actions/workflows/00.docker_build.yml/badge.svg)](https://github.com/isweluiz/ansible-in-docker-action/actions/workflows/00.docker_build.yml)
[![CI - test](https://github.com/isweluiz/ansible-in-docker-action/actions/workflows/00.action_test.yml/badge.svg?branch=main)](https://github.com/isweluiz/ansible-in-docker-action/actions/workflows/00.action_test.yml)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/isweluiz/ansible-in-docker-action)
![GitHub issues](https://img.shields.io/github/issues/isweluiz/ansible-in-docker-action)

## Table Of content
- [About](ansible-in-docker-action)
- [Usage](usage)
- [Inputs](inputs)
- [Inputs](license)
- [Copyright](sopyright)


## Ansible In Docker Action
Hello there, Are you tired of constantly configuring Ansible for your GitHub Actions workflows? Well, have no fear, the Ansible-in-Docker action is here!

Say goodbye to the days of configuring Ansible manually - this project is here to make your life easier! With this action, you can easily run Ansible in your GitHub Actions workflows, saving you time and effort.

### We Are using the Below requirements dependencies

| Using        	| Version 	|
|--------------	|---------	|
| Ansible      	| >2.14   	|
| Docker       	| >4.4.3  	|
| Jinja2       	| < 3.1    	|
| ansible-lint 	|         	|
| Pysocks      	|         	|
| botocore     	|         	|
| boto         	|         	|
| boto3        	|         	|


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

| Options           | Description                                                                                                                                | Mandatory | Default value | Type    |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | --------- | ------------- | ------- |
| playbook          | Name of the playbook in your workspace.                                                                                                    | True      | None          | File    |
| inventory         | Name of the inventory file to use `--inventory`.                                                                                           | False     | localhost     | File    |
| limitGroup        | Further limit selected hosts to an additional pattern `--limit`.                                                                           | False     | None          | String  |
| user              | User account to make the connection happens `--user`.                                                                                      | False     | None          | String  |
| diffMode          | Ansible provides before-and-after comparisons `--diff`.                                                                                    | False     | False         | Boolean |
| checkMode         | Ansible runs in simulate mode - only dry-run `--check`.                                                                                    | False     | False         | Boolean |
| requirementsFile  | Name of the requirements file to use.                                                                                                      | False     | None          | File    |
| galaxyGithubUser  | If you use private GitHub repositories in your requirements file you need to set galaxyGithubUser and galaxyGithubToken.                   | False     | None          | String  |
| galaxyGithubToken | Token to access git source of roles to download. Only needed for private git sources. GitHub Account needs to be linked to Ansible Galaxy. | False     | None          | String  |
| rolesPath         | If inventoryFile is set, you can also specify a custom roles path to install your required roles in.                                       | False     | None          | File    |
| keyFile           | Keyfile to use for host connections `--key-file`.                                                                                          | False     | None          | File    |
| keyFileVaultPass  | Vault Password to decrypt keyFile `--vault-password-file`.                                                                                 | False     | None          | File    |
| extraVars         | String containing all extraVars which you want to be injected into the run `-e`.                                                           | False     | None          | String  |
| extraFile         | File containing extra vars `--extra-vars @file`.                                                                                           | False     | None          | String  |
| verbosity         | Choose one of 4 verbosity levels. See Ansible documentation for details `-vv`.                                                             | False     | v             | String  |
| becomeMethod      | run operations with become (does not imply password prompting) `--become`.                                                                 | False     | False         | Boolean |
| tags              | Select the tags you wanna run, same as `--tags`                                                                                            | False     | None          | String  |
| skipTags          | Select the tags you wanna skip, same as `--skip-tags`                                                                                      | False     | None          | String  |

### Usage
To use this action, you will need to provide the name of the playbook in your workspace as the required input. Other inputs are optional but can be provided to customize the execution of the playbook.


```yaml
name: Ansible Deployment
on:
  push:
    branches:
      - main
jobs:
  ansible-in-docker:
    runs-on: 
      - self-hosted
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Run Ansible playbook
        uses: isweluiz/ansible-in-docker-action@main
        with:
          playbook: myplaybook.yml
          inventory: myinventory.yml
          user: ${{ secrets.ANSIBLE_SVC_USER }} 
          diffMode: true
          checkMode: false
          requirementsFile: requirements.yml
          galaxyGithubUser: mygithubusername
          galaxyGithubToken: ${{ secrets.GALAXY_GITHUB_TOKEN }}
          rolesPath: operation/ansible/roles
          keyFile: mykeyfile.pem
          keyFileVaultPass: ${{ secrets.mykeyfilepassword }} 
          extraVars: 'ansible_sudo_pass=${{ secrets.ANSIBLE_SVC_USER_PASS }} version=${{ env.TARGET_EVENT }}${{ env.TARGET_RELEASE }}'
          extraFile: vars.yml
          verbosity: vv
```

Running an Ansible deploy playbook in check mode using values from input values that come from `workflow_dispatch`.
```yaml
---
name: Deployment
on: 
  workflow_dispatch:
    inputs:

      selectedEnvironment:
        description: "Environment:"
        required: True
        default: "dev"
        type: choice
        options:
          - dev
          - stage
      
      selectedRelease:
        description: "Release:"
        required: True

defaults:
  run:
    shell: bash
    working-directory: ./ansible


jobs:
  DeployStaging:
    name: Deploy to Dev 
    if: ${{ github.event.inputs.selectedEnvironment == 'dev' }}
    runs-on: 
      - self-hosted
    environment:
      name: Dev

    steps:
      - name: Checkout the repo
        uses: actions/checkout@v3
        with:
          fetch-depth: 0 

      - name: Regotry Login
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ env.REGISTRY_USER }}
          password: ${{ env.REGISTRY_PW }}

      - name: Run Ansible playbook
        uses: isweluiz/ansible-in-docker-action@main
        with:
          playbook: playbooks/deploy.yml
          inventory: inventory/${{ github.event.inputs.selectedEnvironment }}
          limitgroup: ${{ github.event.inputs.selectedEnvironment }}
          user: ${{ secrets.ANSIBLE_SVC_USER }}
          diffMode: 'true'
          checkMode: 'true'
          extraVars: 'ansible_sudo_pass=${{ secrets.ANSIBLE_SVC_USER_PASS }}'
          verbosity: vv
          tags: 'deploy'
```

For example, you can specify a custom inventory file, a requirements file to install necessary roles, a custom roles path, a key file to use for host connections, and extra vars to inject into the run. You can also specify the verbosity level of Ansible, choosing from one of four levels. Additionally, if you need to use a key file for host connections, you can provide a key file and its vault password.


All of these parameters are optional except playbookName, which is required. For more information about ansible options just go on the [official documentation](https://docs.ansible.com/ansible/latest/cli/ansible.html).


All of these parameters are optional except playbookName, which is required.

### Contributing
Contributions are welcome! See [Contributor's Guide](.github/CONTRIBUTING.md)

### License
This project is licensed under the MIT License.

### Copyright
(c) 2023, Luiz
