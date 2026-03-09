FROM openclaw-python-runner

USER root

RUN apt-get update && apt-get install -y \
    sqlite3 \
    nodejs \
    npm \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --break-system-packages --no-cache-dir \
    pytest \
    ruff \
    mypy \
    pip-audit

RUN npm install -g pyright