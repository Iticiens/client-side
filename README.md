# Logistics & Transportation Management App

<p align="center">
  <img src="readmepicture/logo.png" width="200" alt="App Logo"/>
</p>

## Overview
Our solution is a modern Flutter application designed for efficient logistics and transportation management. It features real-time truck tracking, order management, and QR code-based verification. The application is cross-platform, working seamlessly on web, mobile, and desktop.

## 📱 App Screenshots

### Light Theme
<p align="center">
  <img src="readmepicture/light/login.png" width="200" alt="Login Screen"/>
  <img src="readmepicture/light/home.png" width="200" alt="Home Screen"/>
  <img src="readmepicture/light/trucks.png" width="200" alt="Trucks Screen"/>
</p>

<p align="center">
  <img src="readmepicture/light/orders.png" width="200" alt="Orders Screen"/>
  <img src="readmepicture/light/qr.png" width="200" alt="QR Scanner"/>
  <img src="readmepicture/light/profile.png" width="200" alt="Profile Screen"/>
</p>

### Dark Theme
<p align="center">
  <img src="readmepicture/dark/login.png" width="200" alt="Login Screen Dark"/>
  <img src="readmepicture/dark/home.png" width="200" alt="Home Screen Dark"/>
  <img src="readmepicture/dark/trucks.png" width="200" alt="Trucks Screen Dark"/>
</p>

<p align="center">
  <img src="readmepicture/dark/orders.png" width="200" alt="Orders Screen Dark"/>
  <img src="readmepicture/dark/qr.png" width="200" alt="QR Scanner Dark"/>
  <img src="readmepicture/dark/profile.png" width="200" alt="Profile Screen Dark"/>
</p>

## Features

### 🚛 Driver Features
- **Login & Timeline Tracking:** Drivers can log in and check their truck's journey from start to finish.
- **Daily Tasks & Goals:** Drivers can track their daily assignments.
- **Issue Reporting:** Drivers can report truck or environmental issues, enabling the admin to monitor the truck and driver.
- **Environmental Monitoring:** Drivers can check truck temperature, humidity, and location. Data is stored locally if offline and sent to the admin upon reconnection.
- **Trip Completion & Payment:** Once data is submitted, the admin can mark the trip as completed and process payments.
- **QR Code Scanner:** Drivers can scan client QR codes to verify orders and driver identity.
- **Weight & Cargo Checks:** Ensures accurate tracking of cargo details.

### 📦 Client Features
- **Order Tracking:** Clients can monitor their orders in real-time.
- **Warehouse & Property Management:** Clients can view their business properties and warehouses.
- **Real-time Truck Monitoring:** Clients can track incoming trucks to efficiently manage unloading and prevent delays.
- **Optimal Route Selection:** The system calculates the minimal path for each truck to save time and costs.

### 🛠️ Admin Panel
- **Comprehensive Control:** The admin has full access to manage orders, track trucks, verify deliveries, and oversee all logistics operations.
- **Live Monitoring:** Ensures smooth operations by tracking all truck movements and driver activities.

## Technologies Used
- **Flutter** (Cross-platform development)
- **Golang with Pocketbase / Backend Solution** (Data storage & real-time sync)
- **Open Street Map** (Real-time tracking & route optimization)
- **QR Code Scanning** (Order & driver verification)
- **Local Database** (Local First architecture storage & synchronization)

## Installation & Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-repo/logistics-app.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd logistics-app
   ```
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```
4. **Run the app:**
   - For mobile:
     ```bash
     flutter run
     ```
   - For web:
     ```bash
     flutter run -d chrome
     ```
   - For desktop:
     ```bash
     flutter run -d windows/mac/linux
     ```

## Contribution
We welcome contributions! Feel free to submit issues or pull requests to improve the application.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact
For any inquiries, reach out to us at [your-email@example.com](mailto:your-email@example.com).

