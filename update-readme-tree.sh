#!/bin/bash

# Read configuration from readmetreerc.yml
if [ -f readmetreerc.yml ]; then
  file_names=$(grep -A5 "fileNames:" readmetreerc.yml | grep -v "fileNames:" | sed 's/^[ \t]*-[ \t]*//' | tr -d ' ')
  chapter=$(grep "chapter:" readmetreerc.yml | cut -d':' -f2 | tr -d ' ')
else
  file_names="README.md"
  chapter="Tree"
fi

# Generate tree and replace backticks with regular pipes
tree_output=$(tree -I ".git|node_modules|.github" --noreport --charset ascii . | sed "s/\`/|/g")

# Format the file_names variable
file_names=$(echo "$file_names" | tr ',' ' ')

# Update each file specified in the config
for file_name in $file_names; do
  if [ ! -f "$file_name" ]; then
    echo "File $file_name not found, skipping."
    continue
  fi
  
  # Create the final markdown tree block
  final_tree="## ${chapter}\n\`\`\`\n${tree_output}\n\`\`\`"
  
  # Update the file with the new tree structure
  if grep -q "^## ${chapter}" "$file_name"; then
    # Find the section and replace it
    awk -v chapter="$chapter" -v tree="$final_tree" '
    BEGIN {p=1; found=0}
    $0 ~ "^## "chapter"$" {print tree; p=0; found=1; next}
    $0 ~ /^## / && p==0 {p=1}
    p==1 {print}
    END {if (found==0) print "\n" tree}
    ' "$file_name" > "$file_name.new"
    mv "$file_name.new" "$file_name"
  else
    # If the section doesn't exist, add it at the end
    echo -e "\n${final_tree}" >> "$file_name"
  fi
done
