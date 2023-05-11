# Host2IP
<p align="center">
  <img src="https://github.com/Sic4rio/Host2IP/blob/main/ezgif-.gif?raw=true" width="600" height="500" />
</p>
>



Bash script to convert a .txt file of Domains/URL's to IP Addresses in a seperate .txt file 


```
#!/bin/bash
```
This line is called the shebang and specifies the interpreter to be used for executing the script, in this case, /bin/bash.

```
# Check if an argument was provided
if [ $# -eq 0 ]; then
  echo "Please provide a .txt file as an argument."
  exit 1
fi

input_file="$1"
output_file="Host-IP.txt"
```
These lines check if an argument (the input file) was provided when running the script. If no argument is provided, it displays an error message and exits the script with a non-zero status. The provided argument is assigned to the input_file variable, and the output_file variable is set to "Host-IP.txt".

```

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file not found: $input_file"
  exit 1
fi

```
This section checks if the input file exists. If the file does not exist, it displays an error message and exits the script.

```
# Create an empty output file
> "$output_file"
```
This line creates an empty output file or overwrites the existing file if it already exists.

```

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
```
This is the main loop that reads each line from the input file and resolves the IP address for the corresponding URL. Here's what it does:

    The IFS= read -r line command reads a line from the input file and stores it in the line variable.
    The sed command removes any leading and trailing spaces from the line to ensure accurate parsing.
    The awk commands extract the URL and netmask from the line. It assumes that the URL is the first field and the netmask is the second field.
    The resolved IP address is obtained by removing the "http://" or "https://" prefix from the URL and passing it to the host command. The output of host is then filtered using awk to extract the IP address.
    If an IP address is successfully resolved, it is echoed to the console and appended to the output file using >>.
    If the IP address resolution fails, an error message is displayed.

```

# Remove the lines with "Failed to resolve" from the output file
sed -i '/Failed to resolve/d' "$output_file"
```
This line uses the sed command to remove all lines containing "Failed to resolve" from the output file. The -i flag allows in-place editing of the file, and the /Failed to resolve/d command deletes the matching lines.

That's the explanation of the script. 
# To use it, follow these steps:

   1. Open a text editor and copy the script into a new file.
   2. Save the file with a .sh extension, for example, resolve_ips.sh.
   3. Open a terminal or command prompt and navigate to the directory where the script file is saved.
   5. Run the script by executing the command: bash resolve_ips.sh input_file.txt.
   6. Replace input_file.txt with the path to your actual input file containing the URLs and netmasks.

The script will resolve the IP addresses for each URL in the input file and save the results in the Host-IP.txt file in the same directory. The lines with "Failed to resolve" will be excluded from the output file.

  7. After running the script, you can check the Host-IP.txt filed to view the resolved IP addresses.

Note: Make sure you have proper permissions to execute the script and that the necessary networking dependencies are installed on your system.
