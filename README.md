# MovieApp

iOS application for browsing movies, reviews, and trailers using The Movie Database (TMDB) API.

## API Key Configuration

To run the app with TMDB data, you need to provide your TMDB API Read Access Token (v4).

1. Open `MovieApp/Core/APIConfig.swift`.
2. Replace `readAccessToken` with your token:

```swift
public static let readAccessToken = "YOUR_TMDB_READ_ACCESS_TOKEN"
```

You can get this token from your TMDB account under Settings > API > API Read Access Token (v4 auth).

## Requirements

- Xcode 15 or later
- iOS 17+
