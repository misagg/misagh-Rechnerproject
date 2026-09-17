# Flutter Weather App

A simple weather application built with Flutter and Dart that retrieves current weather data from the OpenWeatherMap API.

## About the Project

This project was created to practice working with REST APIs, JSON data, and data modeling in Flutter.

The user can enter the name of a city and request its weather information. The application sends a request to the OpenWeatherMap API and displays the returned data in the Flutter interface.

The project currently uses the free OpenWeatherMap API plan, so the number of requests is subject to the limitations of that plan.

## Features

- Search for weather information by city name
- Fetch weather data from OpenWeatherMap
- Refresh weather information
- Handle JSON responses from the API
- Convert API data into custom Dart models
- Display the retrieved weather information in the UI

## Technologies

- Flutter
- Dart
- OpenWeatherMap API
- REST API
- JSON
- HTTP

## How It Works

The application follows a simple data flow:

1. The user enters a city name.
2. A request is sent to the OpenWeatherMap API.
3. The API returns the weather data as JSON.
4. The JSON response is mapped to custom Dart models.
5. The application uses these models to display the required information in the UI.
6. The user can refresh the data to make a new API request.

```text
User Input
    ↓
City Name
    ↓
API Request
    ↓
OpenWeatherMap
    ↓
JSON Response
    ↓
Dart Models
    ↓
Flutter UI
