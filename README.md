# Claude Code in Docker

Run Claude Code in an isolated container that can only see the folders you
explicitly mount — the rest of your machine stays out of reach.

## Layout

```
claude-code-docker/
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── workspace/          <- your active project (mounted read-write)
└── shared/
    ├── reference/      <- mounted read-only at /mnt/reference
    └── data/           <- mounted read-write at /mnt/data
```

## First-time setup

```bash
# 1. Create the folders that get mounted in
mkdir -p workspace shared/reference shared/data .claude-config

# 2. (Optional) set up token auth — otherwise you'll log in interactively
cp .env.example .env        # then edit .env, or just leave it blank

# 3. Build the image
docker compose build
```

## Running

```bash
docker compose run --rm claude-code
```

`run` (not `up`) is correct here because Claude Code is an interactive
session, not a long-running service. `--rm` cleans up the container when
you exit; your mounted folders persist on the host.

To resume a previous conversation:

```bash
docker compose run --rm claude-code --continue
```

## How the isolation works

The container's filesystem is its own. It can only reach host folders that
appear in the `volumes:` list in `docker-compose.yml`. Everything else on
your machine — home directory, other projects, system files — is invisible
to it.

To expose another folder, add a line under `volumes:`:

```yaml
- /path/on/your/host:/mnt/somename       # read-write
- /path/on/your/host:/mnt/somename:ro    # read-only
```

The `:ro` suffix makes a mount read-only — good for reference material you
want Claude Code to read but never modify.

## Notes

- Don't mount secrets (`~/.ssh`, cloud credential files) into the container.
  Prefer the short-lived OAuth token in `.env`.
- The `.claude-config/` folder stores your login so you only authenticate
  once. Add it (and `.env`) to `.gitignore` if this folder is a repo.
- Edit the `Dockerfile` to add language runtimes or tools your projects need.

# Misc