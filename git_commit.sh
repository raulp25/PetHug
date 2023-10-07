#!/bin/bash

# Prompt for a commit message
echo "Enter your commit message:"
read commit_message

# Execute Git commands
git add .
git commit -m "$commit_message"
git push origin main
