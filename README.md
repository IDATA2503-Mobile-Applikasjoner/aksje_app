# NTNU Mobile Applications (IDATA2503) - Investmate (StockApp)
### Group 4
## Introduction

Welcome to Investmate, a Flutter project developed by students at NTNU for the course IDATA2503 - Mobile Applications. Investmate provides a user-friendly interface for buying and selling simulated stocks, allowing you to experience the financial world right at your fingertips and make informed investment decisions with ease. Dive into the world of stock trading with Investmate!

## User Stories

1. **View Stocks:** As a user, I want to view a list of simulated stocks so I can see my options.

2. **Detailed Stock View:** As a user, I want to click on a stock and view its detailed information, including its price and percentage change.

3. **Buy Stocks:** As a user, I want to buy stocks by specifying the number of shares I want so that they can be added to my portfolio.

4. **Sell Stocks:** As a user, I want to sell stocks from my portfolio so I can cash in on my investments.

5. **Portfolio View:** As a user, I want to view my current stock portfolio, including the total value and individual stock performances, so I can track my investments.

6. **Search Functionality:** As a user, I want to search for specific stocks so I can find them quickly.

7. **User Authentication:** As a user, I want to register, log in, and secure my account, including password encryption, so that my portfolio and transaction history remain private.

8. **Personal Stock Lists:** As a user, I want to add and remove stocks to different personal lists.

9. **Alerts and Notifications:** (Future feature)

### Use-case diagram
![image](https://github.com/IDATA2503-Mobile-Applikasjoner/aksje_app/assets/99326286/ff51b21a-8838-476d-84f7-b4541cea23bd)

## User Guide
* You can see the user gide at the wiki using this link
* https://github.com/IDATA2503-Mobile-Applikasjoner/aksje_app/wiki/User-Guide

## Sprint reports
To view our development process you can visit our wiki: [Sprint reports](https://github.com/IDATA2503-Mobile-Applikasjoner/aksje_app/wiki/Sprints)


## Specifications


### General:

- **Platform:** Mobile (iOS & Android)
- **Language:** English (with potential for localization in future updates)
- **Theme:** Light & Dark mode support

### Features:

1. **Stock Listings:**
   - Simulated stocks
   - Display stock name, current price, and daily change percentage
   - Scrollable list with pull-to-refresh functionality

2. **Stock Details:**
   - Price and percentage change
   - Candlestick chart
   - Buy/Sell options

4. **User Portfolio:**
   - Display user's total portfolio value in a line chart
   - List of owned stocks with current value and percentage change

5. **Search & Filters:**
   - Search bar to quickly find stocks
   - Filtering options based on highest/lowest price and biggest earners/losers.

6. **Notifications:**
   - Live action notification on ios (currently unavailable due to payment/high cost)

7. **User Authentication:**
   - Secure login and registration process
   - Password encryption

8. **Data & API Integration:**
   - Integration with self-made backend using spring boot

### Performance & Scalability:

- **Database:** Utilize efficient database systems (PostgreSQL databases) for storing user data, transaction history, and other app-related data.
- **Scalability:** Design the backend infrastructure to handle a growing number of users and increased data traffic.

### Security:

- **Data Encryption:** Ensure that sensitive user data, including passwords and financial transactions, are encrypted.

### Accessibility:

- Ensure the app is usable for people with disabilities:
  - Screen reader compatibility
  - Font size adjustment
  - High-contrast themes


## Folder Structure
```plaintext
Investmate/
│
├── lib/
│   ├── images/
│   │   └── Investmate.png
│   │   └── InvestmentBro.png
│   │
│   ├── models/
│   │   └── portfolio_history.dart
│   │   └── portfolio.dart
│   │   └── stock_history.dart
│   │   └── stock_list_model.dart
│   │   └── stock_purchase.dart
│   │   └── stock.dart
│   │   └── user.dart
│   │
│   ├── providers/
│   │   └── token_manager.dart
│   │   └── user_provider.dart
│   │
│   ├── widgets/
│   │   ├── components/
│   │   │   └── flush_bar.dart
│   │   │   └── login_button.dart
│   │   │   └── navigation_bar.dart
│   │   │   └── pop_up_menu_profile.dart
│   │   │
│   │   ├── screens/
│   │   │   └── add_list.dart
│   │   │   └── explore.dart
│   │   │   └── inventory.dart
│   │   │   └── log_in.dart
│   │   │   └── main_page.dart
│   │   │   └── my_lists.dart
│   │   │   └── new_user.dart
│   │   │   └── sign_up.dart
│   │   │   └── splash.dart
│   │   │   └── stock_detail.dart
│   │   │   └── stock_watchlist_page.dart
│   │   │
│   │   ├── stock_components/
│   │   │   └── portfolio_chart.dart
│   │   │   └── stock_card.dart
│   │   │   └── stock_chart.dart
│   │   │   └── stock_item.dart
│   │   │   └── stock_list.dart
│   │   │
│   │   └── stock_list_components/
│   │       └── stock_list_item.dart
│   │
│   ├── globals.dart
│   ├── main.dart
│
├── pubspec.yaml
└── README.md
```
### Class Diagram Back-End
![image](https://github.com/IDATA2503-Mobile-Applikasjoner/aksje_app/assets/99326286/f6b4ff68-607b-4a11-84b2-23a52d9db4c9)

### Domain Diagram Database
![image](https://github.com/IDATA2503-Mobile-Applikasjoner/aksje_app/assets/99326286/a7206c90-28c7-4c9e-94ba-3b7f8189e695)

## Conclusion

Investmate represents the culmination of our learning and efforts in the IDATA2503 - Mobile Applications course at NTNU. This project, centered around a stock trading simulation app, has provided us with invaluable experience in mobile app development, from conceptualization to implementation. While Investmate serves as a simulated platform for stock trading, its primary purpose has been educational, allowing us as students to apply our skills in a practical setting. We appreciate the opportunity to develop this project and are thankful for the insights gained during the process.

---

For more documentation regarding Investmate, please visit our wiki page [Investmate wiki](https://github.com/IDATA2503-Mobile-Applikasjoner/aksje_app/wiki).


  
