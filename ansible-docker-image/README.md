## Ansible Docker Image 

This Docker image contains Ansible installed, along with some dependencies and tools commonly used in Ansible playbooks.

## How to Use
To use this image, you can start a container based on it and run your Ansible playbooks inside:

```
docker run --rm -it -v /path/to/your/ansible/files:/ansible isweluiz/ansible-docker ansible-playbook /ansible/playbook.yml
```

