# 🇬🇧 ENGLISH / [🇮🇩 INDONESIA](./CONTRIBUTING-ID.md)

## VUR CONTRIBUTION GUIDE

Thanks for your interest in contributing to **VUR (Void User Repository)**.
This guide explains the branch workflow and template rules so your contribution can be reviewed quickly and parsed correctly by the index system.

## 1. BRANCH STRUCTURE

| Branch | Purpose | Who pushes |
|--------|---------|------------|
| `main` | Main (stable) branch. CI runs `vtools/generate.sh` here to **scan every template** and generate the index data: `index.json`, `packages.json`, `search.json`, `categories.json`. | Maintainers only |
| `dev` | Contribution branch. Where contributors add new **VUR templates** or fix existing ones. | Contributors, via Pull Request |

> ⚠️ **All Pull Requests must target `dev`, not `main`.**

## 2. CONTRIBUTION FLOW

```
Fork ─► Clone ─► Branch from dev ─► Add/edit template ─► Test build ─► Commit ─► Push ─► Pull Request to dev
```

```bash
# 1. Fork the repo on GitHub, then clone your fork
git clone https://github.com/<user>/vur.git
cd vur

# 2. Add the original repo as upstream
git remote add upstream https://github.com/T4n-Labs/vur.git
git fetch upstream

# 3. Create a working branch from dev (one branch per package)
git checkout -b add/<package-name> upstream/dev

# 4. Work on the template, test, commit, then push to your fork
git push origin add/<package-name>
```

Then open a **Pull Request** from your branch to `T4n-Labs/vur` → `dev`.

## 3. TEMPLATE LOCATION

Each package lives in its own folder inside one of the categories:

```
<category>/<package-name>/
├── template          # required
├── files/            # optional (extra files)
├── patches/          # optional (patches)
└── INSTALL, INSTALL.msg, REMOVE   # optional (hooks)
```

| Category | Contents |
|----------|----------|
| `core` | Base system components: init & services (e.g. `dinit`), kernels, base-system, installers. |
| `extra` | Additional applications and software. |
| `multilib` | 32-bit / multilib packages (e.g. `wine-pure`). |

The folder name **must match** `pkgname` inside `template`.

## 4. TEMPLATE RULES

VUR uses the `xbps-src` template format. The basics are covered in the [documentation](vdocs/DaftarISI.md) (Indonesian).

Besides the standard xbps-src fields (`build_style`, `license`, `distfiles`, `checksum`, etc.), the following fields are **read by `vtools/generate.sh`** and are required:

| Field | Description |
|-------|-------------|
| `pkgname` | Same as the folder name. |
| `version` | Literal version number, no variables. |
| `short_desc` | One-line short description. |
| `homepage` | Upstream project URL. |
| `maintainer` | Format `"Name <email>"`. |
| `distributor` | Format `"Name <email>"`. The person who distributes the template to VUR. |
| `archs` | **Optional.** Empty = all architectures. `x86_64*` expands to `x86_64` + `x86_64-musl`. |

The index is built with a simple parser (`grep "^field="`), so please:

- Put fields at the **start of the line** (no indentation), one assignment per line.
- Do **not** add a **comment on the same line** as a field (`version=1.0 # ...` breaks the output).
- Do not use double quotes `"` inside `short_desc`.
- Do not write `version` as an expression or variable.

## 5. TEST BEFORE SUBMITTING

```bash
# Make sure the VUR scanner detects your template
./vtools/scan.sh | grep <package-name>

# Test build with void-packages
git clone https://github.com/void-linux/void-packages.git
cd void-packages
./xbps-src binary-bootstrap
cp -r /path/to/vur/<category>/<package-name> srcpkgs/
./xbps-src pkg <package-name>

# Optional: lint the template (xtools package)
xlint srcpkgs/<package-name>/template
```

## 6. COMMIT MESSAGES

Use *conventional commits*:

```
feat(<category>): add <package-name> <version>
fix(<category>): update <package-name> to <version>
docs: <summary>
chore: <summary>
```

## 7. PULL REQUEST CHECKLIST

- [ ] PR targets the `dev` branch
- [ ] One PR = one package
- [ ] Template is in the correct category
- [ ] Local build succeeds (`./xbps-src pkg <package-name>`)
- [ ] `checksum` is correct and the source comes from the official upstream
- [ ] No hidden/obfuscated code in templates or scripts (all templates are audited)
- [ ] **Do not modify** `index.json`, `packages.json`, `search.json`, `categories.json`
- [ ] Do not modify `.github/workflows/` or `vtools/` without discussing with a maintainer

> The `*.json` files are generated automatically by **VUR Bot** and should only change on `main`.

## 8. NOTES FOR MAINTAINERS

1. Review and merge contributor PRs into `dev`.
2. When ready to release, merge `dev` → `main`.
3. A push to `main` triggers the workflow: `vtools/generate.sh` runs and VUR Bot commits `update vur index`.
4. Sync back so `dev` doesn't fall behind the bot's commits:

   ```bash
   git checkout dev
   git merge main
   git push origin dev
   ```

## HELP

Open an *issue* in this repository, or read the [VUR documentation](vdocs/DaftarISI.md) first.

<div align="center">

[@T4n-Labs](https://t4nlabs.web.id) · [@Gh0sT4n](https://gh0st4n.my.id)

</div>
