#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Tech Skills Hub – Full-Stack Development Environment Setup
# Target: macOS & Linux (Debian/Ubuntu, Fedora)
# Usage:  chmod +x setup-dev-env.sh && ./setup-dev-env.sh
# ============================================================================

SCRIPT_VERSION="1.0.0"
LOG_FILE="setup-$(date +%Y%m%d-%H%M%S).log"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log()   { echo -e "${GREEN}[✓]${NC} $*" | tee -a "$LOG_FILE"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*" | tee -a "$LOG_FILE"; }
error() { echo -e "${RED}[✗]${NC} $*" | tee -a "$LOG_FILE"; }
info()  { echo -e "${BLUE}[i]${NC} $*" | tee -a "$LOG_FILE"; }

# --- Detect OS ---
detect_os() {
    case "$(uname -s)" in
        Darwin*)  echo "macos" ;;
        Linux*)   echo "linux" ;;
        *)        echo "unsupported" ;;
    esac
}

OS=$(detect_os)
if [[ "$OS" == "unsupported" ]]; then
    error "Unsupported OS. This script supports macOS and Linux."
    exit 1
fi
info "Detected OS: $OS"

# --- Helper: Install packages ---
install_pkg() {
    local pkg=$1
    if [[ "$OS" == "macos" ]]; then
        if ! command -v brew &>/dev/null; then
            info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install "$pkg"
    elif [[ "$OS" == "linux" ]]; then
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y "$pkg"
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y "$pkg"
        else
            warn "No apt/dnf found. Please install $pkg manually."
        fi
    fi
}

# =============================================================
# STEP 1: System-level dependencies
# =============================================================
info "=== Step 1: System Dependencies ==="
for dep in curl wget git; do
    if ! command -v "$dep" &>/dev/null; then
        install_pkg "$dep"
        log "Installed $dep"
    else
        log "$dep already installed"
    fi
done

# =============================================================
# STEP 2: Node.js via nvm (recommended)
# =============================================================
info "=== Step 2: Node.js & npm ==="
if ! command -v nvm &>/dev/null && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    # Source nvm immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    log "nvm installed"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v node &>/dev/null; then
    info "Installing Node.js LTS..."
    nvm install --lts
    nvm alias default 'lts/*'
    log "Node.js $(node --version) installed"
else
    log "Node.js $(node --version) already installed"
fi

npm install -g npm@latest
log "npm $(npm --version) ready"

# =============================================================
# STEP 3: Git Configuration
# =============================================================
info "=== Step 3: Git Configuration ==="
if [ -z "$(git config --global user.name)" ]; then
    warn "Git user.name not set. Please enter your name:"
    read -r GIT_NAME
    git config --global user.name "$GIT_NAME"
    log "Git user.name set to $GIT_NAME"
fi

if [ -z "$(git config --global user.email)" ]; then
    warn "Git user.email not set. Please enter your email:"
    read -r GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
    log "Git user.email set to $GIT_EMAIL"
fi

git config --global init.defaultBranch main
log "Git configured"

# =============================================================
# STEP 4: VS Code
# =============================================================
info "=== Step 4: VS Code ==="
if ! command -v code &>/dev/null; then
    if [[ "$OS" == "macos" ]]; then
        brew install --cask visual-studio-code
    elif [[ "$OS" == "linux" ]]; then
        # Debian/Ubuntu
        if command -v apt &>/dev/null; then
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm -f packages.microsoft.gpg
            sudo apt update && sudo apt install -y code
        elif command -v dnf &>/dev/null; then
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf install -y code
        fi
    fi
    log "VS Code installed"
else
    log "VS Code already installed"
fi

# Install extensions
info "Installing VS Code extensions..."
EXTENSIONS=(
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "rangav.vscode-thunder-client"
    "mongodb.mongodb-vscode"
    "bradlc.vscode-tailwindcss"
    "ritwickdey.LiveServer"
    "eamodio.gitlens"
    "christian-kohler.path-intellisense"
    "PKief.material-icon-theme"
)

for ext in "${EXTENSIONS[@]}"; do
    code --install-extension "$ext" --force 2>/dev/null || warn "Could not install $ext"
done
log "VS Code extensions installed"

# =============================================================
# STEP 5: MongoDB
# =============================================================
info "=== Step 5: MongoDB ==="
if ! command -v mongosh &>/dev/null; then
    if [[ "$OS" == "macos" ]]; then
        brew tap mongodb/brew
        brew install mongodb-community@7.0
        brew services start mongodb-community@7.0
    elif [[ "$OS" == "linux" ]]; then
        # Import MongoDB GPG key
        curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
        echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
        sudo apt update && sudo apt install -y mongodb-org
        sudo systemctl start mongod
        sudo systemctl enable mongod
    fi
    log "MongoDB Community Server installed"
else
    log "MongoDB mongosh already available"
fi

# MongoDB Compass (GUI)
if [[ "$OS" == "macos" ]]; then
    brew install --cask mongodb-compass 2>/dev/null && log "MongoDB Compass installed" || warn "MongoDB Compass install skipped"
elif [[ "$OS" == "linux" ]]; then
    wget -O /tmp/mongodb-compass.deb "https://downloads.mongodb.com/compass/mongodb-compass_1.45.0_amd64.deb"
    sudo dpkg -i /tmp/mongodb-compass.deb 2>/dev/null && log "MongoDB Compass installed" || warn "Need to fix Compass deps: sudo apt --fix-broken install"
fi

# =============================================================
# STEP 6: Postman
# =============================================================
info "=== Step 6: Postman ==="
if ! command -v postman &>/dev/null; then
    if [[ "$OS" == "macos" ]]; then
        brew install --cask postman
    elif [[ "$OS" == "linux" ]]; then
        sudo snap install postman 2>/dev/null || {
            wget -O /tmp/postman.tar.gz "https://dl.pstmn.io/download/latest/linux64"
            sudo tar -xzf /tmp/postman.tar.gz -C /opt
            sudo ln -sf /opt/Postman/Postman /usr/local/bin/postman
        }
    fi
    log "Postman installed"
else
    log "Postman already installed"
fi

# =============================================================
# STEP 7: Frontend scaffold (Vite + React + Tailwind)
# =============================================================
info "=== Step 7: Test Scaffold ==="
SCAFFOLD_DIR="$HOME/projects/techskills-hub"
mkdir -p "$SCAFFOLD_DIR"

if [ ! -d "$SCAFFOLD_DIR/test-app" ]; then
    cd "$SCAFFOLD_DIR"
    npm create vite@latest test-app -- --template react
    cd test-app
    npm install
    npm install -D tailwindcss postcss autoprefixer
    npx tailwindcss init -p
    cat > tailwind.config.js << 'TAILWIND'
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: {} },
  plugins: [],
}
TAILWIND
    # Inject Tailwind directives into src/index.css
    echo '@tailwind base;' > src/index.css
    echo '@tailwind components;' >> src/index.css
    echo '@tailwind utilities;' >> src/index.css
    log "React + Vite + Tailwind scaffold created at $SCAFFOLD_DIR/test-app"
else
    log "Test scaffold already exists"
fi

# =============================================================
# STEP 8: Express.js backend scaffold
# =============================================================
info "=== Step 8: Express Backend ==="
BACKEND_DIR="$SCAFFOLD_DIR/backend"
if [ ! -d "$BACKEND_DIR" ]; then
    mkdir -p "$BACKEND_DIR"
    cd "$BACKEND_DIR"
    npm init -y
    npm install express mongoose dotenv cors
    cat > index.js << 'EXPRESS'
const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');

dotenv.config();
const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.json({ message: 'Tech Skills Hub API is running!' });
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
EXPRESS
    # .env file
    cat > .env << 'ENV'
PORT=5000
DB_URI=mongodb://localhost:27017/techskillshub
NODE_ENV=development
ENV
    # .gitignore
    echo "node_modules\n.env" > .gitignore
    log "Express backend scaffolded at $BACKEND_DIR"
else
    log "Express backend already exists"
fi

# =============================================================
# STEP 9: Global .gitignore
# =============================================================
info "=== Step 9: Global Gitignore ==="
GITIGNORE_GLOBAL="$HOME/.gitignore_global"
if [ ! -f "$GITIGNORE_GLOBAL" ]; then
    cat > "$GITIGNORE_GLOBAL" << 'GITIGNORE'
# OS
.DS_Store
Thumbs.db
*.swp
*.swo
*~

# Node
node_modules/
.env
.env.local
.env.*.local
dist/
build/
*.log
npm-debug.log*

# IDE
.vscode/
.idea/
*.sublime-*
GITIGNORE
    git config --global core.excludesfile "$GITIGNORE_GLOBAL"
    log "Global .gitignore configured"
fi

# =============================================================
# STEP 10: Shell aliases
# =============================================================
info "=== Step 10: Shell Aliases ==="
SHELL_RC="$HOME/.bashrc"
if [[ "$SHELL" == */zsh ]]; then
    SHELL_RC="$HOME/.zshrc"
fi

if ! grep -q "alias dev=" "$SHELL_RC" 2>/dev/null; then
    cat >> "$SHELL_RC" << 'ALIASES'

# --- Tech Skills Hub Aliases ---
alias dev="cd $HOME/projects"
alias ..="cd .."
alias ...="cd ../.."
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias nrd="npm run dev"
ALIASES
    log "Shell aliases added to $SHELL_RC"
fi

# =============================================================
# FINAL VALIDATION
# =============================================================
info "=== Final Validation ==="
echo ""
echo "----------------------------"
echo "Smoke Tests"
echo "----------------------------"

echo -n "Node.js    : "; node -e "console.log('✓', process.version)"
echo -n "npm        : "; npm --version
echo -n "Git        : "; git --version | awk '{print $3}'
echo -n "VS Code    : "; code --version | head -1
echo -n "MongoDB    : "; mongosh --version 2>/dev/null | head -1 || echo "not found (mongosh may need PATH)"
echo -n "React      : "; cd "$SCAFFOLD_DIR/test-app" && node -e "console.log('scaffold OK')"

echo ""
log "========================================"
log "Tech Skills Hub – Setup Complete!"
log "Project folder: $SCAFFOLD_DIR"
log "React app     : $SCAFFOLD_DIR/test-app"
log "Backend       : $SCAFFOLD_DIR/backend"
log "Log file      : $LOG_FILE"
log "========================================"
echo ""
info "Next steps:"
echo "  1. Open VS Code:  code $SCAFFOLD_DIR"
echo "  2. Start React:   cd $SCAFFOLD_DIR/test-app && npm run dev"
echo "  3. Start API:     cd $SCAFFOLD_DIR/backend && node index.js"
echo "  4. Open MongoDB Compass → connect to localhost:27017"
