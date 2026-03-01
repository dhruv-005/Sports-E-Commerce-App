![Dart](https://img.shields.io/badge/Language-Dart-0175C2?logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-3DDC84?logo=android&logoColor=white)
![REST API](https://img.shields.io/badge/API-REST-orange)
![Provider](https://img.shields.io/badge/State%20Management-Provider-purple)
![SharedPreferences](https://img.shields.io/badge/Local%20Storage-SharedPreferences-yellow)
![Material Design](https://img.shields.io/badge/UI-Material%20Design-blue)
![License](https://img.shields.io/badge/License-Educational-lightgrey)
# 🏏 Sports E-Commerce Flutter App

A professional Flutter-based mini e-commerce application focused exclusively on **Sports Accessories**.

This project demonstrates:

- REST API Integration  
- JSON Parsing  
- Provider State Management  
- Local Storage using SharedPreferences  
- Dynamic UI rendering using GridView and ListView  

> Developed as an academic project.

---

# 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Project Objectives](#-project-objectives)
- [Features](#-features)
- [Public API Used](#-public-api-used)
- [Application Flow](#-application-flow)
- [Installation & Setup](#-installation--setup)
- [Screenshots](#-screenshots)
- [Learning Outcomes](#-learning-outcomes)
- [Future Enhancements](#-future-enhancements)
- [Author](#-author)
- [License](#-license)

---

# 📖 Project Overview

The **Sports E-Commerce Flutter App** is a single-domain mobile application that allows users to browse sports accessories, view detailed product information, manage a shopping cart, and experience real-time UI updates.

The app fetches data from a public REST API and displays it dynamically using modern Flutter UI components.

---

# 🎯 Project Objectives

- Integrate a public REST API into a Flutter application  
- Parse JSON data into structured Dart model classes  
- Implement real-time cart functionality  
- Display products using GridView and ListView  
- Apply clean and modular architecture  
- Implement Light and Dark theme switching  

---

# ✨ Features

- 🏟️ Single-domain application (Sports Accessories)  
- 🌐 REST API integration  
- 📦 JSON parsing using Dart model classes  
- 🧱 GridView & ListView product display  
- 🛒 Add to Cart / Remove from Cart  
- 💰 Automatic total price calculation  
- ⚡ Real-time UI updates using Provider  
- 🌗 Light & Dark theme support  
- 💾 Local storage using SharedPreferences  
- 📱 Responsive and modern Material Design UI  

---

# 🛠️ Tech Stack

- **Flutter** – Cross-platform UI framework  
- **Dart** – Programming language  
- **HTTP Package** – API integration  
- **Provider** – State management  
- **SharedPreferences** – Local data storage  
- **Material Design** – UI design system  

---

# 🌐 Public API Used

**Fake Store API (Free & Public)**  
https://fakestoreapi.com/products  

### API Integration Process

1. HTTP GET request sent from Flutter app  
2. JSON response received  
3. Data parsed into Dart Product model  
4. Products displayed dynamically in the UI  

---

# 🔄 Application Flow

1. App launches → Splash Screen  
2. Home Screen fetches products from REST API  
3. JSON data parsed into Product model objects  
4. Products displayed using GridView  
5. User adds/removes products from Cart  
6. Total price updates automatically  
7. Theme can be toggled between Light & Dark mode  

---

# 🚀 Installation & Setup

## ✅ Prerequisites

- Flutter SDK installed  
- Android Studio or VS Code  
- Android Emulator or Physical Device  

Verify Flutter installation:

```bash
flutter doctor
```

---

## 🔽 Step 1: Clone the Repository

```bash
git clone https://github.com/dhruv-005/Ecoomerce_Sports_App
```

---

## 📁 Step 2: Navigate to Project Directory

```bash
cd Ecoomerce_Sports_App
```

---

## 📦 Step 3: Install Dependencies

```bash
flutter pub get
```

---

## ▶️ Step 4: Run the Application

```bash
flutter run
```

---

# 📱 Screenshots

- Splash Screen  
- Home Screen (GridView Product Listing)  
- Product Detail Screen  
- Cart Screen  
- Light Theme & Dark Theme  
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-33-15" src="https://github.com/user-attachments/assets/fe10c4d8-b379-41ab-ab10-dafa55f54019" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-33-24" src="https://github.com/user-attachments/assets/7db06ebb-4d67-44cf-86e8-e89de5f98a5e" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-34-29" src="https://github.com/user-attachments/assets/6e95aa35-7d79-4b38-852a-a7652b0b1420" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-34-42" src="https://github.com/user-attachments/assets/d4d7254a-1b1e-4096-9ff2-e819e201bd9d" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-34-59" src="https://github.com/user-attachments/assets/b443db5b-65c6-4ac9-8e55-d75ee2376e8e" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-35-11" src="https://github.com/user-attachments/assets/f5407bd4-c569-4a73-95f1-7f89c0e48005" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-35-18" src="https://github.com/user-attachments/assets/5d45751b-e344-4471-9dc6-9fc98c7918c3" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-36-09" src="https://github.com/user-attachments/assets/cc57a693-18a8-4312-ba47-cfde6d1f70d5" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-36-33" src="https://github.com/user-attachments/assets/28ae8c74-bde0-47bb-b2db-5961a520a09c" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-36-56" src="https://github.com/user-attachments/assets/a6902fad-9e75-41af-a740-8d25d8454ba4" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-37-16" src="https://github.com/user-attachments/assets/cfaac3af-65b9-4a05-a55f-8b412b167bef" />
<img width="1363" height="734" alt="Screenshot From 2026-02-22 14-37-28" src="https://github.com/user-attachments/assets/17608051-d836-46cc-b1ec-a8748d215f4f" />




---

# 📚 Learning Outcomes

- Working with REST APIs in Flutter  
- Parsing and mapping JSON data  
- Implementing Provider for state management  
- Managing local storage with SharedPreferences  
- Designing responsive UI using Material Design  
- Structuring scalable Flutter applications  

---

# 🔮 Future Enhancements

- Firebase Authentication  
- Payment Gateway Integration  
- Order History Management  
- Wishlist Feature  
- Backend Admin Panel  
- Product Search & Filtering  
- Pagination & Lazy Loading  

---

# 👤 Author

**Dhruv Sonani**  
Flutter Developer | Project  

GitHub: https://github.com/dhruv-005  

---

# 📄 License

This project is developed for educational purposes.  
You are free to use and modify it for learning and academic purposes.

---
