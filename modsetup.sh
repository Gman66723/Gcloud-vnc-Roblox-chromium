#!/bin/bash

# Colors
GREEN='\033[0;32m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Helper function to print green text
print_green() {
    echo -e "${GREEN}$1${NC}"
}

# Helper function to run a command and print its output in white
run_command() {
    print_green "$1"
    echo -e "${WHITE}"
    eval "$2"
    echo -e "${NC}"
}

print_green "Starting the setup process..."

# Install dependencies
run_command "Installing dependencies..." "sudo apt-get update && sudo apt-get install -y expect tigervnc-standalone-server novnc websockify fluxbox"

# Download and install Steam
run_command "Downloading Steam..." "wget --progress=bar:force https://cdn.steamstatic.com/client/installer/steam.deb -O steam-latest.deb"
run_command "Installing Steam..." "sudo dpkg -i steam-latest.deb || sudo apt-get -f install -y"

# Set VNC password
print_green "Setting VNC password to 'password'. Please change it later."
/usr/bin/expect << EOF
spawn vncpasswd
expect "Password:"
send "password\r"
expect "Verify:"
send "password\r"
expect "Would you like to enter a view-only password (y/n)?"
send "n\r"
expect eof
EOF

# Configure VNC
run_command "Configuring VNC..." 'mkdir -p /home/greysenhgerent/.vnc && echo "#!/bin/sh\n/usr/bin/fluxbox &" > /home/greysenhgerent/.vnc/xstartup && chmod +x /home/greysenhgerent/.vnc/xstartup'

# Configure Fluxbox
run_command "Configuring Fluxbox to start Steam..." 'mkdir -p /home/greysenhgerent/.fluxbox && echo "#!/bin/sh\nsteam &" > /home/greysenhgerent/.fluxbox/startup && chmod +x /home/greysenhgerent/.fluxbox/startup'

# Start VNC Server
run_command "Starting VNC server..." "vncserver -kill :1 || true && vncserver :1 -localhost no -geometry 1280x800 -depth 24 -xstartup /usr/bin/fluxbox"

# Start noVNC proxy
run_command "Starting noVNC proxy..." "websockify -D --web=/usr/share/novnc/ 6080 localhost:5901"

print_green "Setup complete!"
print_green "You can now connect to your remote desktop:"

print_green "1. Using a VNC Client:"
print_green "   Address: <your_machine_ip>:5901"
print_green "   Password: password"

print_green "2. Using your Web Browser:"
print_green "   URL: http://<your_machine_ip>:6080/vnc.html"
print_green "   Password: password"

print_green "Remember to replace <your_machine_ip> with the public IP of this machine."
