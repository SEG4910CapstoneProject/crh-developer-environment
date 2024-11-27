#!/bin/bash

# Get the parent directory of the current directory
PARENT_DIR="$(dirname "$(pwd)")"

# Check if the parent directory exists
if [ ! -d "$PARENT_DIR" ]; then
  echo "Error: Parent directory '$PARENT_DIR' does not exist!"
  exit 1
fi

# Change to the parent directory
cd "$PARENT_DIR" || exit

# Loop through each subdirectory in the parent directory
for dir in */; do
  # Check if it's a Git repository (contains a .git directory)
  if [ -d "$dir/.git" ]; then
    # Change to the repository directory
    echo "Updating repository: $dir"
    cd "$dir" || continue

    # Ensure we're on the main branch and update it
    echo "Switching to main branch and pulling updates..."
    git checkout main  # Switch to the main branch
    git pull origin main  # Pull from the remote main branch

    # Check if the pull was successful
    if [ $? -eq 0 ]; then
      echo "Successfully updated the main branch in: $dir"
    else
      echo "Error updating repository: $dir"
    fi

    # Return to the parent directory
    cd "$PARENT_DIR" || exit
  else
    echo "Skipping non-Git directory: $dir"
  fi
done

echo "Done updating repositories."