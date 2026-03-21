# Global Claude Code Instructions

## System Dependencies

When asked to install a system dependency (anything that would normally use `apt install ...`), **do not run `apt install` directly**. Instead, manage it via [apt-bundle](https://apt-bundle.org/aptfile-format.html) by updating the system-wide Aptfile at `~/devel/etc/Aptfile`.

### Aptfile format

Each non-empty, non-comment line is a directive followed by an argument:

```
# Install a package (optionally pin a version)
apt <package-name>[=<version>]

# Add a PPA (handles GPG automatically)
ppa ppa:<user>/<repo>

# Add a custom apt repository
deb "<full-repository-line>"

# Add a GPG key (downloaded to /etc/apt/trusted.gpg.d/)
key <url-to-key>
```

Processing order when apt-bundle runs: keys → PPAs → deb repos → `apt-get update` → package installs.

### Workflow

1. Open `~/devel/etc/Aptfile` (create it if it doesn't exist).
2. Add the appropriate directive(s) for the required dependency.
3. Inform the user to apply changes by running `apt-bundle` (or equivalent) against the Aptfile.
4. Only fall back to direct `apt install` if there is a clear reason apt-bundle cannot satisfy the requirement, and explain why.
