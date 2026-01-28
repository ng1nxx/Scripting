# Azure DevOps Self-Hosted Agent Installer (Linux)

Repository ini berisi **script Bash** untuk melakukan instalasi **Azure DevOps Self-Hosted Agent** pada server Linux  
(**Ubuntu 20.04 atau kompatibel**) dengan mode **service (systemd)**.

Script ini dibuat agar:

- ✅ Tidak hardcode credential
- ✅ Input dilakukan via CLI
- ✅ Mengikuti behavior agent Azure versi terbaru
- ✅ Aman untuk production

---

## 📋 Prerequisites

Pastikan server memenuhi syarat berikut:

- **OS**: Ubuntu 20.04+
- **User** memiliki akses `sudo`
- **Koneksi internet**
- **Azure DevOps Personal Access Token (PAT)** dengan scope:
  - `Agent Pools (Read & Manage)`

---

## 📁 File

```text

curl -O https://raw.githubusercontent.com/ng1nxx/Scripting/refs/heads/main/Install_azure.sh

sudo chmod +x Install_azure.sh

./Install_azure.sh

```
