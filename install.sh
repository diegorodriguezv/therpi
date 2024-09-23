sudo mkdir -p /usr/share/therpi/
sudo cp therpi.sh /usr/share/therpi/
sudo cp therpi.service /usr/lib/systemd/system/
sudo systemctl enable therpi
sudo systemctl start therpi
