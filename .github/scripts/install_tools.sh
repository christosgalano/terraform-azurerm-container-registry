#!/bin/bash

function install_terraform() {
  latest_version=$(wget --quiet -O - "https://api.github.com/repos/hashicorp/terraform/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-)
  arch=$(get_arch)
  curl -k https://releases.hashicorp.com/terraform/"$latest_version"/terraform_"${latest_version}"_linux_"${arch}".zip -o terraform.zip
  unzip terraform.zip
  sudo mv terraform /usr/bin
  rm terraform.zip
}

function install_terraform_docs() {
  latest_version=$(get_latest_version "terraform-docs" "terraform-docs")
  arch=$(get_arch)
  curl -sL "https://github.com/terraform-docs/terraform-docs/releases/download/$latest_version/terraform-docs-${latest_version}-linux-${arch}.tar.gz" -o terraform-docs.tar.gz
  mkdir -p terraform-docs && tar -xzf terraform-docs.tar.gz --directory terraform-docs
  chmod +x ./terraform-docs/terraform-docs
  sudo mv ./terraform-docs/terraform-docs /usr/bin
  rm -rf terraform-docs.tar.gz terraform-docs
}

function install_tflint() {
  latest_version=$(get_latest_version "terraform-linters" "tflint")
  arch=$(get_arch)
  curl -sL "https://github.com/terraform-linters/tflint/releases/download/$latest_version/tflint_linux_${arch}.zip" -o tflint.zip
  unzip tflint.zip
  sudo mv tflint /usr/bin
  rm tflint.zip
}

function install_checkov() {
  sudo pip3 install checkov
  sudo mv /usr/local/bin/checkov /usr/bin
}

function install_trivy() {
  latest_version=$(get_latest_version "aquasecurity" "trivy")
  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/bin "$latest_version"
}

# Main
function main() {
  # Instead of - use _ for readability.
  # For example: terraform_docs and install_terraform_docs instead of terraform-docs and install_terraform-docs
  programs=(terraform tflint checkov trivy)
  missing_programs=()
  for program in "${programs[@]}"; do
    if ! command -v "$program" >/dev/null 2>&1; then
      missing_programs+=("$program")
    fi
  done

  if [[ ${#missing_programs[@]} -eq 0 ]]; then
    printf "\n\nAll programs are installed.\n\n"
  else
    printf "\n\nThe following programs are missing and will be installed: %s\n\n" "${missing_programs[*]}"
    for program in "${missing_programs[@]}"; do
      install_function="install_$program"
      $install_function
    done
    wait
  fi
}

# Utility functions
# Usage: get_latest_version <owner> <repo>
function get_latest_version() {
  curl -s "https://api.github.com/repos/$1/$2/releases/latest" | jq -r .tag_name
}

function get_arch() {
  arch=""
  if [ "$(uname -m)" = "x86_64" ]; then
    arch="amd64"
  elif [ "$(uname -m)" = "aarch64" ]; then
    arch="arm64"
  fi
  echo $arch
}

# Run the main function
main
