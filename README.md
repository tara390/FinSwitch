# FinSwitch - Complete Financial Calculator App

FinSwitch is a comprehensive financial calculator app built with Flutter that provides all-in-one financial calculation tools including RD (Recurring Deposit), FD (Fixed Deposit), Loan EMI calculations, and real-time currency conversion.

## 🚀 Features

### 1. **Recurring Deposit (RD) Calculator**
- Calculate maturity amount for recurring deposits
- Compound interest calculations
- Detailed breakdown of total deposits vs interest earned
- Visual representation of investment growth
- Support for various tenure periods

### 2. **Fixed Deposit (FD) Calculator**
- Calculate maturity amount for fixed deposits
- Both simple and compound interest options
- Quarterly compounding for compound interest
- Investment summary with return percentage
- Flexible tenure selection

### 3. **Loan EMI Calculator**
- Calculate monthly EMI for loans
- Detailed amortization schedule
- Principal vs interest breakdown
- Total interest burden calculation
- Month-by-month payment schedule

### 4. **Currency Converter**
- Real-time currency conversion
- Support for 20+ popular currencies
- Exchange rate information with last updated time
- Quick convert options for popular currencies
- Offline fallback with cached rates

## 🎨 Design Features

- **Professional UI/UX**: Clean, modern design with intuitive navigation
- **Material Design 3**: Latest Material Design principles
- **Responsive Layout**: Works on all screen sizes
- **Custom Color Scheme**: Financial-themed green color palette
- **Google Fonts**: Beautiful Poppins font family
- **Smooth Animations**: Engaging user interactions
- **Dark/Light Theme Ready**: Theme support infrastructure

## 🛠️ Technical Architecture

### **Project Structure**
```
lib/
├── models/
│   └── financial_models.dart      # Data models for calculations
├── services/
│   └── currency_service.dart      # Currency API service
├── screens/
│   ├── home_screen.dart          # Main dashboard
│   ├── rd_calculator_screen.dart # RD calculator
│   ├── fd_calculator_screen.dart # FD calculator
│   ├── loan_calculator_screen.dart # Loan calculator
│   └── currency_converter_screen.dart # Currency converter
├── utils/
│   ├── app_constants.dart        # App constants and theme
│   └── helpers.dart              # Utility functions
├── widgets/
│   └── custom_widgets.dart       # Reusable UI components
└── main.dart                     # App entry point
```

### **Key Dependencies**
- `flutter`: UI framework
- `http`: API calls for currency rates
- `intl`: Number and date formatting
- `shared_preferences`: Local data storage
- `google_fonts`: Typography

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.7.2)
- Dart SDK
- Android Studio / VS Code
- Chrome (for web development)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd finswitch
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For web
flutter run -d chrome

# For Windows
flutter run -d windows

# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

### Building for Production

```bash
# Web
flutter build web

# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# Windows
flutter build windows

# iOS
flutter build ios
```

## 📱 App Features

### Home Screen
- Clean dashboard with feature cards
- Quick access to all calculators
- App statistics and information

### RD Calculator
- Input fields for monthly amount, interest rate, and tenure
- Real-time calculation results
- Detailed investment summary

### FD Calculator
- Principal amount and tenure input
- Simple vs compound interest selection
- Maturity amount breakdown

### Loan Calculator
- Loan amount, rate, and tenure input
- EMI calculation with total interest
- Detailed amortization schedule

### Currency Converter
- Amount input with currency selection
- Real-time exchange rates
- Popular currency quick access

## 🔧 Configuration

### API Configuration
The app uses ExchangeRate-API for currency conversion:
- Base URL: `https://api.exchangerate-api.com/v4/latest`
- Fallback: Mock data for offline usage
- Cache: 1-hour cache for exchange rates

### Customization
- **Colors**: Modify `AppConstants` in `utils/app_constants.dart`
- **Fonts**: Change Google Fonts in `main.dart`
- **Features**: Add new calculators in `screens/` directory

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Widget tests
flutter test test/widget_test.dart
```

## 📈 Performance

- **Fast Calculations**: Optimized mathematical formulas
- **Efficient UI**: Minimal rebuilds with proper state management
- **Caching**: Smart caching for currency rates
- **Responsive**: Smooth performance on all devices

## 🔒 Security & Privacy

- **No Personal Data**: App doesn't collect personal information
- **Local Storage**: Calculations stored locally only
- **API Security**: Secure HTTPS connections for currency data
- **Offline Support**: Works without internet for basic calculations

---

**FinSwitch** - Your Complete Financial Calculator 💰📊
