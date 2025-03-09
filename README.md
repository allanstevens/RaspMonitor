# RaspMonitor

## Overview
RaspMonitor is a project designed to monitor and manage tasks on Raspberry Pi devices. It utilizes XSLT for data transformation and PHP for backend processing. To use RaspMonitor, you must install the [RaspController app](https://www.egalnetsoftwares.com/apps/raspcontroller/) on your device. The app automatically installs a Python script that enables monitoring of CPU, RAM, Storage, and Network when you open the corresponding section in the app. Ensure this step is completed so that the PHP code has the necessary script to run.

![image](https://github.com/user-attachments/assets/bc82b238-dcdd-473d-b9b8-f0c0ed8fd8c4)

## Features
- Real-time monitoring of Raspberry Pi metrics
- Simple XML output with data transformation using XSLT (this was to allow simple intergration to openHAB)
- Backend processing with PHP
- User-friendly interface

## Prerequisites
- A Raspberry Pi device
- PHP installed on the device
- Web server (e.g., Apache or Nginx)
- Git (or just download the files direct)
- The Python script used by [RaspController](https://www.egalnetsoftwares.com/apps/raspcontroller/) for monitoring CPU, RAM, Storage, and Network. To install this script, open the 'CPU, RAM, Storage and Network monitoring' section on the RaspController app.

## Installation

### Steps
1. Clone the repository:
    ```bash
    git clone https://github.com/allanstevens/RaspMonitor.git
    ```
2. Navigate to the project directory:
    ```bash
    cd RaspMonitor
    ```
3. Ensure the Python script from RaspController is installed on your Raspberry Pi.
4. Configure your web server to serve the project.
5. Ensure PHP is properly configured and working with your web server.

## Usage
1. Start your web server.
2. Access the RaspMonitor interface via your web browser.
3. Follow the on-screen instructions to monitor and manage your Raspberry Pi.

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a new Pull Request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements
- [Raspberry Pi Foundation](https://www.raspberrypi.org/)
- [PHP Documentation](https://www.php.net/docs.php)
- [XSLT Documentation](https://www.w3.org/TR/xslt/)
- [RaspController](https://www.egalnetsoftwares.com/apps/raspcontroller/)

## Contact
For any questions or feedback, please contact [allanstevens](https://github.com/allanstevens).
