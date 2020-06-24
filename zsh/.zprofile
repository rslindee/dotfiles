# Get OS name
if [ -f /etc/os-release ]; then
  . /etc/os-release
  export DISTRO=$NAME
fi

