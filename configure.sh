#!/bin/bash
set -eu

# Load all common functions
source ./common_functions.sh

# ---------------------------------------------------------------------------------------------
# Old and new variables
# ---------------------------------------------------------------------------------------------
# Original names
OLD_MODULE_NAME_LOWER_CASE='template'
OLD_MODULE_NAME_CAPITALIZED='Template'
OLD_REPO_NAME="python-project-template"
OLD_REPO_OWNER="kevin-de-koninck"
OLD_GITHUB_TOKEN_FILE="/Users/kevin/GH_TOKEN.txt"

# New names
MODULE_NAME="$(get_value_from_section_in_config_file "META" "MODULE_NAME")"
REPO_NAME="$(basename $(git rev-parse --show-toplevel))"
REPO_OWNER="$(get_value_from_section_in_config_file "META" "REPO_OWNER")"
GITHUB_TOKEN_FILE="$(get_value_from_section_in_config_file "META" "GITHUB_TOKEN_FILE")"

# ---------------------------------------------------------------------------------------------
# The main functionality
# ---------------------------------------------------------------------------------------------

print_info "Renaming variables and files..."
MODULE_LOWERCASE="$(echo "${MODULE_NAME}" | awk '{print tolower($0)}')"
MODULE_CAPITALIZED="$(tr '[:lower:]' '[:upper:]' <<< ${MODULE_LOWERCASE:0:1})${MODULE_LOWERCASE:1}"
git grep -l "${OLD_MODULE_NAME_LOWER_CASE}" | xargs sed -i '' -e "s/${OLD_MODULE_NAME_LOWER_CASE}/${MODULE_LOWERCASE}/g"
git grep -l "${OLD_MODULE_NAME_CAPITALIZED}" | xargs sed -i '' -e "s/${OLD_MODULE_NAME_CAPITALIZED}/${MODULE_CAPITALIZED}/g"
git grep -l "${OLD_REPO_NAME}" | xargs sed -i '' -e "s/${OLD_REPO_NAME}/${REPO_NAME}/g"
git grep -l "${OLD_REPO_OWNER}" | xargs sed -i '' -e "s/${OLD_REPO_OWNER}/${REPO_OWNER}/g"
git grep -l "${OLD_GITHUB_TOKEN_FILE}" | xargs sed -i '' -e "s|${OLD_GITHUB_TOKEN_FILE}|${GITHUB_TOKEN_FILE}|g"
git mv "${OLD_MODULE_NAME_LOWER_CASE}" "${MODULE_LOWERCASE}"

print_info "Removing the badges from the README.md file"
sed -i '' -e 1,11d README.md

print_info "Testing if everything works by building the development container and running the integrated test stage..."
if ! ./build.sh --project dev --clean; then
  print_error "Building and testing the development container failed. Please investigate and fix manually..."
fi

print_info "Adding all changes to a new commit..."
git add -u 
git commit -m "Initialize project"

print_info "All changes are inside the local commit 'Initialize project'. Use 'git push' to push these changes. This will trigger the github action."
print_info "You can now safely remove this script by running 'rm -f '${0}'."
print_info "Have fun!"
exit 0

