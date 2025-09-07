#!/bin/bash

if [[ -d venv ]]; then
    echo "Activating 'venv' virtual environment..."
    source venv/bin/activate
elif [[ -d .venv ]]; then
    echo "Activating '.venv' virtual environment..."
    source .venv/bin/activate
else 
    echo "Creating 'venv' virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    echo "Installing requirements..."
    pip install -r requirements.txt
fi

# Export environment variables
export PYTHONPATH=$(pwd)
export FLASK_APP=app/main.py

# Run tests
pytest tests/
