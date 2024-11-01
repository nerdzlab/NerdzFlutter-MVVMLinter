# MVVM Linter

The MVVM Linter is a tool designed to enforce best practices and coding standards in MVVM (Model-View-ViewModel) architecture within your projects. It provides a set of rules and guidelines to help maintain code quality, readability, and consistency.

## Features

- **Member Order**: Enforces a specified order for class members.

## Installation

To install the MVVM Linter, follow these steps:

1. Add the following dependencies to your `pubspec.yaml`:

```bash
flutter pub add --dev custom_lint mvvm_linter
```

2. Update your `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins:
    - custom_lint
custom_lint:
  rules:
    - mvvm_linter
```
