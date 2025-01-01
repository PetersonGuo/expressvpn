#!/bin/bash
set -e

# Base URL for ExpressVPN Linux download page
base_url="https://www.expressvpn.com/latest#linux"

# Check if required tools are installed
command -v curl >/dev/null 2>&1 || { echo "Error: curl is not installed. Exiting."; exit 1; }
command -v dpkg >/dev/null 2>&1 || { echo "Error: dpkg is not installed. Exiting."; exit 1; }

# Fetch the latest version dynamically
echo "Fetching ExpressVPN download page..."
html=$(curl -s "$base_url")

# Extract the .deb download URL
latest_url=$(echo "$html" | grep -oP 'https://www\.expressvpn\.works/clients/linux/expressvpn_[^"]*\.deb' | head -n 1)

# Validate the extracted URL
if [[ -z "$latest_url" ]]; then
  echo "Error: Unable to find the latest ExpressVPN download URL."
  exit 1
fi

# Extract the file name from the URL
file_name=$(basename "$latest_url")

# Download the latest version
echo "Downloading ExpressVPN from: $latest_url"
curl -O "$latest_url"

# Install the downloaded .deb package
echo "Installing ExpressVPN package: $file_name"
dpkg -i "$file_name" || apt-get install -f -y || { echo "Error: Failed to install ExpressVPN. Exiting."; exit 1; }

rm -rf *.deb

# Clean up the downloaded file
echo "Cleaning up downloaded package: $file_name"
rm -f "$file_name"

echo "ExpressVPN installation completed successfully!"

