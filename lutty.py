import os
import curses
import time

CONFIG_FILE = os.path.expanduser("~/.lutty_profiles")
os.makedirs(os.path.dirname(CONFIG_FILE), exist_ok=True)
open(CONFIG_FILE, 'a').close()  # Ensure the file exists

LOGO_FILE = "Logo.txt"

def read_logo():
    if os.path.exists(LOGO_FILE):
        with open(LOGO_FILE, 'r') as file:
            return file.readlines()
    return []

def display_logo(stdscr):
    logo_lines = read_logo()
    h, w = stdscr.getmaxyx()
    start_y = (h - len(logo_lines)) // 2  # Center vertically
    for i, line in enumerate(logo_lines):
        stdscr.addstr(start_y + i, (w - len(line.strip())) // 2, line.strip(), curses.A_BOLD)

def read_profiles():
    """Reads stored profiles from the configuration file."""
    with open(CONFIG_FILE, 'r') as file:
        return [line.strip().split(',') for line in file if line.strip()]

def write_profiles(profiles):
    """Writes profiles back to the configuration file."""
    with open(CONFIG_FILE, 'w') as file:
        for profile in profiles:
            file.write(','.join(profile) + '\n')

def list_profiles(stdscr):
    stdscr.clear()
    profiles = read_profiles()
    stdscr.addstr(2, 2, "Saved Profiles:", curses.A_BOLD)
    if not profiles:
        stdscr.addstr(4, 2, "No saved profiles found.")
    else:
        for i, (name, user, host, port) in enumerate(profiles):
            stdscr.addstr(4 + i, 2, f"{i + 1}) {name} ({user}@{host}:{port})")
    stdscr.refresh()
    stdscr.getch()

def add_profile(stdscr):
    curses.echo()
    stdscr.clear()
    stdscr.addstr(2, 2, "Add New Profile", curses.A_BOLD)
    
    stdscr.addstr(4, 2, "Profile Name: ")
    profile_name = stdscr.getstr().decode('utf-8')
    
    stdscr.addstr(5, 2, "Username: ")
    username = stdscr.getstr().decode('utf-8')
    
    stdscr.addstr(6, 2, "Host (IP or domain): ")
    host = stdscr.getstr().decode('utf-8')
    
    stdscr.addstr(7, 2, "Port (default 22): ")
    port = stdscr.getstr().decode('utf-8') or '22'
    
    with open(CONFIG_FILE, 'a') as file:
        file.write(f"{profile_name},{username},{host},{port}\n")
    
    stdscr.addstr(9, 2, "Profile added successfully!")
    stdscr.refresh()
    time.sleep(1)

def connect_profile(stdscr):
    stdscr.clear()
    profiles = read_profiles()
    if not profiles:
        stdscr.addstr(2, 2, "No profiles available to connect.")
        stdscr.refresh()
        time.sleep(1)
        return
    
    list_profiles(stdscr)
    stdscr.addstr(len(profiles) + 5, 2, "Enter profile number to connect: ")
    curses.echo()
    try:
        choice = int(stdscr.getstr().decode('utf-8')) - 1
        if 0 <= choice < len(profiles):
            name, user, host, port = profiles[choice]
            stdscr.clear()
            stdscr.addstr(2, 2, f"Connecting to {name} ({user}@{host}:{port})...\n")
            stdscr.refresh()
            time.sleep(1)
            curses.endwin()  # End curses mode before running ssh
            os.system(f"ssh -p {port} {user}@{host}")
        else:
            stdscr.addstr(len(profiles) + 7, 2, "Invalid selection!")
    except ValueError:
        stdscr.addstr(len(profiles) + 7, 2, "Invalid input!")
    stdscr.refresh()
    time.sleep(1)

def remove_profile(stdscr):
    stdscr.clear()
    profiles = read_profiles()
    if not profiles:
        stdscr.addstr(2, 2, "No profiles available to remove.")
        stdscr.refresh()
        time.sleep(1)
        return
    
    list_profiles(stdscr)
    stdscr.addstr(len(profiles) + 5, 2, "Enter profile number to remove: ")
    curses.echo()
    
    try:
        choice = int(stdscr.getstr().decode('utf-8')) - 1
        if 0 <= choice < len(profiles):
            profiles.pop(choice)  # Remove selected profile
            write_profiles(profiles)  # Save updated profiles back to file
            stdscr.addstr(len(profiles) + 7, 2, "Profile removed successfully!")
        else:
            stdscr.addstr(len(profiles) + 7, 2, "Invalid selection!")
    except ValueError:
        stdscr.addstr(len(profiles) + 7, 2, "Invalid input!")
    stdscr.refresh()
    time.sleep(1)

def draw_menu(stdscr):
    curses.curs_set(0)
    stdscr.clear()
    menu_items = ["List Profiles", "Add Profile", "Remove Profile", "Connect to Profile", "Exit"]
    current_row = 0
    
    while True:
        stdscr.clear()
        display_logo(stdscr)
        h, w = stdscr.getmaxyx()
        menu_start_y = (h + len(read_logo())) // 2  # Position below logo
        
        for i, item in enumerate(menu_items):
            x = (w - len(item)) // 2
            y = menu_start_y + i
            if i == current_row:
                stdscr.attron(curses.A_REVERSE)
                stdscr.addstr(y, x, item)
                stdscr.attroff(curses.A_REVERSE)
            else:
                stdscr.addstr(y, x, item)
        
        stdscr.refresh()
        key = stdscr.getch()
        
        if key == curses.KEY_UP and current_row > 0:
            current_row -= 1
        elif key == curses.KEY_DOWN and current_row < len(menu_items) - 1:
            current_row += 1
        elif key in (curses.KEY_RIGHT, curses.KEY_ENTER, 10, 13):
            if current_row == 0:
                list_profiles(stdscr)
            elif current_row == 1:
                add_profile(stdscr)
            elif current_row == 2:
                remove_profile(stdscr)
            elif current_row == 3:
                connect_profile(stdscr)
            elif current_row == 4:
                break

if __name__ == "__main__":
    curses.wrapper(draw_menu)
