# Lutty - A Simple PuTTY Alternative for Linux  

Lutty is a lightweight and interactive **SSH session manager** for Linux, designed as a simple alternative to PuTTY. It allows users to save SSH profiles, manage connections, and enable session logging—all from the command line.  

## 🚀 Features  
✅ **Save & Manage SSH Profiles** – Store frequently used SSH credentials for easy access.  
✅ **Interactive Menu** – A user-friendly menu for quick navigation.  
✅ **Session Logging** – Optionally log SSH sessions for reference.  
✅ **Auto Profile Selection** – Easily choose a profile to connect with one command.  
✅ **Lightweight & Fast** – Written in pure Bash for minimal system impact.  

## 🛠 Installation  
Clone the repository and give Lutty executable permissions:  
```bash
git clone https://github.com/yourusername/lutty.git
cd lutty
chmod +x lutty.sh
```


# 📌 Usage

Run Lutty:

```bash
./lutty.sh
```

# Menu Options:

1️⃣ **List Profiles** – View saved SSH profiles.  
2️⃣ **Add Profile** – Save a new SSH profile.  
3️⃣ **Remove Profile** – Delete an existing SSH profile.  
4️⃣ **Connect to Profile** – Establish an SSH connection using a saved profile.  
5️⃣ **Exit** – Quit the application.  

# 📡 **Example SSH Profile Connection**  
_Add a profile:_
```yaml
Profile Name: myserver  
Username: user  
Host: 192.168.1.100  
Port: 22
```

# 📄 **Logging SSH Sessions**  
Lutty provides an option to enable session logging. Logs are saved in:

```bash
~/putty_logs/
```

# 🤝 **Contributions & Feedback**  
Feel free to submit issues, feature requests, or pull requests! 🎉  

⭐ **If you find Lutty useful, don't forget to give it a star!** ⭐
