#!/bin/bash

# Configuration file for storing profiles
CONFIG_FILE="$HOME/.lutty_profiles"

# Ensure config file exists
touch "$CONFIG_FILE"

# Function to list saved profiles
list_profiles() {
    echo ""
    if [[ ! -s "$CONFIG_FILE" ]]; then
        echo "No saved profiles found."
        echo ""
        return
    fi
    echo "Saved Profiles:"
    awk -F ',' '{print NR ") " $1 " (" $2 ")"}' "$CONFIG_FILE"
    echo ""
}

# Function to add a new profile
add_profile() {
    echo ""
    echo "Enter profile name:"
    read -r profile_name
    echo "Enter username:"
    read -r username
    echo "Enter host (IP or domain):"
    read -r host
    echo "Enter port (default 22):"
    read -r port
    port=${port:-22}
    
    echo "$profile_name,$username,$host,$port" >> "$CONFIG_FILE"
    echo "Profile '$profile_name' added!"
    echo ""
}

# Function to remove a profile
remove_profile() {
    echo ""
    list_profiles
    echo "Enter the profile number to delete:"
    read -r profile_num
    sed -i "${profile_num}d" "$CONFIG_FILE"
    echo "Profile removed!"
    echo ""
}

# Function to connect via SSH using a saved profile
connect_profile() {
    echo ""
    list_profiles
    echo "Enter the profile number to connect:"
    read -r profile_num
    profile=$(sed -n "${profile_num}p" "$CONFIG_FILE")
    
    if [[ -z "$profile" ]]; then
        echo "Invalid profile number!"
        echo ""
        return
    fi
    
    IFS=',' read -r profile_name username host port <<< "$profile"

    echo "Do you want to enable session logging? (y/n)"
    read -r logging
    log_option=""
    if [[ "$logging" == "y" ]]; then
        log_file="$HOME/lutty_logs/${profile_name}_$(date +%F_%T).log"
        mkdir -p "$HOME/lutty_logs"
        log_option="-o LogLevel=VERBOSE -o UserKnownHostsFile=$log_file"
        echo "Logging enabled at $log_file"
    fi

    echo ""
    echo "Connecting to $profile_name ($host)..."
    echo ""
    ssh -p "$port" $log_option "$username@$host"
    echo ""
}

# Menu system
while true; do
    echo ""
    echo "==============================="
    echo "           LUTTY               "
    echo "       PuTTY for Linux"
    echo "==============================="
    echo "1) List Profiles"
    echo "2) Add Profile"
    echo "3) Remove Profile"
    echo "4) Connect to Profile"
    echo "5) Exit"
    echo "==============================="
    echo "Enter your choice:"
    read -r choice
    echo ""

    case $choice in
        1) list_profiles ;;
        2) add_profile ;;
        3) remove_profile ;;
        4) connect_profile ;;
        5) echo "Goodbye!"; echo ""; exit 0 ;;
        *) echo "Invalid choice, please try again."; echo "" ;;
    esac
done
