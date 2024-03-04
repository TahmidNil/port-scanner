#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

# Input file containing the list of host names
input_file="$1"

# Output file
output_file="results_naabu.txt"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: Input file $input_file not found."
  exit 1
fi

# Read the list of host names from the file into an array
mapfile -t hosts < "$input_file"

# Iterate through the array and perform port scanning with naabu
for host in "${hosts[@]}"; do
  echo "Scanning ports on $host"
  
  # Remove "https://" prefix from the host name
  host_without_https=$(echo "$host" | sed 's#^https://##')
  
  # Perform port scanning with naabu, including only top 1000 ports and excluding 80, 443
  result=$(naabu -host "$host_without_https" -top-ports 1000 -exclude-ports 80,443)
  
  # Check if ports were found
  if [[ ! -z "$result" ]]; then
    echo "$result" >> "$output_file"
    echo "---------------------------" >> "$output_file"
  else
    echo "No ports found for $host"
  fi
done

echo "Scan results have been saved to $output_file"

