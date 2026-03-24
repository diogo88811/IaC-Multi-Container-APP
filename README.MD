# Multi-Container TODO Application Deployment with Ansible

This project demonstrates a full DevOps pipeline to deploy a multi-container architecture (Node.js, MongoDB, and Mongo-Express) onto a simulated Alpine Linux server environment using **Ansible** and **Docker Compose**.

## 🏗 Architecture
The application is composed of three interconnected services managed by Docker:
- **API**: A Node.js backend that handles business logic and DB connection.
- **Database**: A MongoDB instance for data persistence.
- **Admin UI**: Mongo-Express, a web-based interface to manage the database.

---

## 🚀 Deployment Workflow

### 1. Environment Provisioning
The **Ansible Playbook** automates the heavy lifting on the target server:
* **Bootstrap**: Installs Python3 and required dependencies on Alpine Linux.
* **Engine**: Installs Docker and Docker Compose.
* **Storage Fix**: Configures the Docker daemon to use the `vfs` storage driver (required for nested container/DinD environments).
* **Directory Setup**: Creates the application workspace with proper permissions.

### 2. Code Synchronization
Instead of just sending the Compose file, the playbook syncs the entire project directory:
* Uses the Ansible `copy` or `unarchive` module to move source code and the `Dockerfile`.
* Automatically excludes `node_modules` and `.git` to optimize transfer speed. (Next steps)

### 3. Orchestration
The final step triggers `docker-compose up -d --build`, which:
* Builds the API image from the local `Dockerfile` on the server.
* Pulls official images for Mongo and Mongo-Express.
* Networks the containers together for seamless communication.

---

## 🛠 Prerequisites
- **Local machine**: Ansible installed.
- **Target server**: SSH access enabled.
- **Docker**: Docker Desktop (if running the "server" as a local container).

## 📖 How to Run

1. **Configure Inventory**: Update your `inventory.ini` with the server IP and user.

2. **Execute Playbook**:
```bash
ssh-keygen -R "[127.0.0.1]:2222"

ANSIBLE_HOST_KEY_CHECKING=False \
ANSIBLE_SSH_CONTROL_PATH_DIR=/tmp/ansible-cp \
ansible-playbook -i inventory.ini setup-docker.yml -K
```