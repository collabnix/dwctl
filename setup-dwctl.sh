#!/bin/bash
# setup-dwctl.sh - Complete setup script for dwctl repository
# Inspired by iximiuz labctl: https://github.com/iximiuz/labctl

set -e

echo "🚀 Setting up dwctl repository..."
echo "Inspired by iximiuz labctl - https://github.com/iximiuz/labctl"
echo "============================================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    echo "💡 Please run this script in your cloned dwctl repository:"
    echo "   git clone https://github.com/collabnix/dwctl.git"
    echo "   cd dwctl"
    echo "   ./setup-dwctl.sh"
    exit 1
fi

# Check for Go
if ! command -v go &> /dev/null; then
    echo "❌ Error: Go is not installed"
    echo "💡 Please install Go 1.21+ from https://golang.org/dl/"
    exit 1
fi

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "⚠️  Warning: Docker is not installed"
    echo "💡 You'll need Docker Desktop for workshops to work"
fi

echo "📁 Creating directory structure..."
mkdir -p cmd/dwctl
mkdir -p pkg/{docker,workshop,terminal,ssh}
mkdir -p web/{static/{css,js},templates}
mkdir -p workshops/{docker-basics,nodejs-workshop,python-workshop}/materials
mkdir -p docs
mkdir -p scripts
mkdir -p .github/{workflows,ISSUE_TEMPLATE}

echo "📝 Creating Go module..."
cat > go.mod << 'EOF'
module github.com/collabnix/dwctl

go 1.21

require (
    github.com/docker/docker v24.0.7+incompatible
    github.com/docker/go-connections v0.4.0
    github.com/spf13/cobra v1.8.0
    github.com/spf13/viper v1.17.0
    gopkg.in/yaml.v3 v3.0.1
)

require (
    github.com/Microsoft/go-winio v0.6.1 // indirect
    github.com/containerd/containerd v1.7.8 // indirect
    github.com/docker/distribution v2.8.3+incompatible // indirect
    github.com/docker/go-units v0.5.0 // indirect
    github.com/gogo/protobuf v1.3.2 // indirect
    github.com/moby/term v0.5.0 // indirect
    github.com/morikuni/aec v1.0.0 // indirect
    github.com/opencontainers/go-digest v1.0.0 // indirect
    github.com/opencontainers/image-spec v1.0.2 // indirect
    github.com/pkg/errors v0.9.1 // indirect
    github.com/sirupsen/logrus v1.9.3 // indirect
    golang.org/x/sys v0.14.0 // indirect
    golang.org/x/time v0.4.0 // indirect
    gotest.tools/v3 v3.5.1 // indirect
)
EOF

echo "📝 Creating main CLI application..."
cat > cmd/dwctl/main.go << 'EOF'
package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var version = "dev"

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

var rootCmd = &cobra.Command{
	Use:   "dwctl",
	Short: "Docker Workshop Control - Local workshop environments for Docker Desktop",
	Long: `Docker Workshop Control (dwctl) is a CLI tool for creating and managing 
local Docker-based workshop environments, inspired by iximiuz labctl.

Brought to you by the Collabnix Community.

Inspired by: https://github.com/iximiuz/labctl`,
	Version: version,
}

func init() {
	// Workshop commands
	workshopCmd := &cobra.Command{
		Use:   "workshop",
		Short: "Manage workshop environments",
		Long:  "Create, start, stop, and manage Docker-based workshop environments",
	}

	startCmd := &cobra.Command{
		Use:   "start [template]",
		Short: "Start a new workshop environment",
		Long:  "Start a new workshop environment from a template",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("🚀 Starting workshop: %s\n", args[0])
			fmt.Printf("📋 This is a placeholder implementation\n")
			fmt.Printf("🔗 Full Docker integration coming soon!\n")
			fmt.Printf("\n💡 Inspired by iximiuz labctl patterns:\n")
			fmt.Printf("   https://github.com/iximiuz/labctl\n")
			
			// Simulate workshop creation
			fmt.Printf("\n📦 Workshop Details:\n")
			fmt.Printf("   Template: %s\n", args[0])
			fmt.Printf("   Status: Ready for development\n")
			fmt.Printf("   Next: Implement Docker container creation\n")
		},
	}

	listCmd := &cobra.Command{
		Use:   "list",
		Short: "List running workshops",
		Long:  "List all currently running workshop environments",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("📋 Workshop Status:")
			fmt.Println("   No workshops currently running")
			fmt.Println("\n💡 Start one with:")
			fmt.Println("   dwctl workshop start docker-basics")
		},
	}

	stopCmd := &cobra.Command{
		Use:   "stop [workshop-id]",
		Short: "Stop a workshop environment",
		Long:  "Stop and remove a running workshop environment",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("🛑 Stopping workshop: %s\n", args[0])
			fmt.Printf("💡 Implementation coming soon!\n")
		},
	}

	// SSH/Connect commands
	sshCmd := &cobra.Command{
		Use:   "ssh [workshop-id]",
		Short: "Connect to workshop environment",
		Long:  "Open an interactive shell session to the workshop environment",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("🔗 Connecting to workshop: %s\n", args[0])
			fmt.Printf("💡 SSH integration coming soon!\n")
			fmt.Printf("🎯 Will use: docker exec -it %s bash\n", args[0])
		},
	}

	sshProxyCmd := &cobra.Command{
		Use:   "ssh-proxy [workshop-id]",
		Short: "Start SSH proxy for IDE integration",
		Long:  "Start an SSH proxy server for IDE integration (VS Code Remote, etc.)",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("🔌 Starting SSH proxy for: %s\n", args[0])
			fmt.Printf("💡 SSH proxy server coming soon!\n")
			fmt.Printf("🎯 Will enable: VS Code Remote development\n")
		},
	}

	// Templates command
	templatesCmd := &cobra.Command{
		Use:   "templates",
		Short: "List available workshop templates",
		Long:  "List all available workshop templates with descriptions",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("📚 Available Workshop Templates:\n\n")
			
			templates := []struct {
				Name        string
				Description string
				Duration    string
				Difficulty  string
			}{
				{"docker-basics", "Introduction to Docker fundamentals", "2h", "beginner"},
				{"nodejs-workshop", "Building Node.js applications with Docker", "3h", "intermediate"},
				{"python-workshop", "Python web development with containers", "2.5h", "intermediate"},
				{"kubernetes-basics", "Local Kubernetes with Docker Desktop", "4h", "advanced"},
			}

			for _, tmpl := range templates {
				fmt.Printf("🐳 %s\n", tmpl.Name)
				fmt.Printf("   %s\n", tmpl.Description)
				fmt.Printf("   Duration: %s | Difficulty: %s\n\n", tmpl.Duration, tmpl.Difficulty)
			}

			fmt.Printf("To start a workshop:\n")
			fmt.Printf("  dwctl workshop start <template-name>\n\n")
			fmt.Printf("💡 Inspired by iximiuz labctl: https://github.com/iximiuz/labctl\n")
		},
	}

	// About command
	aboutCmd := &cobra.Command{
		Use:   "about",
		Short: "About dwctl",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("🐳 Docker Workshop Control (dwctl)\n\n")
			fmt.Printf("A local Docker Desktop workshop management tool\n")
			fmt.Printf("inspired by the excellent iximiuz labctl.\n\n")
			fmt.Printf("🎯 Purpose:\n")
			fmt.Printf("   Solve the challenge of running on-demand workshops\n")
			fmt.Printf("   locally on Docker Desktop instead of cloud environments.\n\n")
			fmt.Printf("🙏 Inspired by:\n")
			fmt.Printf("   • iximiuz Labs: https://labs.iximiuz.com\n")
			fmt.Printf("   • labctl: https://github.com/iximiuz/labctl\n")
			fmt.Printf("   • Ivan Velichko's excellent work\n\n")
			fmt.Printf("🏢 Built by:\n")
			fmt.Printf("   Collabnix Community: https://collabnix.com\n\n")
			fmt.Printf("📜 License: Apache 2.0\n")
		},
	}

	// Build command tree
	workshopCmd.AddCommand(startCmd, listCmd, stopCmd)
	rootCmd.AddCommand(workshopCmd, sshCmd, sshProxyCmd, templatesCmd, aboutCmd)

	// Add flags
	startCmd.Flags().Bool("open", false, "Open workshop in browser after start")
	startCmd.Flags().Bool("ssh", false, "SSH into workshop after start")
	startCmd.Flags().StringP("name", "n", "", "Custom name for the workshop")
}
EOF

echo "📝 Creating README.md..."
cat > README.md << 'EOF'
# Docker Workshop Control (dwctl)

[![Build Status](https://github.com/collabnix/dwctl/workflows/CI/badge.svg)](https://github.com/collabnix/dwctl/actions)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

> A local Docker Desktop workshop management tool inspired by [iximiuz Labs labctl](https://github.com/iximiuz/labctl)

Brought to you by the [Collabnix Community](https://collabnix.com) 🚀

## 🎯 Problem Solved

**Challenge**: DevRel teams need on-demand workshop environments for Docker Desktop, but existing solutions are cloud-hosted and don't integrate with the local Docker Desktop VM environment that customers actually use.

**Solution**: dwctl brings the excellent UX patterns from iximiuz's labctl to local Docker Desktop environments, providing professional workshop management without cloud dependencies.

## 🙏 Inspiration

This project is heavily inspired by the outstanding work of:
- **[Ivan Velichko](https://github.com/iximiuz)** and [iximiuz Labs](https://labs.iximiuz.com)
- **[labctl](https://github.com/iximiuz/labctl)** - The CLI interface patterns we adapt for local use

We adapt labctl's excellent UX patterns for local Docker Desktop environments instead of cloud VMs.

## 🚀 Quick Start

### Build from Source
```bash
# Clone the repository
git clone https://github.com/collabnix/dwctl.git
cd dwctl

# Build
go build -o dwctl ./cmd/dwctl

# List available templates
./dwctl templates

# Learn more
./dwctl about

# Start a workshop (placeholder implementation)
./dwctl workshop start docker-basics
```

## ✨ Features (Planned)

- 🐳 **Native Docker Desktop Integration** - Works entirely with local Docker containers  
- 🖥️ **Professional CLI Interface** - Inspired by labctl's excellent UX patterns
- 🌐 **Web Terminal Access** - Browser-based terminals using xterm.js
- 🛠️ **IDE Integration** - SSH proxy support for VS Code Remote development
- 📚 **Workshop Templates** - Pre-built workshops for Docker, Node.js, Python, Kubernetes
- 🔌 **Port Management** - Easy service exposure and port forwarding
- 📱 **Collaborative Sessions** - Share workshop access with team members

## 📋 Comparison with Cloud Solutions

| Feature | Cloud Labs (e.g., iximiuz) | dwctl (Local) |
|---------|---------------------------|---------------|
| **Environment** | Remote VMs/containers | Local Docker containers |
| **Startup Time** | 10-30 seconds | 2-5 seconds |
| **Network Latency** | Internet dependent | Native local performance |
| **Cost** | Per-user cloud fees | Free (local resources) |
| **Offline Access** | Requires internet | Works completely offline |
| **Customization** | Platform limitations | Full Docker control |
| **Integration** | Generic cloud environment | Native Docker Desktop |

## 🛠️ Available Workshop Templates

### Docker Basics (2 hours, Beginner)
```bash
dwctl workshop start docker-basics
```
- Introduction to Docker fundamentals
- Container lifecycle management  
- Image building and optimization
- Basic networking concepts

### Node.js Workshop (3 hours, Intermediate)
```bash
dwctl workshop start nodejs-workshop
```
- Containerizing Node.js applications
- Multi-stage Docker builds
- Development workflows with hot reload
- Production optimization

### Python Workshop (2.5 hours, Intermediate)
```bash
dwctl workshop start python-workshop
```
- Flask and FastAPI development
- Python container best practices
- Virtual environments in containers
- Testing and debugging

### Kubernetes Basics (4 hours, Advanced)
```bash
dwctl workshop start kubernetes-basics
```
- Local Kubernetes with Docker Desktop
- Pod and service management
- kubectl usage and workflows
- Application deployment patterns

## 🚧 Development Status

🟡 **Active Development** - Core functionality being implemented

### Current Status
- ✅ Basic CLI structure with Cobra (inspired by labctl)
- ✅ Template system design
- 🚧 Docker integration (in progress)
- 🚧 Workshop management (in progress)  
- 🚧 Web terminal (planned)
- 🚧 SSH proxy (planned)

### Architecture Inspiration

We adapt labctl's architecture for local Docker environments:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   dwctl CLI    │────│  Docker Engine   │────│   Workshops     │
│                 │    │                  │    │                 │
│ • Workshop mgmt │    │ • Container mgmt │    │ • docker-basics │
│ • SSH proxy     │    │ • Network setup  │    │ • nodejs-ws     │
│ • Port forward  │    │ • Volume mounts  │    │ • python-ws     │
│ • Web terminal  │    │ • Image builds   │    │ • k8s-basics    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🤝 Contributing

We welcome contributions! This project is part of the [Collabnix Community](https://collabnix.com).

### Development Setup

```bash
# Clone the repository
git clone https://github.com/collabnix/dwctl.git
cd dwctl

# Install dependencies
go mod download

# Build the project
make build

# Run tests
make test
```

## 🏢 About Collabnix

[Collabnix](https://collabnix.com) is a community of developers, DevOps practitioners, and container enthusiasts. We're passionate about making complex technologies accessible through hands-on learning and practical examples.

## 📜 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **[Ivan Velichko](https://github.com/iximiuz)** and the [iximiuz Labs](https://labs.iximiuz.com) team for creating the excellent labctl that inspired this project
- **[Docker](https://docker.com)** for providing the container platform that makes this possible
- The **[Collabnix Community](https://collabnix.com)** for driving this initiative
- The open source community for the tools and libraries that power dwctl

## 🔗 Links

- [Collabnix Community](https://collabnix.com)
- [iximiuz Labs](https://labs.iximiuz.com) - The original inspiration
- [labctl](https://github.com/iximiuz/labctl) - The CLI tool that inspired our interface
- [Docker Desktop](https://docs.docker.com/desktop/) - Our target platform

---

**Built with ❤️ by the Collabnix Community, inspired by the excellent work of iximiuz Labs**
EOF

echo "📝 Creating .gitignore..."
cat > .gitignore << 'EOF'
# Binaries for programs and plugins
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with `go test -c`
*.test

# Output of the go coverage tool, specifically when used with LiteIDE
*.out

# Go workspace file
go.work

# Build output
/bin/
/dist/
dwctl

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS files
.DS_Store
Thumbs.db

# dwctl specific
.dwctl/
*.log

# Temporary files
*.tmp
*.temp

# Workshop state
workshops/**/state/
workshops/**/logs/
EOF

echo "📝 Creating Makefile..."
cat > Makefile << 'EOF'
.PHONY: build test clean install help

BINARY_NAME=dwctl
BUILD_DIR=bin
VERSION=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
LDFLAGS=-ldflags "-X main.version=$(VERSION)"

build:
	@echo "🔨 Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) ./cmd/dwctl

test:
	@echo "🧪 Running tests..."
	go test -v ./...

clean:
	@echo "🧹 Cleaning..."
	rm -rf $(BUILD_DIR)
	rm -f $(BINARY_NAME)

install: build
	@echo "📦 Installing $(BINARY_NAME)..."
	cp $(BUILD_DIR)/$(BINARY_NAME) /usr/local/bin/

help:
	@echo "Available targets:"
	@echo "  build   - Build the binary"
	@echo "  test    - Run tests"
	@echo "  clean   - Clean build artifacts"
	@echo "  install - Install binary to /usr/local/bin"
	@echo "  help    - Show this help"
EOF

echo "📝 Creating GitHub workflow..."
cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
    
    - name: Download dependencies
      run: go mod download
    
    - name: Build
      run: go build -v ./cmd/dwctl
    
    - name: Test
      run: go test -v ./...
    
    - name: Test CLI
      run: |
        ./dwctl --help
        ./dwctl templates
        ./dwctl about
EOF

echo "📝 Creating sample workshop..."
mkdir -p workshops/docker-basics/materials

cat > workshops/docker-basics/materials/README.md << 'EOF'
# Docker Basics Workshop

Welcome to the Docker Basics Workshop!

This workshop teaches Docker fundamentals through hands-on exercises.

## Exercises

### 1. Hello Docker
```bash
docker run hello-world
```

### 2. Interactive Container
```bash
docker run -it ubuntu bash
```

### 3. Build Custom Image
See the included Dockerfile and app.py

### 4. Container Management
Learn to list, stop, and remove containers.

## Coming Soon
Full interactive exercises with dwctl integration!

Inspired by iximiuz Labs: https://labs.iximiuz.com
EOF

echo "📦 Initializing Go modules..."
go mod tidy

echo "🔨 Testing build..."
if go build -o dwctl ./cmd/dwctl; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed!"
    exit 1
fi

echo "🧪 Testing CLI..."
./dwctl --help > /dev/null && echo "✅ CLI help works!"
./dwctl templates > /dev/null && echo "✅ Templates command works!"
./dwctl about > /dev/null && echo "✅ About command works!"

echo ""
echo "🎉 Setup complete! Repository is ready."
echo ""
echo "📁 Files created:"
find . -name "*.go" -o -name "*.md" -o -name "Makefile" -o -name "*.yml" | grep -v ".git" | sort

echo ""
echo "🚀 Next steps:"
echo "1. Test the CLI:"
echo "   ./dwctl templates"
echo "   ./dwctl about"
echo "2. Commit and push:"
echo "   git add ."
echo "   git commit -m \"Initial commit: dwctl inspired by iximiuz labctl\""
echo "   git push origin main"
echo ""
echo "🔗 Inspired by the excellent iximiuz labctl:"
echo "   https://github.com/iximiuz/labctl"
echo ""
echo "💡 This creates a solid foundation to build upon!"
