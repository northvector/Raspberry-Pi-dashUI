![Intro](img/logo.png?raw=true "Raspberry Pi Dashboard - Project Logo")
<div align="center">View and manage your Pi system through your web browser!</div>
<p align="center"><sub>Written in plain HTML5, CSS3, JavaScript and PHP (backend). <b>No extra software required!</b></sub></p>
<br>
<div align="center">
  <a href="https://github.com/northvector/Raspberry-Pi-dashUI/stargazers"><img src="https://img.shields.io/github/stars/northvector/Raspberry-Pi-dashUI?color=yellow" alt="Stars Badge"/></a>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/network/members"><img src="https://img.shields.io/github/forks/northvector/Raspberry-Pi-dashUI?color=orange" alt="Forks Badge"/></a>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/pulls"><img src="https://img.shields.io/github/issues-pr/northvector/Raspberry-Pi-dashUI" alt="Pull Requests Badge"/></a>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/issues"><img src="https://img.shields.io/github/issues/northvector/Raspberry-Pi-dashUI" alt="Issues Badge"/></a>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/northvector/Raspberry-Pi-dashUI?color=2b9348"></a>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/blob/master/LICENSE"><img src="https://img.shields.io/github/license/northvector/Raspberry-Pi-dashUI?color=2b9348" alt="License Badge"/></a>
<br>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/"><img src="https://img.shields.io/github/repo-size/northvector/Raspberry-Pi-dashUI?color=important" alt="License Badge"/></a>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/"><img src="https://img.shields.io/tokei/lines/github/northvector/Raspberry-Pi-dashUI?color=yellowgreen" alt="License Badge"/></a>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/releases"><img src="https://img.shields.io/github/v/release/northvector/Raspberry-Pi-dashUI?color=success" alt="License Badge"/></a>
<a href="https://github.com/northvector/Raspberry-Pi-dashUI/commits"><img src="https://img.shields.io/github/last-commit/northvector/Raspberry-Pi-dashUI" alt="License Badge"/></a>
</div>
<br>
<p align="center"><a href="https://github.com/northvector/Raspberry-Pi-dashUI/issues">Report a bug</a> | <a href="https://github.com/northvector/Raspberry-Pi-dashUI/discussions">Request a new feature</a> | <a href="https://github.com/northvector/Raspberry-Pi-dashUI/pulls">Help develop this project</a></p>

## Features

- Live surveillance of RPi hardware (CPU temperature, frequency, load etc.) with customizable warning thresholds
- Detailed software/hardware information (web server, PHP, storage / partition workload, core voltage, plugged USB devices, kernel version, model specifications, OS, CPU, network config)
- Protected access with password login ([configure password](https://github.com/northvector/Raspberry-Pi-dashUI#configure-password-manually))
- Shutdown / Reboot your Raspberry Pi with scheduling options ([setup instructions](https://github.com/northvector/Raspberry-Pi-dashUI#enable-shutdown--reboot-optional))
- Responsive mobile web app
- Dark Theme (manual / auto)

### 🆕 Use the installer script to set up the dashboard!

## Screenshots

![image](https://github.com/northvector/Raspberry-Pi-dashUI/assets/22070926/195a660b-4722-453c-9339-9bd2d7971bd8)
![image](https://github.com/northvector/Raspberry-Pi-dashUI/assets/22070926/adda2d54-a4e1-4e42-83ac-264561d98511)

## Use installer script (alpha)

```bash
wget -O install.sh https://github.com/northvector/Raspberry-Pi-dashUI/raw/release/installer.sh
sudo bash install.sh
```

## Manual download and installation

### Prerequisites

- Running web server (e.g. *Lighttpd*) with *PHP* installed
- Installed *Git* (comes preinstalled on Raspberry Pi OS / formerly Raspbian as well as other Linux distros)
- Valid permissions set within `/var/www/html`

### Setup project

- clone the project into your web folder:<br>`git clone https://github.com/northvector/Rasberry-Pi-dashUI.git /var/www/html/<your_subfolder_name>`<br>(replace `<your_subfolder_name>` with a name of your choice accordingly, you can also rename this base folder at any time afterwards)
- ***Alternatively*** download this repo as a ZIP file and extract it
- Run in a terminal to set valid permissions:
  - `sudo chown -R <yourlogin>:www-data /var/www/html/<your_subfolder_name>`<br>(replace `<yourlogin>` with your username)
  - `sudo chmod -R 775 /var/www/html/<your_subfolder_name>`
  - this will allow the `www-data` user exclusively to write/edit (7**7**5) files **only in your dashboard folder**!
> An erroneous permission typically results in the situation where the user responsible for web server (e.g. `www-data`) does not have rights to create/modify the local config file for saving your dashboard adjustments (your custom thresholds, password etc.). In this case, the dashboard won't work at all and will throw this error.
- **DONE!** Open web browser with URL: `http://<IP_OF_YOUR_RPI>/<your_subfolder_name>`

## Additional configuration / Help

#### Display core voltage (or other hardware info) output (optional)
- If you want to see advanced hardware information (core voltage, advanced model information) on your dashboard instance:
  - run in a terminal: `sudo usermod -aG video www-data` 
>If you do not use Raspberry Pi OS, but e.g. Ubuntu, you do have to install `libraspberrypi-bin` by running `sudo apt install libraspberrypi-bin`.

##### Background
The `vcgencmd` command (specifically dedicated to RPi firmware) is a system command that requires certain hardware rights. Therefore one has to grant this particular right (to read hardware info) to e.g. `www-data` (under which web server is running). This is achieved by adding this user to a designated system group called *video*, which the standard user pi is part of by default.
- only comes preinstalled on *Raspberry Pi OS*
- in case of problems: please comment on [#12](https://github.com/northvector/Raspberry-Pi-dashUI/issues/12) (or [new issue](https://github.com/northvector/Raspberry-Pi-dashUI/issues/new))

#### Enable shutdown / reboot (optional)

> Recommended only, if your RPi is **not** accessible from outside your local (LAN) network!

In order to use the remote shutdown functionality you have to give the user `www-data` advanced rights for running one specific command:
1. Run `sudo visudo` to open the editor for adjusting user rights
2. **Be careful what you change here!**<br>Just add the following at the **end** of the file: <br>`www-data ALL=NOPASSWD: /sbin/shutdown`
3. **Reboot** your RPi to enable shutdown from another device (connected to same local network as your RPi).

#### Configure password (manually)

- Please be aware that there is a **more user-friendly** way now by using the dashboards options modal. However, the following manual way of changing the password might be helpful
  - in case of wrong permissions (user `www-data` cannot change settings for you - [see issue #22](https://github.com/northvector/Raspberry-Pi-dashUI/issues/22) or [read here](https://github.com/northvector/Raspberry-Pi-dashUI#valid-permissions) for help and instructions to solve)
  - forgotten password (and access to dashboard therefore impossible)

1. Go to [https://www.md5-generator.de/](https://www.md5-generator.de/) and generate *MD5 encrypted passphrase*.
2. Open `local.config` or create it and apply your custom passphrase string (generated in **step 1**) as follows (don't alter other lines):
```
[...]
'general' =>
  array (
    [...]
    'pass' => 'YOUR_MD5_PASSPHRASE_HERE',
    [...]
  ),
  [...]
```

> **As always**: Make sure to change the default password (which is **root**) and choose a more secure one at first setup and consider more security if your dashboard is accessible on the network.

## License

[**GPL-3.0**](LICENSE).

---

`Raspberry Pi and the Raspberry Pi Logo are registred trademarks of the Raspberry Pi Foundation`
