#
#  Configure and start plotting and farming services.
#

echo "Welcome to Machinaris v$(cat /machinaris/VERSION)!"
echo "${blockchains} - ${mode} on $(uname -m)"

if [[ "$HOSTNAME" =~ " |'" ]]; then 
  echo "You have placed a space character in the hostname for this container."
  echo "Please use only alpha-numeric characters in the hostname within docker-compose.yml and restart."
  exit 1
fi

# v0.6.0 upgrade check guard - only allow single blockchain per container
if [[ "${blockchains}" == "chia,flax" ]]; then
  echo "Only one blockchain allowed per container in Machinaris."
  echo "Please remove second value from 'blockchains' variable and restart."
  exit 1
fi

# Ensure a worker_address containing an IP address is set on every launch, else exit
if [[ -z "${worker_address}" ]]; then
  echo "Please set the 'worker_address' environment variable to this system's IP address on your LAN."
  echo "https://github.com/guydavis/machinaris/wiki/Unraid#how-do-i-update-from-v05x-to-v060-with-fork-support"
  exit 1
fi

# Warn if non-standard worker_api_port is being used, likely default value they did not override properly
if [[ "${blockchains}"  == "chia" && "${worker_api_port}" != '8927']]; then
  echo "Chia worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8927?"
fi
if [[ "${blockchains}"  == "cactus" && "${worker_api_port}" != '8936']]; then
  echo "Cactus worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8936?"
fi
if [[ "${blockchains}"  == "chives" && "${worker_api_port}" != '8931']]; then
  echo "Chives worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8931?"
fi
if [[ "${blockchains}"  == "cryptodoge" && "${worker_api_port}" != '8937']]; then
  echo "Cryptodoge worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8937?"
fi
if [[ "${blockchains}"  == "flax" && "${worker_api_port}" != '8928']]; then
  echo "Flax worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8928?"
fi
if [[ "${blockchains}"  == "flora" && "${worker_api_port}" != '8932']]; then
  echo "Flora worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8932?"
fi
if [[ "${blockchains}"  == "hddcoin" && "${worker_api_port}" != '8930']]; then
  echo "HDDCoin worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8930?"
fi
if [[ "${blockchains}"  == "maize" && "${worker_api_port}" != '8933']]; then
  echo "Maize worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8933?"
fi
if [[ "${blockchains}"  == "nchain" && "${worker_api_port}" != '8929']]; then
  echo "N-Chain worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8936?"
fi  
if [[ "${blockchains}"  == "staicoin" && "${worker_api_port}" != '8934']]; then
  echo "Staicoin worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8934?"
fi
if [[ "${blockchains}"  == "stor" && "${worker_api_port}" != '8935']]; then
  echo "Stor worker with non-standard worker_api_port of ${worker_api_port} found.  Did you mean to use 8935?"
fi  

# If on Windows, possibly mount SMB remote shares as defined in 'remote_shares' env var
/usr/bin/bash /machinaris/scripts/mount_remote_shares.sh > /tmp/mount_remote_shares.log

# Conditionally install megacmd on fullnodes
/usr/bin/bash /machinaris/scripts/megacmd_setup.sh > /tmp/megacmd_setup.log 2>&1

# Start the selected fork, then start Machinaris WebUI
if /usr/bin/bash /machinaris/scripts/forks/${blockchains}_launch.sh; then

  # Launch Machinaris web server and other services
  /machinaris/scripts/start_machinaris.sh

  # Cleanly stop Chia services on container stop/kill
  trap "chia stop all -d; exit 0" SIGINT SIGTERM

  # Conditionally install plotman on plotters and fullnodes, after the plotters setup
  /usr/bin/bash /machinaris/scripts/plotman_setup.sh > /tmp/plotman_setup.log 2>&1

  # Conditionally install chiadog on harvesters and fullnodes
  /usr/bin/bash /machinaris/scripts/chiadog_setup.sh > /tmp/chiadog_setup.log 2>&1

  # During concurrent startup of multiple fork containers, stagger less important setups
  sleep $[ ( $RANDOM % 180 )  + 1 ]s

  # Conditionally install forktools on fullnodes
  /usr/bin/bash /machinaris/scripts/forktools_setup.sh > /tmp/forktools_setup.log 2>&1

  # Conditionally install farmr on harvesters and fullnodes
  /usr/bin/bash /machinaris/scripts/farmr_setup.sh > /tmp/farmr_setup.log 2>&1

  # Conditionally install fd-cli on fullnodes, excluding Chia and Chives
  /usr/bin/bash /machinaris/scripts/fd-cli_setup.sh > /tmp/fd-cli_setup.log 2>&1

  # Conditionally build bladebit on plotters and fullnodes, sleep a bit first
  /usr/bin/bash /machinaris/scripts/bladebit_setup.sh > /tmp/bladebit_setup.log 2>&1

  # Conditionally madmax on plotters and fullnodes, sleep a bit first
  /usr/bin/bash /machinaris/scripts/madmax_setup.sh > /tmp/madmax_setup.log 2>&1

  # Conditionally install plotman on plotters and fullnodes, after the plotters setup
  /usr/bin/bash /machinaris/scripts/plotman_autoplot.sh > /tmp/plotman_autoplot.log 2>&1

fi

while true; do sleep 30; done;
