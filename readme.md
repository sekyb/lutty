# Lutty: A Terminal SSH Profile Manager

Lutty is a simple terminal-based SSH profile manager built in Python using `curses`. It allows users to manage, connect, and configure SSH profiles. The application provides an easy-to-use interface to list, add, remove, and connect to SSH profiles, making SSH management more accessible from the terminal.

## Features

- **List Profiles**: View all stored SSH profiles with details (name, username, host, port).
- **Add Profile**: Add a new SSH profile with a name, username, host, and port.
- **Remove Profile**: Remove an existing profile from the configuration.
- **Connect to Profile**: Select a saved profile to connect via SSH directly from the terminal.

## Requirements

Before running Lutty, ensure you have Python installed along with the `curses` library (usually pre-installed with Python). You will also need SSH access to remote servers.

- Python 3.x
- `curses` (usually included in Python installations)
- SSH client (installed by default on most systems)

## Installation

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/your-username/lutty.git
    ```

2. Navigate to the project directory:

    ```bash
    cd lutty
    ```

3. Ensure Python 3.x is installed on your system. If `curses` is not available, install it via:

   - **For Ubuntu/Debian:**

     ```bash
     sudo apt-get install python3-curses
     ```

   - **For macOS (via Homebrew):**

     ```bash
     brew install python3
     ```

4. No additional dependencies are required. Lutty works with the default Python installation.

## Usage

Once everything is set up, you can start the `Lutty` application.

1. **Running Lutty**: 

    ```bash
    python3 lutty.py
    ```

    This will open the terminal interface where you can interact with the profiles.

2. **Interacting with the menu**:
   - **List Profiles**: Displays all saved SSH profiles.
   - **Add Profile**: Prompts you to enter details for a new SSH profile (name, username, host, port).
   - **Remove Profile**: Allows you to select and remove an existing profile.
   - **Connect to Profile**: Allows you to select a profile and connect to the server via SSH.

3. **SSH Connection**:
   When you select a profile and connect, `Lutty` will close the terminal interface and open an SSH connection using the selected profile's details.

## Configuration

All profiles are stored in a file located at `~/.lutty_profiles`. Each profile consists of the following fields:

- **Profile Name**: A unique name for the profile.
- **Username**: The SSH username to use.
- **Host**: The remote server's IP address or domain name.
- **Port**: The SSH port to use (default is `22`).


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## Note 
This project was moved from Bash Scripting to Python