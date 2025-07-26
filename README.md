# Swift URL Form Coding URL Routing

URLRouting extensions for swift-url-form-coding that provide seamless integration between form data handling and type-safe URL routing.

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%2010.15%20|%20iOS%2013%20|%20tvOS%2013%20|%20watchOS%206-blue.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

## Features

### 🔗 **URLRouting Integration**
- **Seamless Integration**: First-class support for Point-Free's URLRouting library
- **Conversion Protocol**: Easy integration with routing systems via the `Conversion` protocol
- **Type-Safe Routes**: Define routes with compile-time guarantees for form data handling

### 🔒 **Type-Safe Form Handling**
- **URL Form Encoding/Decoding**: Complete support for `application/x-www-form-urlencoded` data
- **Custom Parsing Strategies**: Flexible handling of nested objects, arrays, and complex data structures
- **Swift 6 Compatibility**: Full support for Swift's latest concurrency and type safety features

## Quick Start

### Installation

Add `swift-url-form-coding-url-routing` to your Swift package:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-url-form-coding-url-routing.git", from: "0.0.1")
]
```

### Basic Form Handling

```swift
import URLRouting
import URLFormCoding
import URLFormCodingURLRouting

// Define your data model
struct LoginRequest: Codable {
    let username: String
    let password: String
    let rememberMe: Bool
}

// Create a form conversion
let loginForm = Conversion.form(LoginRequest.self)

// Use in route definition
let loginRoute = Route {
    Method.post
    Path { "login" }
    Body(loginForm)
}

// Handle form data
let formData = "username=john&password=secret&rememberMe=true"
let request = try loginForm.apply(Data(formData.utf8))
print(request.username) // "john"
```

### Advanced Form Handling

```swift
import URLRouting
import URLFormCoding
import URLFormCodingURLRouting

// Configure custom decoder
let decoder = Form.Decoder()
decoder.parsingStrategy = .brackets  // Supports user[profile][name]=value
decoder.dateDecodingStrategy = .iso8601

// Create form with custom configuration
let advancedForm = Conversion.form(
    ComplexUser.self,
    decoder: decoder
)

// Use in route definition
let complexRoute = Route {
    Method.post
    Path { "users" }
    Body(advancedForm)
}
```

## Advanced Usage

### Custom Form Decoding Strategies

```swift
// Configure decoder for nested objects
let decoder = Form.Decoder()
decoder.parsingStrategy = .brackets  // Supports user[profile][name]=value
decoder.dateDecodingStrategy = .iso8601
decoder.arrayDecodingStrategy = .brackets

let customForm = Conversion.form(
    ComplexUser.self,
    decoder: decoder
)
```

### Supported Parsing Strategies

| Strategy | Example | Use Case |
|----------|---------|----------|
| **Default** | `name=value&age=30` | Simple key-value pairs |
| **Brackets** | `user[name]=John&user[age]=30` | Nested objects |
| **Accumulate** | `tags=swift&tags=ios&tags=web` | Multiple values per key |

### Chaining Conversions

```swift
// Chain multiple conversions together
let stringToUser = Conversion<String, Data>.utf8
    .form(User.self)

// Use in route definition
let chainedRoute = Route {
    Method.post
    Path { "users" }
    Body(stringToUser)
}
```

## Core Components

### Form.Conversion

The main conversion type for URLRouting integration:

```swift
// Basic form conversion
let userForm = Form.Conversion(User.self)

// Custom configuration
let encoder = Form.Encoder()
let decoder = Form.Decoder()

let customForm = Form.Conversion(
    User.self,
    decoder: decoder,
    encoder: encoder
)
```

### URLRouting Extensions

Convenience methods for creating form conversions:

```swift
// Static method for creating conversions
let userForm = Conversion.form(User.self)

// With custom configuration
let advancedForm = Conversion.form(
    User.self,
    decoder: customDecoder,
    encoder: customEncoder
)

// Chain with other conversions
let processedForm = Conversion<String, Data>.utf8
    .form(User.self)  // Data to User
```

## Security Features

### Form Data Security

- **Input Validation**: Automatic validation of form field types and formats
- **URL Decoding**: Proper handling of URL-encoded data with security considerations
- **Memory Safety**: Efficient parsing that prevents buffer overflows
- **Type Safety**: Compile-time guarantees for form data structure

## Error Handling

```swift
do {
    let user = try formDecoder.decode(User.self, from: formData)
} catch let error as Form.Decoder.Error {
    switch error {
    case .invalidFormat:
        print("Invalid form data format")
    case .missingRequiredField(let field):
        print("Missing required field: \(field)")
    case .typeMismatch(let field, let expectedType):
        print("Type mismatch for \(field), expected \(expectedType)")
    }
}

// Form conversions integrate seamlessly with URLRouting error handling
do {
    let user = try Conversion.form(User.self).apply(formData)
    // Handle successful conversion
} catch {
    // Handle any conversion errors
    print("Form conversion failed: \(error)")
}
```

## Testing

The library includes comprehensive test suites:

```bash
swift test
```

Test coverage includes:
- ✅ URL form encoding/decoding with various data types
- ✅ URLRouting integration and conversion protocols
- ✅ Error handling scenarios
- ✅ Custom parsing strategies
- ✅ Round-trip data integrity
- ✅ Edge cases and Unicode handling

## Requirements

- **Swift**: 6.0+
- **Platforms**: macOS 10.15+, iOS 13.0+, tvOS 13.0+, watchOS 6.0+
- **Dependencies**: 
  - [swift-url-routing](https://github.com/pointfreeco/swift-url-routing) (0.6.0+)
  - [swift-url-form-coding](https://github.com/coenttb/swift-url-form-coding) (0.0.1+)
  - [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) (1.1.5+)

## Related Projects

### The coenttb Stack

* [swift-url-form-coding](https://github.com/coenttb/swift-url-form-coding): Type-safe form data encoding/decoding
* [swift-css](https://github.com/coenttb/swift-css): A Swift DSL for type-safe CSS
* [swift-html](https://github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS
* [swift-web](https://github.com/coenttb/swift-web): Foundational web development tools
* [coenttb-web](https://github.com/coenttb/coenttb-web): Enhanced web development functionality
* [coenttb-server](https://github.com/coenttb/coenttb-server): Modern server development tools

### PointFree Foundations

* [swift-url-routing](https://github.com/pointfreeco/swift-url-routing): Type-safe URL routing
* [swift-dependencies](https://github.com/pointfreeco/swift-dependencies): Dependency management system

## Contributing

Contributions are welcome! Please feel free to:

1. **Open Issues**: Report bugs or request features
2. **Submit PRs**: Improve documentation, add features, or fix bugs  
3. **Share Feedback**: Let us know how you're using the library

## License

This project is licensed under the **Apache 2.0 License**. See [LICENSE](LICENSE) for details.

## Feedback & Support

Your feedback makes this project better for everyone!

> [Subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe)
>
> [Follow me on X](http://x.com/coenttb)
> 
> [Connect on LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp)

---

**swift-url-form-coding-url-routing** - URLRouting extensions for seamless form data handling in modern Swift applications.
