# Docker Workshop Control (dwctl)

[![Build Status](https://github.com/collabnix/dwctl/workflows/CI/badge.svg)](https://github.com/collabnix/dwctl/actions)


> A local Docker Desktop workshop management tool inspired by [iximiuz Labs labctl](https://github.com/iximiuz/labctl)


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
