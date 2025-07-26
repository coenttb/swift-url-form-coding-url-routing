//
//  File.swift
//  swift-url-form-coding-url-routing
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Foundation
import Parsing
import URLRouting
import URLFormCoding


/// A conversion that handles URL form data encoding and decoding for URLRouting.
///
/// `FormCoding` provides seamless conversion between Swift Codable types and
/// URL-encoded form data (application/x-www-form-urlencoded format). It's the
/// standard format used by HTML forms and many web APIs.
///
/// ## Overview
///
/// This conversion integrates `Form.Encoder` and `Form.Decoder` with URLRouting's
/// conversion system, enabling automatic form data handling in route definitions.
/// It supports all standard form data features including nested objects, arrays,
/// and custom encoding strategies.
///
/// ## Basic Usage
///
/// ```swift
/// struct ContactForm: Codable {
///     let name: String
///     let email: String
///     let message: String
/// }
///
/// // Create form conversion
/// let formConversion = FormCoding(ContactForm.self)
///
/// // Use in route definition
/// Route {
///     Method.post
///     Path { "contact" }
///     Body(formConversion)
/// }
/// ```
///
/// ## Advanced Configuration
///
/// ```swift
/// // Custom decoder for nested data
/// let decoder = Form.Decoder()
/// decoder.parsingStrategy = .brackets  // Supports user[name]=value
/// decoder.dateDecodingStrategy = .iso8601
///
/// // Custom encoder for response data
/// let encoder = Form.Encoder()
/// encoder.dateEncodingStrategy = .iso8601
/// encoder.arrayEncodingStrategy = .brackets
///
/// let advancedForm = FormCoding(
///     ContactForm.self,
///     decoder: decoder,
///     encoder: encoder
/// )
/// ```
///
/// ## Supported Data Types
///
/// - **Basic types**: String, Int, Double, Bool, etc.
/// - **Optional values**: Automatically handled
/// - **Nested objects**: With appropriate parsing strategies
/// - **Arrays**: Multiple encoding/decoding strategies available
/// - **Dates**: Configurable date formatting strategies
/// - **Data**: Base64 or custom encoding strategies
///
/// ## Parsing Strategies
///
/// - **Default**: Simple key=value pairs
/// - **Brackets**: Nested data using user[name]=value
/// - **Accumulate Values**: Multiple values for same key
/// - **Custom**: User-defined parsing logic
///
/// - Note: The encoder and decoder can be configured independently with different strategies.
/// - Important: Ensure encoder and decoder strategies are compatible for round-trip operations.
extension Form {
    public struct Conversion<Value: Codable>  {
        /// The URL form decoder used for parsing form data.
        public let decoder: Form.Decoder
        
        /// The URL form encoder used for generating form data.
        public let encoder: Form.Encoder

        /// Creates a new form coding conversion.
        ///
        /// - Parameters:
        ///   - type: The Codable type to convert to/from form data
        ///   - decoder: Custom URL form decoder (optional, uses default if not provided)
        ///   - encoder: Custom URL form encoder (optional, uses default if not provided)
        ///
        /// ## Default Configuration
        ///
        /// When using default encoder/decoder:
        /// - Simple key=value parsing
        /// - ISO8601 date handling
        /// - Base64 data encoding
        /// - Standard array handling
        ///
        /// ## Custom Configuration Example
        ///
        /// ```swift
        /// let decoder = Form.Decoder()
        /// decoder.parsingStrategy = .brackets
        /// decoder.dateDecodingStrategy = .secondsSince1970
        ///
        /// let encoder = Form.Encoder()
        /// encoder.arrayEncodingStrategy = .indexedBrackets
        /// encoder.dateEncodingStrategy = .secondsSince1970
        ///
        /// let formCoding = FormCoding(
        ///     MyModel.self,
        ///     decoder: decoder,
        ///     encoder: encoder
        /// )
        /// ```
        @inlinable
        public init(
            _ type: Value.Type,
            decoder: Form.Decoder = .init(),
            encoder: Form.Encoder = .init()
        ) {
            self.decoder = decoder
            self.encoder = encoder
        }
    }
}



extension Form.Conversion: URLRouting.Conversion {
    /// Converts URL form data to a Swift value.
    ///
    /// This method parses URL-encoded form data and converts it to the specified
    /// Swift type using the configured decoder.
    ///
    /// - Parameter input: The URL-encoded form data to decode
    /// - Returns: The decoded Swift value
    /// - Throws: `Form.Decoder.Error` if the data cannot be decoded
    ///
    /// ## Form Data Format
    ///
    /// Expects data in application/x-www-form-urlencoded format:
    /// ```
    /// name=John%20Doe&email=john%40example.com&age=30
    /// ```
    ///
    /// ## Error Handling
    ///
    /// ```swift
    /// do {
    ///     let user = try formCoding.apply(formData)
    /// } catch let error as Form.Decoder.Error {
    ///     // Handle decoding errors
    ///     print("Form decoding failed: \(error)")
    /// }
    /// ```
    @inlinable
    public func apply(_ input: Foundation.Data) throws -> Value {
        try decoder.decode(Value.self, from: input)
    }

    /// Converts a Swift value to URL form data.
    ///
    /// This method encodes a Swift value to URL-encoded form data using
    /// the configured encoder.
    ///
    /// - Parameter output: The Swift value to encode
    /// - Returns: The URL-encoded form data as `Data`
    /// - Throws: `Form.Encoder.Error` if the value cannot be encoded
    ///
    /// ## Generated Format
    ///
    /// Produces standard URL-encoded form data:
    /// ```
    /// name=Jane%20Smith&email=jane%40example.com&active=true
    /// ```
    ///
    /// ## Error Handling
    ///
    /// ```swift
    /// do {
    ///     let formData = try formCoding.unapply(user)
    /// } catch let error as Form.Encoder.Error {
    ///     // Handle encoding errors
    ///     print("Form encoding failed: \(error)")
    /// }
    /// ```
    @inlinable
    public func unapply(_ output: Value) throws -> Foundation.Data {
        try encoder.encode(output)
    }
}
