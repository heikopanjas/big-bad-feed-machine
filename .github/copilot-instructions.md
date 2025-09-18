# NMCS (Network Media Control System) - Copilot Instructions

## Project Overview

The **Network Media Control System (NMCS)** is a C/C++ cross-platform library system for controlling and managing network-based media services, particularly focused on podcast and audio content management. The project is version 2.0.0 and uses modern C++23 standards.

## Project Structure

### Core Architecture
The project follows a modular architecture with the following main components:

- **Platform Layer** (`src/platform/`, `include/nmcs/platform*.h`): Cross-platform abstractions for Darwin, Linux, and Windows
- **Runtime Layer** (`src/runtime/`, `include/nmcs/runtime*.h`): Core runtime services including string handling, GUIDs, URIs, streams, and versioning
- **Model Layer** (`src/model/`, `include/nmcs/model*.h`): Data models for podcasts, episodes, seasons, contributors, assets, and media metadata
- **Server Layer** (`src/server/`, `include/nmcs/server*.h`): HTTP services, ID3v2 processing, credential management, and service management
- **Agent Layer** (`src/agent/`): Agent implementation
- **Client Layer** (`src/client/`): Client applications and command-line tools

### Key Technologies
- **Build System**: CMake 3.23+ with presets and cross-platform support
- **Standards**: C23 and C++23
- **Dependencies**: libcurl, libxml2, simdjson, spdlog
- **Platforms**: Darwin (macOS), Linux, Windows
- **Database**: SQL Server/Azure SQL Edge support
- **Packaging**: CPack for ZIP/TGZ distribution

## Development Guidelines

### Code Style and Standards
1. **Namespace Convention**: All code is under `ultralove::nmcs` with sub-namespaces for each layer
2. **Header Guards**: Use `#ifndef __NMCS_*_H_INCL__` pattern
3. **Memory Management**: C++ RAII patterns with shared pointer semantics
4. **Error Handling**: Custom status codes using `NmcsStatus` type
5. **API Design**: Shared library exports using `NMCS_SHARED_API` macro
6. **Packing**: Use `#pragma pack(push/pop)` for binary compatibility

### File Organization
- **Headers**: All public APIs in `include/nmcs/`
- **Implementation**: Source files in `src/` subdirectories
- **Platform-specific**: Platform code in `src/platform/{darwin,linux,windows}/`
- **Build**: CMakeLists.txt in each source directory

### Naming Conventions
- **Classes**: PascalCase (e.g., `ServiceManager`, `Podcast`)
- **Functions/Methods**: camelCase
- **Constants/Macros**: UPPER_SNAKE_CASE with `NMCS_` prefix
- **Files**: lowercase with module prefix (e.g., `modelpodcast.h`, `serverservice.h`)
- **Status Codes**: `NMCS_STATUS_*` pattern

### Build System
- **Primary Build**: Use `build.sh` (Unix) or `build.ps1` (Windows)
- **CMake Presets**: Defined in `CMakePresets.json`
- **Debug/Release**: Supports both configurations
- **Cross-platform**: Platform detection via CMake files in `cmake/`

## Model System

The model layer represents podcast and media metadata:

### Core Models
- **Podcast**: Root container with URI, title, description, picture, publisher, seasons
- **Episode**: Individual content items with enclosures, contributors, tags
- **Season**: Collection of episodes
- **Contributor**: People involved in content creation with roles and presence types
- **Asset/Enclosure**: Media files with type information
- **Picture**: Image metadata with type support (JPEG, PNG)
- **Tags**: Various tagging systems (chapter, location, transcript, etc.)

### Key Characteristics
- All models inherit from `Fabric` base class
- Support for binary serialization/deserialization
- GUID-based identification system
- Timestamp tracking for creation/modification
- Flexible array members for collections

## Server System

The server layer provides HTTP services and media processing:

### Service Architecture
- **Service Manager**: Central registry for services with factory pattern
- **Service Callbacks**: Async callback interfaces
- **HTTP Service**: Web service abstractions
- **File Service**: File system operations
- **Credential Service**: Authentication and authorization
- **ID3v2 Service**: Audio metadata processing

### Frame Processing
- Support for ID3v2 frames including:
  - Attached pictures
  - Chapter information
  - Text information
  - Comments
  - URL links
  - Table of contents

## Platform Abstractions

### Supported Platforms
- **Darwin (macOS)**: CoreFoundation, IOKit, Security frameworks
- **Linux**: Standard POSIX APIs
- **Windows**: Win32 APIs

### Platform Services
- **Memory Allocation**: Platform-specific allocators
- **GUID Generation**: Native GUID/UUID support
- **Security Vault**: Keychain/credential storage (planned)

## Development Workflow

### Building
```bash
# Debug build
./build.sh

# Release build
./build.sh Release

# With specific build ID
NMCS_BUILD_ID=123 ./build.sh
```

### Testing
- Client applications in `src/client/` for testing functionality
- Command-line tools for chapters, GUID generation, hex dumps

### Documentation
- Doxygen configuration in `scripts/doxyfile`
- Installation instructions in `docs/nmcs-installation-instructions.org`

### Git Workflow and Commits
When asked to commit changes, follow this process:
1. **Stage all modified files** using `git add .` or specific files
2. **Write commit messages** using Conventional Commits format:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `refactor:` for code refactoring
   - `test:` for adding/updating tests
   - `chore:` for maintenance tasks
   - `build:` for build system changes
   - `ci:` for CI/CD changes
3. **Message format**: `type(scope): description`
   - Keep description concise but detailed enough to understand the change
   - Use imperative mood ("add feature" not "added feature")
   - Include breaking changes in footer if applicable
4. **Example**: `docs: add comprehensive README with architecture diagrams and usage examples`
5. **Commit** using `git commit -m "message"`

## Common Tasks

### Adding New Models
1. Create header in `include/nmcs/model*.h`
2. Add to `include/nmcs/model.h` includes
3. Implement in `src/model/`
4. Update `src/model/CMakeLists.txt`

### Adding New Services
1. Define interface in `include/nmcs/server*.h`
2. Implement in `src/server/`
3. Register with ServiceManager
4. Update `src/server/CMakeLists.txt`

### Platform-Specific Code
1. Add declarations to appropriate platform header
2. Implement in `src/platform/{platform}/`
3. Update platform CMakeLists.txt
4. Test across all target platforms

## Important Notes

- **Thread Safety**: Use recursive mutexes and atomic operations where needed
- **Binary Compatibility**: Maintain struct packing and API stability
- **Resource Management**: All interfaces use RAII and smart pointer patterns
- **Error Handling**: Always check and propagate `NmcsStatus` return values
- **Cross-Platform**: Test on all supported platforms before merging

## Current State

The project is in active development on the `develop` branch. The main components (platform, runtime, model, server) are implemented with CMake build system fully functional. Focus areas include completing gateway implementations and expanding the service ecosystem.
