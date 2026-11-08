# NextinUtil

NextinUtil is a macOS command-line utility that exports the `proxies` section
from the Nextin application profile to a standalone YAML file.

## What it does

When run, the utility:

1. Reads the Nextin preferences property list at
   `~/Library/Group Containers/group.com.Tommy.Nextin/Library/Preferences/group.com.Tommy.Nextin.plist`.
2. Gets the `profile_string` value from the property list and parses it as YAML.
3. Writes only the `proxies` section to `~/Desktop/proxies.yaml`.

The destination file is created or overwritten. The application does not
currently accept command-line arguments or configurable input and output paths.

## Requirements

- macOS
- Swift 6.3 or later
- A Nextin profile available at the path above, with a valid `profile_string`
  containing a `proxies` section

The package uses [Yams](https://github.com/jpsim/Yams) to parse and serialize
YAML.

## Build and run

From the repository root:

```sh
swift build
swift run
```

On success, the program prints the path of the exported file. If the property
list, profile value, YAML, or `proxies` section is missing or invalid, it prints
an error instead. Ensure that `~/Desktop` exists and is writable.

## Tests

Run the Swift package test suite with:

```sh
swift test
```

## Project layout

```text
Sources/NextinUtil/ProxyExtractor.swift  # Executable implementation
Tests/NextinUtilTests/                   # Swift Testing target
Package.swift                            # Package and dependency configuration
```
