#!/bin/bash

echo "Starting installation..."

echo "Updating package list..."
sudo apt-get update

echo "Installing packages: tigervnc-standalone-server, wine, firefox, novnc, xterm..."
sudo apt-get install -y tigervnc-standalone-server wine firefox novnc xterm

echo "Installation complete."

echo "Setting up VNC server..."
mkdir -p ~/.vnc
echo "Setting password to "password"" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Custom xstartup file: run xterm AND firefox
cat > ~/.vnc/xstartup <<EOF
#!/bin/sh
xrdb $HOME/.Xresources
xterm &          # start xterm so VNC has a terminal
firefox &        # start firefox and keep it running
EOF
chmod +x ~/.vnc/xstartup

echo "Starting VNC server..."
vncserver :1

echo "Starting noVNC..."
websockify --web /usr/share/novnc/ 8080 localhost:5901 &

echo "Setup complete. You can now connect to http://localhost:8080"
echo "if you want to access go to Web preview > preview port 8080 > vnc.html or vnc_lite.html"
echo "mod by gg"
