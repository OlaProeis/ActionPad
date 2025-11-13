#!/bin/bash
# Helper script for Shortcut Widget to execute commands
# This is installed with the widget and provides command execution capability

MODE="$1"
shift

case "$MODE" in
    terminal)
        # Run command in terminal
        konsole -e bash -c "$*; echo ''; echo 'Press Enter to close...'; read" &
        ;;
    background)
        # Run command in background
        (eval "$*") &
        ;;
    *)
        echo "Usage: $0 {terminal|background} <command>"
        exit 1
        ;;
esac

