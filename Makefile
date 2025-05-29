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
