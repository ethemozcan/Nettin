![Swift](https://github.com/ethemozcan/Nettin/workflows/Swift/badge.svg?branch=master)

# Nettin

Just a simple *incomplete* network client with json codable support. 

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/ethemozcan/Nettin.git", .upToNextMinor(from: "0.0.1"))
```

## Usage

```swift
import Nettin

var networkCodable: NetworkCodableProtocol

networkCodable.get(
    ModelStruct.self,
    url: URL(string: "http://api.domain.com")!,
    urlParameters: ["URLparam1", "URL param 2"],
    queryParameters: ["queryParam": "Queryparam value"],
    httpHeaders: ["headerParam": "header param value"]
) { result in

    switch result {
    case .failure(let error):
        print(error.localizedDescription)

    case .success(let modelValue):
        // Do something with the value
    }
}
```
