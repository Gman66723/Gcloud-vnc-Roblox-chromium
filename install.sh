#!/bin/bash

echo "Starting installation..."

echo "Updating package list..."
sudo apt-get update

echo "Installing packages: tigervnc-standalone-server, wine, firefox, novnc, xterm..."
sudo apt-get install -y tigervnc-standalone-server wine firefox novnc xterm

echo "Installation complete."

echo "Setting up VNC server..."
mkdir -p ~/.vnc
echo "password" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

echo "Starting VNC server..."
vncserver :1 -xstartup /usr/bin/xterm

echo "Starting noVNC..."
websockify --web /usr/share/novnc/ 8080 localhost:5901 &

echo "Setup complete. You can now connect to http://localhost:8080"
