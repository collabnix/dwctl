#!/bin/bash
# install.sh - One-command installation for dwctl
# Usage: curl -sf https://raw.githubusercontent.com/collabnix/dwctl/main/install.sh | sh

set -e

DWCTL_VERSION="${DWCTL_VERSION:-latest}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
REPO="collabnix/dwctl"

echo "🐳 Installing Docker Workshop Control (dwctl)"
echo "=============================================="
echo "Inspired by iximiuz labctl: https://github.com/iximiuz/labctl"
echo ""

# Check prerequisites
check_prerequisites() {
    echo "📋 Checking prerequisites..."
    
    # Check if we have curl or wget
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        echo "❌ Error: curl or wget is required"
        exit 1
    fi
    
    # Check if Docker is available (warn but don't fail)
    if ! command -v docker >/dev/null 2>&1; then
        echo "⚠️  Warning: Docker not found. You'll need Docker Desktop for workshops."
    fi
    
    # Check Go (for build-from-source fallback)
    if ! command -v go >/dev/null 2>&1; then
        echo "ℹ️  Go not found. Will try to download pre-built binary."
        GO_AVAILABLE=false
    else
        echo "✅ Go found: $(go version)"
        GO_AVAILABLE=true
    fi
}

# Detect OS and architecture
detect_platform() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    
    case $ARCH in
        x86_64) ARCH="amd64" ;;
        arm64|aarch64) ARCH="arm64" ;;
        *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
    esac
    
    case $OS in
        linux|darwin) ;;
        mingw*|cygwin*|msys*) OS="windows"; ARCH="${ARCH}.exe" ;;
        *) echo "❌ Unsupported OS: $OS"; exit 1 ;;
    esac
    
    echo "📟 Detected platform: ${OS}-${ARCH}"
}

# Try to download pre-built binary
download_binary() {
    echo "📥 Trying to download pre-built binary..."
    
    BINARY_NAME="dwctl"
    if [[ "$OS" == "windows" ]]; then
        BINARY_NAME="dwctl.exe"
    fi
    
    # Try GitHub Releases first
    DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${DWCTL_VERSION}/dwctl-${OS}-${ARCH}"
    if [[ "$OS" == "windows" ]]; then
        DOWNLOAD_URL="${DOWNLOAD_URL}.exe"
    fi
    
    mkdir -p "$INSTALL_DIR"
    
    echo "🔗 Trying: $DOWNLOAD_URL"
    
    if command -v curl >/dev/null 2>&1; then
        if curl -fsSL "$DOWNLOAD_URL" -o "$INSTALL_DIR/$BINARY_NAME" 2>/dev/null; then
            chmod +x "$INSTALL_DIR/$BINARY_NAME"
            echo "✅ Downloaded pre-built binary"
            return 0
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -q "$DOWNLOAD_URL" -O "$INSTALL_DIR/$BINARY_NAME" 2>/dev/null; then
            chmod +x "$INSTALL_DIR/$BINARY_NAME"
            echo "✅ Downloaded pre-built binary"
            return 0
        fi
    fi
    
    echo "⚠️  Pre-built binary not available"
    return 1
}

# Build from source as fallback
build_from_source() {
    echo "🔨 Building from source..."
    
    if [[ "$GO_AVAILABLE" != "true" ]]; then
        echo "❌ Go is required to build from source"
        echo "💡 Please install Go from https://golang.org/dl/"
        exit 1
    fi
    
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    echo "📥 Cloning repository..."
    if command -v git >/dev/null 2>&1; then
        git clone "https://github.com/${REPO}.git" dwctl
    elif command -v curl >/dev/null 2>&1; then
        curl -fsSL "https://github.com/${REPO}/archive/main.tar.gz" | tar -xz
        mv dwctl-main dwctl
    else
        echo "❌ git or curl required to download source"
        exit 1
    fi
    
    cd dwctl
    
    echo "🔨 Building dwctl..."
    go mod tidy
    go build -o dwctl ./cmd/dwctl
    
    echo "📦 Installing to $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
    cp dwctl "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/dwctl"
    
    # Cleanup
    cd /
    rm -rf "$TEMP_DIR"
    
    echo "✅ Built and installed from source"
}

# Add to PATH
setup_path() {
    echo "🛣️  Setting up PATH..."
    
    # Check if already in PATH
    if command -v dwctl >/dev/null 2>&1; then
        echo "✅ dwctl is already in PATH"
        return 0
    fi
    
    # Add to shell profile
    SHELL_PROFILE=""
    if [[ "$SHELL" == *"bash"* ]]; then
        SHELL_PROFILE="$HOME/.bashrc"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_PROFILE="$HOME/.zshrc"
    else
        SHELL_PROFILE="$HOME/.profile"
    fi
    
    if [[ -f "$SHELL_PROFILE" ]] && ! grep -q "$INSTALL_DIR" "$SHELL_PROFILE" 2>/dev/null; then
        echo "" >> "$SHELL_PROFILE"
        echo "# Docker Workshop Control (dwctl)" >> "$SHELL_PROFILE"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_PROFILE"
        echo "✅ Added $INSTALL_DIR to PATH in $SHELL_PROFILE"
    fi
    
    # Add to current session
    export PATH="$INSTALL_DIR:$PATH"
}

# Test installation
test_installation() {
    echo "🧪 Testing installation..."
    
    if ! command -v dwctl >/dev/null 2>&1; then
        # Try with full path
        if [[ -x "$INSTALL_DIR/dwctl" ]]; then
            DWCTL_CMD="$INSTALL_DIR/dwctl"
        else
            echo "❌ Installation failed"
            exit 1
        fi
    else
        DWCTL_CMD="dwctl"
    fi
    
    # Test basic functionality
    if $DWCTL_CMD --version >/dev/null 2>&1; then
        echo "✅ dwctl is working!"
    else
        echo "❌ dwctl installation appears broken"
        exit 1
    fi
}

# Main installation flow
main() {
    check_prerequisites
    detect_platform
    
    # Try binary download first, fallback to source build
    if ! download_binary; then
        echo "💡 Falling back to building from source..."
        build_from_source
    fi
    
    setup_path
    test_installation
    
    echo ""
    echo "🎉 Installation complete!"
    echo "=============================================="
    echo ""
    echo "🚀 Quick start:"
    
    if command -v dwctl >/dev/null 2>&1; then
        echo "  dwctl templates                 # List workshop templates"
        echo "  dwctl about                     # About dwctl"
        echo "  dwctl workshop start docker-basics  # Start a workshop"
    else
        echo "  # Reload your shell first:"
        echo "  source ~/.bashrc  # or ~/.zshrc"
        echo ""
        echo "  # Then:"
        echo "  dwctl templates                 # List workshop templates"
        echo "  dwctl about                     # About dwctl"  
        echo "  dwctl workshop start docker-basics  # Start a workshop"
    fi
    
    echo ""
    echo "📚 Documentation:"
    echo "  https://github.com/${REPO}"
    echo ""
    echo "🙏 Inspired by:"
    echo "  iximiuz Labs: https://labs.iximiuz.com"
    echo "  labctl: https://github.com/iximiuz/labctl"
    echo ""
    echo "🏢 Built by Collabnix Community: https://collabnix.com"
}

# Run main function
main "$@"
