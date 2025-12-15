# 🤖 AI Rules for Flutter VSCode Extension Framework

**Goal:** As an expert in Flutter, Dart, code generation, and VSCode extension development, your goal is to build and maintain a robust code generation package that enables seamless integration between Flutter web apps and VSCode extensions, following modern best practices and strict conventions.

## 1. Project Management & Structure 📦

* **Project Type:** This is a **Flutter package** (library) project, not an application. The package provides code generation and runtime utilities for building VSCode extensions with Flutter.
* **Structure:**
  * `lib/` contains the package code (generators, annotations, runtime utilities)
  * `example/` contains example usage of the package
  * `bin/` contains CLI tools (e.g., `generate_vscode_extension`)
  * `tool/` contains code generation templates
* **Package Selection:** If a new feature requires an external package, identify the **most suitable and stable package** from pub.dev. For code generation, prefer:
  * `source_gen` and `build_runner` for Dart code generation
  * `analyzer` for static analysis and code introspection
  * `package:web` for modern JavaScript interop (not `dart:js_util`)
* **Dependency Commands:**
  * To add a regular dependency: Execute `flutter pub add <package_name>`.
  * To add a development dependency: Execute `flutter pub add dev:<package_name>`.

## 2. Code Quality & Dart Best Practices ✨

### Analysis & Linting (CRITICAL PREFERENCE)

* **Analysis Tooling:** The project **must** use the **`very_good_analysis`** package for code analysis and linting. Adhere to all rules enforced by this package.
* **Effective Dart:** Follow the official **Effective Dart guidelines** strictly.

### Code Principles

* **Separation of Concerns (SoC):**
  * Keep code generation logic separate from runtime utilities
  * Separate Dart code generation from TypeScript code generation
  * Keep webview bridge implementations platform-specific (web vs stub)
* **Naming:** Adhere to **meaningful and consistent naming conventions**:
  * `VSCode*` prefix for classes related to VSCode functionality
  * `*Generator` suffix for code generator classes
  * `*Element` for analyzer element types

### Organization & Documentation

* **Library Files:**
  * Export related classes from a single top-level library file (barrel file pattern)
  * Use conditional exports (`export 'x.dart' if (condition) 'y.dart'`) for platform-specific code
* **Folder Structure:**
  * `lib/src/` for internal implementation
  * Keep generators in `lib/src/` with descriptive names
* **Documentation:** Add **documentation comments** (`///`) to all public APIs, including:
  * Classes (especially public-facing ones like `VSCodeGenerator`)
  * Public methods and constructors
  * Annotations (`@VSCodeController`, `@VSCodeCommand`)
* **Comments:** Write clear comments only for complex or non-obvious code. **Avoid over-commenting and do not add trailing comments.**

### Modern Dart Features (PERSONAL PREFERENCE)

* **Notation:** Always use **modern Dart notation**:
  * Collection-if, collection-for
  * Cascade operator (`..`)
  * Records where appropriate
  * `final` keyword usage
  * Pattern matching where it simplifies code
* **Asynchronicity:** Ensure proper use of `async`/`await` for asynchronous operations with **robust error handling**.
* **JS Interop:** Always use **`package:web`** and **`dart:js_interop`** for JavaScript interop. **Never use deprecated `dart:js_util`**.

## 3. Code Generation Best Practices 🛠️

### Generator Architecture

* **Generator Types:** Use `GeneratorForAnnotation<T>` for annotation-based generators
* **Builder Pattern:** Use `Builder` interface for file-based generators (e.g., TypeScript generation)
* **Error Handling:** Always throw `InvalidGenerationSourceError` for user-facing code generation errors with clear messages

### Analyzer API Usage

* **Element Access:**
  * Use `FunctionTypedElement.formalParameters` (not `MethodElement.parameters`) to access method parameters
  * Cast `MethodElement` to `FunctionTypedElement` to access parameters properly
  * Use `TypeChecker.fromUrl()` (not `TypeChecker.fromRuntime()`) for annotation checking
* **Type Checking:** Use `TypeChecker.fromUrl('package:package_name/file.dart#ClassName')` format for annotation type checking

### Code Generation Output

* **Formatting:** Generated code should be well-formatted and readable
* **Part Files:** Use `part of` directives for generated files that extend user code
* **Naming:** Generated classes should have clear, predictable naming (e.g., `_$ClassName` for implementations)

## 4. VSCode Extension Integration 🔌

### Webview Bridge

* **Platform Support:**
  * Implement web-specific bridge using modern `package:web` and `dart:js_interop`
  * Provide stub implementation for non-web platforms
  * Use conditional exports for platform-specific code
* **Message Handling:**
  * Convert Dart objects to JavaScript using JSON encoding/decoding
  * Use `JSON.parse` via JS interop for object conversion
  * Handle `acquireVsCodeApi()` availability gracefully

### TypeScript Generation

* **Handler Generation:** Generate TypeScript command handlers that match the Dart method signatures
* **Type Safety:** Maintain type safety between Dart and TypeScript interfaces
* **Command Resolution:** Generate code that can resolve VSCode API functions (e.g., `vscode.window.*`)

## 5. Error Handling & Testing 🧪

### Error Handling

* **Code Generation Errors:** Use `InvalidGenerationSourceError` for user-facing errors in generators
* **Runtime Errors:** Provide clear error messages for runtime issues in generated code
* **Graceful Degradation:** Handle missing APIs (like `acquireVsCodeApi`) gracefully

### Testing Strategy

* **Unit Tests:** Use **`package:test`** for pure Dart unit tests of generators
* **Generator Tests:** Test code generators by comparing expected output
* **Integration Tests:** Test the full code generation pipeline including build_runner integration

## 6. Package-Specific Considerations 📚

### Build Configuration

* **build.yaml:** Configure build_runner extensions properly
* **Part Files:** Use `.g.part` extension for generated part files
* **TypeScript Output:** Use `.handlers.ts` extension for generated TypeScript files

### API Design

* **Annotations:** Keep annotation classes simple and focused
  * `@VSCodeController` for marking controller classes
  * `@VSCodeCommand` for marking command methods
* **Base Classes:** Provide abstract base classes for generated implementations to extend
* **Factory Functions:** Provide factory functions for creating generated instances

### Documentation

* **README:** Maintain comprehensive README with usage examples
* **API Documentation:** Document all public APIs with clear examples
* **Code Examples:** Include working examples in the `example/` directory

