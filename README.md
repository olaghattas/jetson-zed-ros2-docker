# Jetson Setup
## Download Image

**Jetson Nano - Ubuntu 20.04 image with OpenCV, TensorFlow and Pytorch**

[https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image#installation](https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image#installation)

## Headless Setup (Optional)

[Jetson nano headless setup](https://github.com/overclock98/Jetson_Nano_true_Headless_setup_without_hdmi_display) [2nd link: [https://hackmd.io/@scifair2021/BkoxkcfCO](https://hackmd.io/@scifair2021/BkoxkcfCO)]

For headless setup install **Putty** and then connect it to USB to your computer while jetson is already powered up using barrel jack. (Make sure jumper at J48 is connected otherwise jetson may not turn on)

Then use the com port and port : `22` then connect.
After connection is established use username and password both as `jetson`

Main purpose of connecting through usb is to setup wifi to connect wirelessly later.

**Wifi setup**

Insert wifi dongle in to usb port

- Setup WiFi: [steps](https://core.docs.ubuntu.com/en/stacks/network/network-manager/docs/configure-wifi-connections)
- Check dongle with `nmcli d`
- Turn on the wifi   `nmcli r wifi on`
- List out wifi `nmcli d wifi list`
- Enter ssid and password: `sudo nmcli d wifi connect <ssid> password <password>`
- Check ip with `ifconfig wlan0`

Now plug out the usb. You can now access jetson wirelessly from terminal

```jsx
ssh jetson@<ip_address>
```

Use password: `jetson` while connecting

# We now have to extend our storage

### **Option 1: Using GParted (Graphical Method)**

1. **Install GParted**:
    - Open a terminal on your Jetson Nano.
    - Install GParted by running **`sudo apt-get install gparted`**.
2. **Run GParted**:
    - Launch GParted either from the terminal by typing **`sudo gparted`** or through the UI by searching for GParted.
3. **Resize the Partition**:
    - In GParted, select your SD card from the drop-down menu at the top right.
    - Right-click on the main partition (usually **`/dev/mmcblk0p1`** or similar) and choose "Resize/Move".
    - In the Resize window, drag the slider or enter the new size to utilize the full SD card space.
    - Click "Resize/Move" and then click the "Apply" button to apply the changes.
4. **Reboot**:
    - After the process is complete, reboot your Jetson Nano to ensure the changes are recognized.

### **Option 2: Using Command Line (Headless Method)**

1. **Check Current Partition**:
    - In a terminal, type **`df -h`** to see the current partition sizes.
2. **Use `fdisk` to Resize**:
    - Run **`sudo fdisk /dev/mmcblk0`** (replace **`/dev/mmcblk0`** with your SD card device, if different).
    - Delete the existing main partition (usually partition 1) and create a new one using the same start sector as before but with an extended size to occupy the entire SD card.
        - p > d > 1 > n > 1 >`enter` > `enter` > no > w
    - Be careful with this step as it can lead to data loss if done incorrectly.
3. **Resize Filesystem**:
    - After modifying the partition, use **`sudo resize2fs /dev/mmcblk0p1`** (replace with your partition, if different) to resize the filesystem.
4. **Reboot**:
    - Reboot the Jetson Nano.
    
    Intsall no machine 
    
    [https://kb.nomachine.com/AR02R01074](https://kb.nomachine.com/AR02R01074)

# ZED SDK installation
References: \
https://www.stereolabs.com/docs/installation/linux \
https://www.stereolabs.com/docs/get-started-with-zed

1. **Download the SDK file**
    ```
    wget https://github.com/olaghattas/jetson-zed-ros2-docker/blob/master/ZED_SDK_Tegra_L4T32.7_v4.0.8.zstd.run
    ```
2. **Provide execution permission**
    ```
    sudo chmod +x ZED_SDK_Tegra_L4T32.7_v4.0.8.zstd.run
    ```
3. **Install `zstd`**. It will be needed for the installer to run
    ```
    sudo apt install zstd
    ```
3. **Run the ZED SDK installer**
    ```
    ./ZED_SDK_Tegra_L4T32.7_v4.0.8.zstd.run
    ```
4. **After installation check it by runnung**
    ```
    /usr/local/zed/tools/ZED_Explorer
    ```
# Docker Instruction

## Installing Docker

<!-- ### [Linux](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) -->
e.g. By default docker should be installed. Use `sudo docker --version` command to check if docker is installed. If not follow these steps to instal docker.

1. Uninstall old version first.
    ```
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
    ```
    ```
    sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
    ```
    - Images, containers, volumes, or custom configuration files on your host aren't automatically removed. To delete all images, containers, and volumes:
        ```
        sudo rm -rf /var/lib/docker
        sudo rm -rf /var/lib/containerd
        ```

2.  Install using the apt repository:

    -   Set up Docker's apt repository
        ### For Ubuntu
        ```
        # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        # Add the repository to Apt sources:
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -sc) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        ```

    -   Install the Docker packages.
        ```
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        ```

3.  Verify the Installation:

    -   Verify that the Docker Engine installation is successful by running the hello-world image.
        ```
        sudo docker run hello-world
        ```
## Install docker-compose
e.g. Good to know that, currently there two versions of docker compose. `docker-compose` is the V1 and `docker compose` is V2. We need to install the V1.
1. Download and Install docker-compose
    ```
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ```
2. Provide execution permission
    ```
    sudo chmod +x /usr/local/bin/docker-compose
    ```
3.  Verify the Installation:
    ```
    sudo docker-compose version
    ```
## Add docker to user group
1. Create the docker group
    ```
    sudo groupadd docker
    ```
2. Add user to the docker group
    ```
    sudo usermod -aG docker $USER
    ```
3. Activate the changes to the group:
    ```
    newgrp docker
    ```
## Building Docker Image and Run Container
Download and navigate to this repository follow these steps to build image and run the container.
1. Download the repository and provide all permision to the folder
    ```
    sudo mkdir /etc/docker/compose/
    cd /etc/docker/compose/
    sudo git clone https://github.com/olaghattas/jetson-zed-ros2-docker.git
    sudo chmod -R 777 jetson-zed-ros2-docker
    cd jetson-zed-ros2-docker
    ```
2. Change camera location in `docker-compose.yaml` file by `sudo nano docker-compose.yaml`. Then under `environment` look for `cam_loc` field to change the camera name. 

3. Build and run the docker image
    ```
    sudo xhost +
    cd /etc/docker/compose/jetson-zed-ros2-docker
    sudo docker-compose up
    ```

4. with container running, attach it from another terminal and check ros2 topics by `ros2 topic list` whether zed is publishing
    ```
    docker-compose exec -it <container-name> bash
    ```

Good to know: if you cant pull an image from dockerhub if you have another image with the same name so make sure you delete it firs. If you want to make changes to the docker while running in execution mode before closing the docker you need to run docker commit `docker commit <container-id> <new-image-name>` use this command, the name of the new image can be the same as as your old imgae if you are planning on overwritting it. This however only saves it on your machine you will need to push to docker with docker push inorder for everyone to use it.

Zed has a unique serial numbre that is fetched from internet everytime if there is not serial number found on the container. If a new zed camera is used serial number will not match. Therefore its best to commit serial number to the local image so that we don't need internet while running a new camera. To do so, with docker container running, run the following command in anothe terminal:
```
docker commit jetson-zed-ros2-docker-zed-ros2-1 olagh/zed_docker:env_var
```

[Launch docker on boot as a service](https://gist.github.com/mosquito/b23e1c1e5723a7fd9e6568e5cf91180f)
==================================

- Create file /etc/systemd/system/docker-compose@.service with the following content. SystemD calling binaries using an absolute path. In my case is prefixed by /usr/local/bin, you should use paths specific for your environment

```ini
[Unit]
Description=%i service with docker compose 
PartOf=docker.service
After=docker.service
After=gdm.service 
Requires=containerd.service 
After=containerd.service
PartOf=graphical-session.target 


[Service] 
Type=simple
User=jetson
Restart=on-failure 
Environment=DISPLAY=:0 
WorkingDirectory=/etc/docker/compose/%i 
#ExecStart=/usr/local/bin/docker-compose up 
ExecStart=/bin/bash -c "xhost + && /usr/local/bin/docker-compose up" 
ExecStop=/usr/local/bin/docker-compose down 

RestartSec=10 

[Install] 
WantedBy=multi-user.target 
WantedBy=graphical-session.target 

```
Make sure you have `docker-compose.yaml` in `/etc/docker/compose/jetson-zed-ros2-docker` and call

```
sudo systemctl enable docker-compose@jetson-zed-ros2-docker
sudo systemctl start docker-compose@jetson-zed-ros2-docker
```


## (Optional)Docker cleanup timer with system


Create `/etc/systemd/system/docker-cleanup.timer` with this content:

```ini
[Unit]
Description=Docker cleanup timer

[Timer]
OnUnitInactiveSec=12h

[Install]
WantedBy=timers.target
```

And service file `/etc/systemd/system/docker-cleanup.service`:

```ini
[Unit]
Description=Docker cleanup
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
WorkingDirectory=/tmp
User=root
Group=root
ExecStart=/usr/local/bin/docker system prune -af

[Install]
WantedBy=multi-user.target
```

run `systemctl enable docker-cleanup.timer` for enabling the timer

## Troubleshooting

-   Ensure Docker is running before attempting to build images or run containers.
-   Check Docker and Docker Compose versions with `docker --version` and `docker-compose --version`.
- If you get an error that GPU deploy is not supported this is due to the ode version of docker-compose it should be greater than 1.29 to work.
-   For specific errors, refer to the official Docker documentation or Docker community forums.

