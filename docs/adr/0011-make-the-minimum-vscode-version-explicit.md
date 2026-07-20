---
status: accepted
---

# Make the Minimum VS Code Version Explicit

Every Extension Project will declare a Project API Target in Dart-owned
configuration. The Binding Pipeline will expose the stable API surface for that
target and generate the matching `engines.vscode` declaration as a
Framework-Managed Artifact.

An Extension Author must explicitly raise the Project API Target before using
a capability introduced by a newer VS Code release. Framework upgrades will
not silently raise it. This makes compatibility failures visible at development
time and prevents routine tool upgrades from unexpectedly excluding Extension
Users with older VS Code installations.
