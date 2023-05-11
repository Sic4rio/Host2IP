#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
  echo "Please provide a .txt file as an argument."
  exit 1
fi

input_file="$1"
output_file="Host-IP.txt"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file not found: $input_file"
  exit 1
fi

# Create an empty output file
> "$output_file"

# Resolve IP addresses from each line in the input file
while IFS= read -r line; do
  # Remove leading and trailing spaces from the line
  line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # Split the line into URL and netmask
  url=$(echo "$line" | awk '{print $1}')
  netmask=$(echo "$line" | awk '{print $2}')

  echo "Resolving: $url"

  # Remove "http://" or "https://" from the beginning of the URL
  url_without_prefix=$(echo "$url" | sed -e 's,http://,,;s,https://,,')

  ip=$(host "$url_without_prefix" | awk '/has address/ {print $4; exit}')
  if [ -n "$ip" ]; then
    echo "IP address: $ip"
    echo "$ip" >> "$output_file"
  else
    echo "Failed to resolve IP address for: $url"
  fi

done < "$input_file"

# Remove the lines with "Failed to resolve" from the output file
sed -i '/Failed to resolve/d' "$output_file"

echo "Output saved in $output_file"
