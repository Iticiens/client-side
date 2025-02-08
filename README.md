# Logistics & Transportation Management App

<p align="center">
  <img src="readme_assets/logo_light.png" width="200" alt="App Logo Light"/>
  <img src="readme_assets/logo_dark.png" width="200" alt="App Logo Dark"/>
</p>

## Overview
Our solution is a modern Flutter application designed for efficient logistics and transportation management. It features real-time truck tracking, order management, and QR code-based verification. The application is cross-platform, working seamlessly on web, mobile, and desktop.

## 📱 App Screenshots

### Client Interface
<p align="center">
  <img src="readme_assets/client/map_view.png" width="250" alt="Map View"/>
  <img src="readme_assets/client/orders_list.png" width="250" alt="Orders List"/>
  <img src="readme_assets/client/truck_tracking.png" width="250" alt="Truck Tracking"/>
</p>

### Driver Interface
<p align="center">
  <img src="readme_assets/driver/navigation.png" width="250" alt="Navigation"/>
  <img src="readme_assets/driver/speed_monitor.png" width="250" alt="Speed Monitor"/>
  <img src="readme_assets/driver/status_update.png" width="250" alt="Status Update"/>
</p>

### QR Scanner & Verification
<p align="center">
  <img src="https://github.com/Iticiens/client-side/tree/main/readme_assets/qr_scanner.png" width="250" alt="QR Scanner"/>
  <img src="readme_assets/features/verification_success.png" width="250" alt="Verification Success"/>
  <img src="readme_assets/features/truck_details.png" width="250" alt="Truck Details"/>
</p>

### Analytics & Reports
<p align="center">
  <img src="https://github.com/Iticiens/client-side/tree/main/readme_assets/analytics/dashboard.png" width="250" alt="Dashboard"/>
  <img src="https://github.com/Iticiens/client-side/tree/main/readme_assets/analytics/performance.png" width="250" alt="Performance Metrics"/>
  <img src="https://github.com/Iticiens/client-side/tree/main/readme_assets/analytics/reports.png" width="250" alt="Reports"/>
</p>

### Responsive Design
<p align="center">
  <img src="https://github.com/Iticiens/client-side/tree/main/readme_assets/responsive/desktop.png" width="600" alt="Desktop View"/>
</p>
<p align="center">
  <img src="https://github.com/Iticiens/client-side/tree/main/readme_assets/responsive/tablet.png" width="400" alt="Tablet View"/>
  <img src="https://github.com/Iticiens/client-side/tree/main/readme_assets/responsive/mobile.png" width="200" alt="Mobile View"/>
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
For any inquiries, reach out to us at [aminemenadi09@gmail.com](mailto: aminemenadi09@gmail.com).

