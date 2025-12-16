FROM python:3.11-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (needed for MCP servers)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Copy project definition
COPY pyproject.toml uv.lock ./

# Install Python dependencies
# --frozen: ensure lockfile is up to date
# --no-dev: typically for production, but workshops might need dev tools? 
# The requirements.txt didn't seem to separate dev dependencies, so I will just use `uv sync`.
# Although `uv add` puts things in `dependencies` by default.
RUN uv sync --frozen

# Expose JupyterLab port
EXPOSE 8888

# Set environment variables
ENV JUPYTER_ENABLE_LAB=yes
ENV PYTHONUNBUFFERED=1
# Add venv to PATH
ENV PATH="/workspace/.venv/bin:$PATH"

# Create a non-root user
RUN useradd -m -s /bin/bash jupyter
# Ensure venv is accessible or owned by user?
# uv creates .venv in WORKDIR. We need to make sure jupyter user can access it.
# Simplest is to change ownership.
RUN chown -R jupyter:jupyter /workspace

USER jupyter

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
