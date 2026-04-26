# Build-Style

**build-style** is a variable within a package template file that specifies the automated build method or script to be used to compile and install software. It simplifies package creation by using standard templates for various common build systems, such as `gnu-configure`, `cmake`, `python3`, or `go`.

Key Points about build-style:

- Automation: By specifying a **build-style** (e.g., build-style=cmake), **xbps-src** automatically handles the configure, build, and install steps without the need to manually write commands in the template file.
- Standardization: Ensures packages are built consistently according to Void Linux standards.
- Customization: If a package requires a specific step not covered by the standard **build-style**, the packager can omit it and define their own **do_build()** function.