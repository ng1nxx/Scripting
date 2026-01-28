#!/bin/bash
set -e

# =================================================
# STATIC CONFIG
# =================================================
AZP_URL="https://dev.azure.com/bersama-teknologi-unggul"
AGENT_DIR="$HOME/myagent"

# =================================================
# INPUT DINAMIS
# =================================================
read -s -p "Masukkan Azure DevOps PAT (AZP_TOKEN): " AZP_TOKEN
echo ""

read -p "Masukkan Agent Pool [btu-server-dev]: " AZP_POOL
AZP_POOL=${AZP_POOL:-btu-server-dev}

read -p "Masukkan Agent Name [$(hostname)]: " AZP_AGENT_NAME
AZP_AGENT_NAME=${AZP_AGENT_NAME:-$(hostname)}

read -p "Masukkan Agent Version [4.266.2]: " AGENT_VERSION
AGENT_VERSION=${AGENT_VERSION:-4.266.2}

# =================================================
# DERIVED VARIABLES
# =================================================
AGENT_PACKAGE="vsts-agent-linux-x64-$AGENT_VERSION.tar.gz"
DOWNLOAD_URL="https://download.agent.dev.azure.com/agent/$AGENT_VERSION/$AGENT_PACKAGE"

# =================================================
# VALIDATION
# =================================================
if [[ -z "$AZP_TOKEN" ]]; then
  echo "[ERROR] AZP_TOKEN tidak boleh kosong!"
  exit 1
fi

# =================================================
# INFO
# =================================================
echo ""
echo "=============================================="
echo " Azure DevOps Self-Hosted Agent Installer"
echo "=============================================="
echo "URL        : $AZP_URL"
echo "Pool       : $AZP_POOL"
echo "Agent Name : $AZP_AGENT_NAME"
echo "Version    : $AGENT_VERSION"
echo "Directory  : $AGENT_DIR"
echo "=============================================="

# =================================================
# STEP 1: DEPENDENCIES
# =================================================
sudo apt-get update -y
sudo apt-get install -y curl tar jq

# =================================================
# STEP 2: AGENT DIRECTORY
# =================================================
mkdir -p "$AGENT_DIR"
cd "$AGENT_DIR"

# =================================================
# STEP 3: DOWNLOAD
# =================================================
if [[ ! -f "$AGENT_PACKAGE" ]]; then
  echo "[INFO] Mengunduh agent..."
  curl -fSL "$DOWNLOAD_URL" -o "$AGENT_PACKAGE"
fi

# =================================================
# STEP 4: EXTRACT
# =================================================
echo "[INFO] Mengekstrak agent..."
tar zxvf "$AGENT_PACKAGE"

chmod +x ./config.sh

# =================================================
# STEP 5: CONFIGURE (INI YANG MEMBUAT svc.sh)
# =================================================
if [[ ! -f ".agent" ]]; then
  echo "[INFO] Konfigurasi agent..."
  ./config.sh --unattended \
    --url "$AZP_URL" \
    --auth pat \
    --token "$AZP_TOKEN" \
    --pool "$AZP_POOL" \
    --agent "$AZP_AGENT_NAME" \
    --acceptTeeEula \
    --replace
fi

# =================================================
# STEP 6: SERVICE (BARU ADA SETELAH CONFIG)
# =================================================
SVC_SCRIPT="./svc.sh"
[[ -f "./bin/svc.sh" ]] && SVC_SCRIPT="./bin/svc.sh"

chmod +x "$SVC_SCRIPT"

sudo "$SVC_SCRIPT" install
sudo "$SVC_SCRIPT" start

# =================================================
# DONE
# =================================================
echo ""
echo "[SUCCESS] Azure DevOps Agent berhasil terinstal!"
echo "[INFO] Cek status: sudo $SVC_SCRIPT status"
