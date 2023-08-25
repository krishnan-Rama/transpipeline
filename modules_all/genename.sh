#!/bin/bash

input_file="UPIMAPI_results.tsv"
output_file="Gene_names.tsv"

# Read the input TSV file into an array of lines
mapfile -t lines < "$input_file"

# Loop through each line and remove hyphens
for ((i=0; i<${#lines[@]}; i++)); do
    lines[i]="${lines[i]//-/}"
done

# Write the modified lines to the output file
printf "%s\n" "${lines[@]}" > "$output_file"

