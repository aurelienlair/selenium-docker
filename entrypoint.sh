#!/bin/bash

source .venv/bin/activate

export PATH="$HOME/.local/bin:$PATH"

exec "$@"
