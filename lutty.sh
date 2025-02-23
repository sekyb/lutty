#!/bin/bash

# Logo
clear
cat Logo.txt 

# Adding Sleep delay to make logo visable
sleep 1.2

# Configuration file for storing profiles
CONFIG_FILE="$HOME/.lutty_profiles"

# Ensure config file exists
touch "$CONFIG_FILE"

# Function to get terminal size
get_term_size() {
    rows=$(tput lines)
    cols=$(tput cols)
}

# Function to center text
center_text() {
    local text="$1"
    local width=${#text}
    local padding=$(( (cols - width) / 2 ))
    printf "%*s%s%*s\n" "$padding" "" "$text" "$padding" ""
}

# Function to draw a menu box dynamically
draw_menu() {
    get_term_size
    clear
    local box_width=40
    local box_height=10
    local start_col=$(( (cols - box_width) / 2 ))
    local start_row=$(( (rows - box_height) / 2 ))

    tput cup "$start_row" "$start_col"; echo "╔══════════════════════════════╗"
    tput cup $((start_row + 1)) "$start_col"; echo "║          LUTTY               ║"
    tput cup $((start_row + 2)) "$start_col"; echo "║      PuTTY for Linux         ║"
    tput cup $((start_row + 3)) "$start_col"; echo "╠══════════════════════════════╣"
    tput cup $((start_row + 4)) "$start_col"; echo "║ 1) List Profiles             ║"
    tput cup $((start_row + 5)) "$start_col"; echo "║ 2) Add Profile               ║"
    tput cup $((start_row + 6)) "$start_col"; echo "║ 3) Remove Profile            ║"
    tput cup $((start_row + 7)) "$start_col"; echo "║ 4) Connect to Profile        ║"
    tput cup $((start_row + 8)) "$start_col"; echo "║ 5) Exit                      ║"
    tput cup $((start_row + 9)) "$start_col"; echo "╚══════════════════════════════╝"

    tput cup $((start_row + 11)) "$start_col"
    printf "Enter your choice: "
}

# Function to list saved profiles
list_profiles() {
    clear
    get_term_size  # Get terminal size dynamically
    local start_row=3  # Start listing profiles from row 3

    center_text "Saved Profiles"
    echo ""

    # Check if there are no profiles
    if [[ ! -s "$CONFIG_FILE" ]]; then
        center_text "No saved profiles found."
        sleep 1
        return
    fi

    # Read and display profiles from the configuration file
    local count=0
    while IFS=',' read -r profile_name username host port; do
        count=$((count + 1))
        tput cup $((start_row + count)) 5  # Move to the next line dynamically
        echo "$count) $profile_name ($username@$host:$port)"
    done < "$CONFIG_FILE"

    echo ""
    sleep 1
}

# Function to add a new profile
add_profile() {
    clear
    center_text "Add New Profile"
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
    sleep 1
}

# Function to remove a profile
remove_profile() {
    clear
    list_profiles
    echo "Enter the profile number to delete:"
    read -r profile_num
    sed -i "${profile_num}d" "$CONFIG_FILE"
    echo "Profile removed!"
    sleep 1
}

# Function to connect via SSH using a saved profile
connect_profile() {
    clear
    list_profiles
    echo "Enter the profile number to connect, or 'e' to exit to main menu:"
    read -r profile_num

    # Check if user wants to exit to the main menu
    if [[ "$profile_num" == "e" ]]; then
        return
    fi

    profile=$(sed -n "${profile_num}p" "$CONFIG_FILE")
    
    if [[ -z "$profile" ]]; then
        echo "Invalid profile number!"
        sleep 1
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
    sleep 1
    ssh -p "$port" $log_option "$username@$host"
}

# Menu system
while true; do
    draw_menu
    read -r choice

    case $choice in
        1) list_profiles ;;
        2) add_profile ;;
        3) remove_profile ;;
        4) connect_profile ;;
        5) clear; echo "Goodbye!"; exit 0 ;;
        *) clear; echo "Invalid choice, please try again."; sleep 1 ;;
    esac
done
