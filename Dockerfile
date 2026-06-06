FROM node:22-slim

# git is commonly needed by Claude Code for repo operations; add other
# tools your projects rely on here (python3, build-essential, etc.)
RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code globally. Kept early so this layer caches well.
RUN npm install -g @anthropic-ai/claude-code

WORKDIR /workspace

ENTRYPOINT ["claude"]
