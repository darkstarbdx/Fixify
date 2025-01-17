#!/bin/bash

# Define text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file location
LOG_FILE="$HOME/system_update.log"

# Function to print headers
print_header() {
    echo -e "${BLUE}=======================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=======================================${NC}"
}

# Function to print a status message
print_status() {
    echo -e "${YELLOW}$1${NC}"
    echo "$1" >> "$LOG_FILE"
}

# Function to perform system update and clean old kernels
perform_update_and_clean() {
    print_header "System Update and Kernel Cleanup Initiated"
    echo "System Update started at $(date)" >> "$LOG_FILE"

    {
        print_status "Updating package list..."
        sudo apt update -y >> "$LOG_FILE" 2>&1

        print_status "Upgrading packages..."
        sudo apt upgrade -y >> "$LOG_FILE" 2>&1

        print_status "Performing full upgrade..."
        sudo apt full-upgrade -y >> "$LOG_FILE" 2>&1

        print_status "Performing distribution upgrade..."
        sudo apt dist-upgrade -y >> "$LOG_FILE" 2>&1

        print_status "Cleaning package cache..."
        sudo apt clean >> "$LOG_FILE" 2>&1

        print_status "Removing old package files..."
        sudo apt autoclean >> "$LOG_FILE" 2>&1

        print_status "Removing unnecessary packages..."
        sudo apt autoremove -y >> "$LOG_FILE" 2>&1

        print_status "Fixing broken dependencies..."
        sudo apt --fix-broken install >> "$LOG_FILE" 2>&1

        print_status "Checking for kernel cleanup..."
        sudo apt autoremove --purge -y >> "$LOG_FILE" 2>&1

        print_status "Generating update report..."
        echo "System Update finished at $(date)" >> "$LOG_FILE"
    } || {
        print_status "${RED}An error occurred during the update process. Check the log at $LOG_FILE.${NC}"
    }

    print_header "System Update and Kernel Cleanup Complete"
}

# Main script execution
while true; do
    clear
    print_header "Enhanced Linux System Maintenance Tool"
    echo -e "1. Update your System and Clean Old Kernels"
    echo -e "2. View update log"
    echo -e "3. Exit"
    echo -n "Choose option: "
    
    read -r option

    case $option in
        1)
            perform_update_and_clean
            read -p "Press [Enter] to continue..." ;;
        2)
            print_header "Update Log"
            cat "$LOG_FILE"
            read -p "Press [Enter] to continue..." ;;
        3)
            echo "Exiting..."
            exit 0 ;;
        *)
            echo -e "${RED}Invalid option. Please choose a valid option.${NC}"
            read -p "Press [Enter] to try again..." ;;
    esac
done
