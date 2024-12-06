#!/bin/bash

# Target word and replacement word
TARGET_WORD="comma"
REPLACEMENT_WORD="kommu"

# Function to process each file for content replacement
process_file_content() {
  local file="$1"

  # Check if the file contains the target word
  if grep -q "$TARGET_WORD" "$file"; then
    echo -e "\nThe word '$TARGET_WORD' was found in: $file"
    
    # Display a snippet of the file for context
    echo "Context from file:"
    grep -C 3 "$TARGET_WORD" "$file"
    
    # Perform replacement without creating a backup
    sed -i "s/$TARGET_WORD/$REPLACEMENT_WORD/g" "$file"
    echo "Replaced in $file."
    
  else
    echo "No occurrences of '$TARGET_WORD' in: $file"
  fi
}

# Function to rename files and directories containing the target word
rename_file_or_dir() {
  local path="$1"
  local base_name="$(basename "$path")"
  local dir_name="$(dirname "$path")"

  # Check if the file/directory name contains the target word
  if [[ "$base_name" == *"$TARGET_WORD"* ]]; then
    local new_name="${base_name//$TARGET_WORD/$REPLACEMENT_WORD}"
    local new_path="$dir_name/$new_name"

    # Ask for user confirmation
    echo -e "\nFound file/directory: $path"
    mv "$path" "$new_path"
    echo "Renamed $path to $new_path."
  fi
}

# Start directory (default to current directory)
start_dir="${1:-.}"

# Check if the specified directory exists
if [[ ! -d "$start_dir" ]]; then
  echo "Error: Directory $start_dir does not exist."
  exit 1
fi

# First rename files/directories, then process file contents
find "$start_dir" -depth -print0 | while IFS= read -r -d '' path; do
  if [[ -f "$path" ]]; then
    process_file_content "$path"
  fi
  rename_file_or_dir "$path"
done

echo -e "\nDone."
