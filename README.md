#  diAz Shop – Delivery App (Flutter)

##  Overview

The **diAz Shop Delivery App** is a Flutter-based mobile application designed for delivery agents to manage and deliver customer orders efficiently.

Agents can view available orders, accept deliveries, and update order status in real time.

---

##  Features

###  Authentication
- Login using phone number and username
- JWT-based authentication with backend

###  Order Management
- View available orders (`pending`)
- Accept/assign orders
- View assigned orders

###  Delivery Tracking
- Update order status:
  - `assigned`
  - `ready`
  - `in_transit`
  - `arrived`
  - `delivered`

###  Order Details
- Customer name and phone
- Delivery address (coordinates)
- Ordered items
- Total price

---

##  Screens (Typical)

- Login Screen
- Orders List (Available & Assigned)
- Order Details Screen
- Status Update Interface

---

##  Technologies Used

- Flutter (Dart)
- HTTP package (API calls)
- JWT Authentication
- REST API integration

---

##  API Integration

The app communicates with the backend server.

### Endpoints used :
```json
POST /login
GET /delivery/orders
POST /delivery/orders/:id/assign
POST /delivery/orders/:id/status
```

---

##  Setup & Installation

### 1. Clone the project
```bash
git clone https://github.com/your-username/diaz-delivery-app.git
cd diaz-delivery-app
```
### 2. Install dependencies
```bash
flutter pub get
```
### 3. Configure API URL
```dart
const String baseUrl = "http://YOUR_SERVER_IP:3000";
``` 

### 4. Run the app
```bash 
flutter run
```
## License
MIT License
