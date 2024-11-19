# Solar Monitoring Tool - Flutter Technical Challenge

## Getting Started

### Prerequisites

- **Docker** is required to run the API.
- **Flutter SDK** is required to run the mobile app. **Flutter 3.24.3 • channel stable** has been used for this app, with **Dart 3.5.3**

   - Tested on simulators: 
      **iPhone 16 Pro Max (iOS 18.1)**
      **iPhone 15 (iOS 17.5)**

### Running the Mobile App

1. Make sure Docker is running and the API is accessible at `http://localhost:3000`.
2. Clone this repository and open the project in your preferred IDE.
3. The environment is pre-configured to run on both iOS and Android platforms.
   - Tested on simulators: 
      **iPhone 16 Pro Max (iOS 18.1)**
      **iPhone 15 Pro Max (iOS 17.5)**
4. If you need to change the API's base URL, update the `BASE_URL` in the `api_client.dart` file.

## Features

### Core Functionalities

- **Graph and Data Visualization**:
  - Three tabs for viewing data:
    1. **Solar Generation**
    2. **Household Energy Consumption**
    3. **Battery Energy Consumption**
  - Each graph shows a line chart with the x-axis representing datetime and the y-axis values in watts.
  - Unit switching is supported (Watts <-> Kilowatts).

- **Date Filtering**:
  - Filter data by date using the left/right arrow or by tapping on the date to open the adaptive date picker.
  - Date restrictions: No future dates; a dynamic minimum date (2020-01-01).

- **Preloading and Caching**:
  - Data preloading for all tabs ensures smooth transitions.
  - Caching prevents unnecessary re-fetching
  - A refresh button clears the cached data, refreshes the data for the selected date, and invalidates all previously fetched dates, ensuring that data for other days is re-fetched immediately when the user navigates to them

- **Data Polling**:
  - Automatically refreshes the data every 60 seconds (configurable).

- **Pull-to-Refresh**:
  - Refresh the current screen's data using pull-to-refresh gesture.

- **Performance Optimizations**:
  - Grouped data by hour to calculate averages for a clearer and more performant visualization.

### Additional Functionalities
- **Dark Mode Support**.
- **Portrait and Landscape Orientation Support**.

## Technical Details
- **State Management**: Riverpod 
- **API Handling**: API communication is managed through a dedicated client using dio. The base URL can be configured.
- **Error Handling**: User-friendly error messages for connectivity issues.
- **Unit and Widget Testing**: Unit tests are included for business logic, along with widget tests for UI components.

## Trade-offs and Design Choices

### Data Grouping
The API provides data for every 5 minutes, which could overwhelm the visualization. For clarity and performance, the data is grouped hourly with average values calculated. This ensures that the line charts remain readable and performant without cluttering the interface.

### Polling Interval
The data polling interval is set to 60 seconds for testing purposes, but this can be adjusted based on requirements.

### Future Improvements
- Enhance data visualization by supporting more interactive graphs. (zoom and move through x axis)
- Consider integrating localization for broader audience reach.
- Consider adding **flutter_screenutil** to support dynamic design sizes for all screens.

