#!/bin/bash

# Directory containing the Blogger HTML files
SOURCE_DIR="_posts"

# Loop through all HTML files in the source directory
for file in $(ls "$SOURCE_DIR" | grep md); do
    file=_posts.new/$file
    # Define output Markdown file
    output="${file}.md"
    
    # Start creating new front matter
    echo "---" > "$output"
    
    # Read the original file line by line
    while IFS= read -r line || [[ -n $line ]]; do
        case "$line" in
            *title:*) 
                title=$(echo "$line" | sed 's/^.*title: *\(.*\)$/\1/')
                echo "title: \"$title\"" >> "$output"
                ;;
            *date:*)
                date=$(echo "$line" | sed 's/^.*date: *\(.*\)$/\1/')
                echo "date: $date" >> "$output"
                ;;
            *tags:*)
                echo "categories: [news]" >> "$output"
                ;;
            *thumbnail:*)
                thumbnail=$(echo "$line" | sed 's/^.*thumbnail: *\(.*\)$/\1/')
                echo "image: $thumbnail" >> "$output"
                ;;
            *else)
                echo "---" >> "$output"
                break
                ;;
        esac
    done < "$file"
    
    # Append remaining content below front matter
    awk '/^<\!--/{p=1; next} p' "$file" >> "$output"
    
    echo "Converted $file to $output"
done
