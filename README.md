![GitHub release (latest by date)](https://img.shields.io/github/v/release/isweluiz/ansible-in-docker-action)
![GitHub issues](https://img.shields.io/github/issues/isweluiz/ansible-in-docker-action)

# Ansible In Docker Action
👋 Ahoy there, fellow GitHubber! Are you tired of constantly configuring Ansible for your GitHub Actions workflows? Well, have no fear, the Ansible-in-Docker action is here! 🐳

Say goodbye to the days of configuring Ansible manually - this project is here to make your life easier! With our action, you can easily run Ansible in your GitHub Actions workflows, saving you time and effort. 😎

And the best part? Our project is safe and secure, so you can use it with peace of mind. Plus, you can even fork it and collaborate with me to make it even better. 🤝

So what are you waiting for? Let's make Ansible a breeze with the Ansible-in-Docker action! ⚡️

### Usage
To use this action, you will need to provide the name of the playbook in your workspace as the required input. Other inputs are optional but can be provided to customize the execution of the playbook.

```yaml
- name: Perform ansible playbook
  uses: isweluiz/ansible-in-docker-action@main
  with:
    playbookName: ./test/playbook.yml
    inventoryFile: ./test/inventory.yml
    verbosity: vv
```

For example, you can specify a custom inventory file, a requirements file to install necessary roles, a custom roles path, a key file to use for host connections, and extra vars to inject into the run. You can also specify the verbosity level of Ansible, choosing from one of four levels.

This action supports private Github repositories in your requirements file by setting the galaxyGithubUser and galaxyGithubToken inputs. Additionally, if you need to use a key file for host connections, you can provide a key file and its vault password.


### Inputs

**playbook**
The path to the Ansible playbook to run. This input is required.

**extra-vars**
A string of extra variables to pass to the Ansible playbook. This input is optional.

**requirements-file**
The path to a requirements.txt file containing Ansible dependencies to install. This input is optional.

### 🎉🎉🎉 Contributing 🎉🎉🎉
Contributions are welcome! See [Contributor's Guide](.github/CONTRIBUTING.md)

### License
This project is licensed under the MIT License.

### Copyright
(c) 2023, Luiz
