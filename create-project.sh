#!/bin/bash
# Quick setup script for dwctl repository
# Run this in an empty git repository

set -e

echo "🚀 Setting up dwctl repository..."

# Create directory structure
mkdir -p cmd/dwctl pkg/{docker,workshop} workshops/docker-basics/materials .github/workflows

# Create go.mod
cat > go.mod << 'EOF'
module github.com/collabnix/dwctl

go 1.21

require (
    github.com/docker/docker v24.0.7+incompatible
    github.com/docker/go-connections v0.4.0
    github.com/spf13/cobra v1.8.0
    gopkg.in/yaml.v3 v3.0.1
)
EOF

# Create main.go with basic CLI structure
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

Brought to you by the Collabnix Community.`,
	Version: version,
}

func init() {
	// Workshop commands
	workshopCmd := &cobra.Command{
		Use:   "workshop",
		Short: "Manage workshop environments",
	}

	startCmd := &cobra.Command{
		Use:   "start [template]",
		Short: "Start a new workshop environment",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("🚀 Starting workshop: %s\n", args[0])
			fmt.Printf("⚡ This is a placeholder - full implementation coming soon!\n")
			fmt.Printf("📚 Template: %s\n", args[0])
			fmt.Printf("🔗 Inspired by iximiuz labctl: https://github.com/iximiuz/labctl\n")
		},
	}

	listCmd := &cobra.Command{
		Use:   "list",
		Short: "List running workshops",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("📋 No workshops running")
			fmt.Println("💡 Start one with: dwctl workshop start docker-basics")
		},
	}

	templatesCmd := &cobra.Command{
		Use:   "templates",
		Short: "List available workshop templates",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("Available Workshop Templates:")
			fmt.Println("")
			fmt.Println("📚 docker-basics")
			fmt.Println("   Introduction to Docker fundamentals (2h, beginner)")
			fmt.Println("")
			fmt.Println("📚 nodejs-workshop") 
			fmt.Println("   Building Node.js applications with Docker (3h, intermediate)")
			fmt.Println("")
			fmt.Println("📚 python-workshop")
			fmt.Println("   Python web development with containers (2.5h, intermediate)")
			fmt.Println("")
			fmt.Println("To start: dwctl workshop start <template-name>")
		},
	}

	workshopCmd.AddCommand(startCmd, listCmd)
	rootCmd.AddCommand(workshopCmd, templatesCmd)
}
EOF

# Create README.md
cat > README.md << 'EOF'
# Docker Workshop Control (dwctl)

[![Build Status](https://github.com/collabnix/dwctl/workflows/CI/badge.svg)](https://github.com/collabnix/dwctl/actions)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

> A local Docker Desktop workshop management tool inspired by [iximiuz Labs labctl](https://github.com/iximiuz/labctl)

Brought to you by the [Collabnix Community](https://collabnix.com) 🚀

## 🎯 Problem Solved

**Challenge**: DevRel teams need on-demand workshop environments for Docker Desktop, but existing solutions are cloud-hosted and don't integrate with the local Docker Desktop VM environment.

**Solution**: dwctl brings the excellent UX patterns from iximiuz's labctl to local Docker Desktop environments.

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

# Start a workshop (placeholder)
./dwctl workshop start docker-basics
```

## ✨ Features (Planned)

- 🐳 **Native Docker Desktop Integration** - Works entirely with local Docker containers
- 🖥️ **Professional CLI Interface** - Inspired by labctl's excellent UX patterns  
- 🌐 **Web Terminal Access** - Browser-based terminals using xterm.js
- 🛠️ **IDE Integration** - SSH proxy support for VS Code Remote development
- 📚 **Workshop Templates** - Pre-built workshops for Docker, Node.js, Python, Kubernetes

## 🎨 Inspired By

This project is heavily inspired by the excellent work of:
- **[Ivan Velichko](https://github.com/iximiuz)** and [iximiuz Labs](https://labs.iximiuz.com)
- **[labctl](https://github.com/iximiuz/labctl)** - The CLI interface patterns we adapt

## 🚧 Development Status

🟡 **Active Development** - Core functionality being implemented

### Current Status
- ✅ Basic CLI structure with Cobra
- ✅ Template system design
- 🚧 Docker integration (in progress)
- 🚧 Workshop management (in progress)
- 🚧 Web terminal (planned)
- 🚧 SSH proxy (planned)

## 🤝 Contributing

We welcome contributions! This project is part of the [Collabnix Community](https://collabnix.com).

## 📜 License

Apache License 2.0

## 🙏 Acknowledgments

Special thanks to [Ivan Velichko](https://github.com/iximiuz) for creating the labctl patterns that inspire this project.

---

**Built with ❤️ by the Collabnix Community**
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Binaries
*.exe
*.exe~
*.dll
*.so
*.dylib
dwctl

# Test binary, built with `go test -c`
*.test

# Output of the go coverage tool
*.out

# Go workspace file
go.work

# Build output
/bin/
/dist/

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# dwctl specific
.dwctl/
*.log
EOF

# Create basic Makefile
cat > Makefile << 'EOF'
.PHONY: build test clean

BINARY_NAME=dwctl

build:
	go build -o $(BINARY_NAME) ./cmd/dwctl

test:
	go test -v ./...

clean:
	rm -f $(BINARY_NAME)

install: build
	cp $(BINARY_NAME) /usr/local/bin/

help:
	@echo "Available targets:"
	@echo "  build   - Build the binary"
	@echo "  test    - Run tests"
	@echo "  clean   - Clean build artifacts"
	@echo "  install - Install binary to /usr/local/bin"
EOF

# Create basic GitHub workflow
cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
    
    - name: Build
      run: go build -v ./cmd/dwctl
    
    - name: Test
      run: go test -v ./...
EOF

# Initialize and test
echo "📦 Initializing Go modules..."
go mod tidy

echo "🔨 Testing build..."
go build -o dwctl ./cmd/dwctl

echo "✅ Testing CLI..."
./dwctl --help

echo ""
echo "🎉 Setup complete! Repository is ready."
echo ""
echo "📁 Files created:"
find . -name "*.go" -o -name "*.md" -o -name "Makefile" -o -name "*.yml" | sort

echo ""
echo "🚀 Next steps:"
echo "1. git add ."
echo "2. git commit -m \"Initial commit: dwctl skeleton inspired by iximiuz labctl\""  
echo "3. git push origin main"
echo ""
echo "🔧 Test the CLI:"
echo "./dwctl templates"
echo "./dwctl workshop start docker-basics"
