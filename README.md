# NMCS - Network Media Control System

[![CMake](https://github.com/ultralove/ultralove-nmcs/actions/workflows/build.yml/badge.svg?branch=develop)](https://github.com/ultralove/ultralove-nmcs/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![C++23](https://img.shields.io/badge/C%2B%2B-23-blue.svg)](https://en.cppreference.com/w/cpp/23)
[![Version](https://img.shields.io/badge/version-2.0.0-green.svg)](https://github.com/ultralove/ultralove-nmcs/releases)

A modern, cross-platform C++23 library system for controlling and managing network-based media services, with a particular focus on podcast and audio content management.

## Features

- **Cross-Platform Support**: Native support for macOS (Darwin), Linux, and Windows
- **Modern C++**: Built with C++23 standards and C23 support
- **Media Management**: Comprehensive podcast, episode, and audio metadata handling
- **ID3v2 Processing**: Full support for ID3v2 audio metadata frames
- **Service Architecture**: Extensible service-oriented design with factory patterns
- **HTTP Services**: Built-in web service capabilities
- **Database Integration**: SQL Server/Azure SQL Edge support
- **Platform Abstraction**: Native GUID generation, memory management, and security vault integration

## Table of Contents

- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Building](#building)
- [Usage](#usage)
- [API Documentation](#api-documentation)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Architecture

NMCS follows a modular, layered architecture:

### Core Layers

```text
┌─────────────────────────────────────────────────────────┐
│                    Client/Agent Layer                   │
├─────────────────────────────────────────────────────────┤
│                     Server Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   │
│  │ HTTP Service│ │ID3v2 Service│ │Credential Service│   │
│  └─────────────┘ └─────────────┘ └─────────────────┘   │
├─────────────────────────────────────────────────────────┤
│                     Model Layer                        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   │
│  │   Podcast   │ │   Episode   │ │   Contributors  │   │
│  └─────────────┘ └─────────────┘ └─────────────────┘   │
├─────────────────────────────────────────────────────────┤
│                    Runtime Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   │
│  │   Strings   │ │    GUIDs    │ │      URIs       │   │
│  └─────────────┘ └─────────────┘ └─────────────────┘   │
├─────────────────────────────────────────────────────────┤
│                   Platform Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   │
│  │   Darwin    │ │    Linux    │ │     Windows     │   │
│  └─────────────┘ └─────────────┘ └─────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### Key Components

- **Platform Layer**: Cross-platform abstractions for memory allocation, GUID generation, and system services
- **Runtime Layer**: Core services including string handling, URI processing, streams, and versioning
- **Model Layer**: Rich data models for podcasts, episodes, seasons, contributors, and media metadata
- **Server Layer**: HTTP services, ID3v2 processing, file services, and service management
- **Client/Agent Layer**: Applications and command-line tools

## Prerequisites

### Build Requirements

- **CMake**: 3.23 or higher
- **C++ Compiler**: Supporting C++23 standard
  - GCC 13+ or Clang 16+ (Linux)
  - Xcode 15+ (macOS)
  - Visual Studio 2022 17.8+ (Windows)

### Dependencies

The build system automatically fetches and builds the following dependencies:

- **CLI11** v2.4.1 - Command line interface library
- **zlib** v1.3.1 - Compression library
- **libcurl** 8.6.0 - HTTP/HTTPS client library
- **libxml2** v2.12.6 - XML processing library
- **simdutf** v5.0.0 - Unicode validation and transcoding
- **simdjson** v3.8.0 - JSON parsing library
- **spdlog** v1.13.0 - Logging library
- **whisper.cpp** v1.5.4 - Speech-to-text capabilities

### Platform-Specific Requirements

#### macOS (Darwin)

- Xcode Command Line Tools
- CoreFoundation, IOKit, and Security frameworks

#### Linux

- GCC or Clang with C++23 support
- Standard POSIX libraries

#### Windows

- Visual Studio 2022 with C++23 support
- Windows SDK

## Building

### Quick Start

```bash
# Clone the repository
git clone https://github.com/ultralove/ultralove-nmcs.git
cd ultralove-nmcs

# Build (Debug configuration)
./build.sh

# Build Release configuration
./build.sh Release
```

### Windows

```powershell
# Build using PowerShell
.\build.ps1

# Build Release configuration
.\build.ps1 Release
```

### Advanced Build Options

```bash
# Build with specific build ID
NMCS_BUILD_ID=123 ./build.sh

# Clean build
rm -rf _build && ./build.sh

# Build specific targets
cmake --build _build --target nmcsserver
```

### CMake Presets

The project includes CMake presets for common configurations:

```bash
# List available presets
cmake --list-presets

# Use a specific preset
cmake --preset debug
cmake --build --preset debug
```

## Usage

### Command Line Tools

NMCS includes several command-line utilities:

```bash
# Generate GUIDs
./nmcsclient guidgen

# Process chapter information
./nmcsclient chapters --input audio.mp3

# Hex dump utility
./nmcsclient hexdump --file data.bin
```

### Library Integration

```cpp
#include <nmcs/nmcs.h>

using namespace ultralove::nmcs;

int main() {
    // Initialize NMCS runtime
    auto status = runtime::Initialize();
    if (NMCS_FAILED(status)) {
        return -1;
    }

    // Create a podcast model
    model::Podcast podcast;
    podcast.title_ = runtime::String("My Podcast");
    podcast.uri_ = runtime::Uri("https://example.com/podcast");

    // Access server services
    server::ServiceManager& serviceManager = server::ServiceManager::Instance();
    server::IService* httpService = nullptr;
    status = serviceManager.AcquireService("http", nullptr, httpService);

    // Cleanup
    runtime::Cleanup();
    return 0;
}
```

### Building Against NMCS

```cmake
find_package(nmcs REQUIRED)
target_link_libraries(your_target
    PRIVATE
    nmcs::platform
    nmcs::runtime
    nmcs::model
    nmcs::server
)
```

## API Documentation

### Core Namespaces

- `ultralove::nmcs::platform` - Platform abstraction layer
- `ultralove::nmcs::runtime` - Runtime services and utilities
- `ultralove::nmcs::model` - Data models and structures
- `ultralove::nmcs::server` - Server services and HTTP handling

### Key Classes

#### Model Layer

- `model::Podcast` - Podcast container with episodes and metadata
- `model::Episode` - Individual podcast episode
- `model::Contributor` - Person involved in content creation
- `model::Asset` - Media files and enclosures

#### Runtime Layer

- `runtime::String` - Cross-platform string handling
- `runtime::Uri` - URI processing and validation
- `runtime::Guid` - GUID generation and manipulation
- `runtime::Stream` - Stream processing utilities

#### Server Layer

- `server::ServiceManager` - Central service registry
- `server::IHttpService` - HTTP service interface
- `server::IFileService` - File system operations

### Error Handling

All APIs use the `NmcsStatus` return type for consistent error handling:

```cpp
NmcsStatus status = SomeFunction();
if (NMCS_FAILED(status)) {
    // Handle error
    return status;
}
```

Common status codes:

- `NMCS_STATUS_SUCCESS` - Operation completed successfully
- `NMCS_STATUS_FAILURE` - General failure
- `NMCS_STATUS_NOT_FOUND` - Resource not found
- `NMCS_STATUS_INVALID_PARAMETER` - Invalid parameter provided
- `NMCS_STATUS_OUT_OF_MEMORY` - Memory allocation failed

## Development

### Project Structure

```text
nmcs/
├── include/nmcs/          # Public API headers
├── src/                   # Source code
│   ├── platform/          # Platform abstractions
│   ├── runtime/           # Runtime services
│   ├── model/             # Data models
│   ├── server/            # Server implementation
│   ├── agent/             # Agent implementation
│   └── client/            # Client applications
├── cmake/                 # CMake platform files
├── scripts/               # Build and utility scripts
├── docs/                  # Documentation
└── CMakeLists.txt         # Root CMake file
```

### Coding Standards

- **Language**: C++23 with C23 support
- **Naming**: PascalCase for classes, camelCase for functions
- **Headers**: Use `#ifndef __NMCS_*_H_INCL__` guards
- **Namespaces**: All code under `ultralove::nmcs`
- **Memory**: RAII patterns with smart pointers
- **Exports**: Use `NMCS_SHARED_API` for public APIs

### Adding New Components

1. **Models**: Add to `include/nmcs/model*.h` and `src/model/`
2. **Services**: Implement `IService` interface and register with ServiceManager
3. **Platform Code**: Add to appropriate `src/platform/{platform}/` directory

### Testing

```bash
# Run client tests
./nmcsclient guidgen
./nmcsclient chapters --help
```

### Documentation Generation

```bash
# Generate Doxygen documentation
cd scripts
doxygen doxyfile
```

## Contributing

We welcome contributions! Please see our contributing guidelines:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/your-username/ultralove-nmcs.git
cd ultralove-nmcs

# Set up upstream remote
git remote add upstream https://github.com/ultralove/ultralove-nmcs.git

# Create development branch
git checkout -b feature/your-feature develop
```

### Code Review Process

1. Ensure all tests pass
2. Follow coding standards
3. Update documentation as needed
4. Add tests for new functionality
5. Maintain cross-platform compatibility

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Links

- **Repository**: [https://github.com/ultralove/ultralove-nmcs](https://github.com/ultralove/ultralove-nmcs)
- **Issues**: [https://github.com/ultralove/ultralove-nmcs/issues](https://github.com/ultralove/ultralove-nmcs/issues)
- **Releases**: [https://github.com/ultralove/ultralove-nmcs/releases](https://github.com/ultralove/ultralove-nmcs/releases)

## Support

For support and questions:

- Create an [issue](https://github.com/ultralove/ultralove-nmcs/issues) for bugs and feature requests
- Contact: [staff@ultralove.io](mailto:staff@ultralove.io)

---

Made with love by the [ultralove](https://github.com/ultralove) contributors
