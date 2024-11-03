# Dyson
Dyson is a layer-based networking framework that operates on top of network modules, similar to [Moya]("https://github.com/Moya/Moya"). Dyson is designed to simplify the management and usage of network communication code, such as APIs, for your convenience.

- [Dyson](#dyson)
- [Requirements](#requirements)
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
- [Basic Usage](#basic-usage)
  - [NetworkProvider](#networkprovider)
  - [Responser](#responser)
  - [Interceptor](#interceptor)
    - [Request intercept](#request-intercept)
    - [Response intercept](#response-intercept)
    - [Data intercept](#data-intercept)
  - [Spec](#spec)
    - [Transaction](#transaction)
    - [Request](#request)
    - [Mapper](#mapper)
- [Contribution](#contribution)
- [License](#license)

# Requirements
- iOS 13.0+
- macOS 10.15+

# Installation
### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/wlsdms0122/Dyson.git", .upToNextMajor("2.0.0"))
]
```

# Basic Usage
You should start by creating a `Dyson` object. `Dyson` takes parameters such as `NetworkProvider` and `Interceptor`, which will be discussed below.
```swift
let dyson = Dyson(
    provider: .url(),
    defaultHeaders: [
        "Content-Type": "application/json"
    ],
    interceptors: [
        LogInterceptor()
    ]
)
```

And `Dyson` provides two methods for API requests, `response(_:pogress:requestModifier:completion:)` and `data(_:pogress:requestModifier:completion:)`.

The difference between the two is the return type.  Use `response()` if you want to get the network raw response itself from the provider, or `data()` if you want to get the decoded result of the response.
```swift
dyson.response(GetInfoSpec(.init())) { result in
    // result's type is Result<(Data, URLResponse), any Error>
}

dyson.data(GetInfoSpec(.init())) { result in
    // result's type is Result<GetInfoSpec.Result, any Error>
}
```

## NetworkProvider
`NetworkProvider` is the protocol that abstracts the functionality of network communication.

`Dyson` is a layer that works on top of these communication modules, so you can create different providers just like you would with [Alamofire](https://github.com/Alamofire/Alamofire).
```swift
public protocol NetworkProvider {
    func dataTask(with request: URLRequest) -> any DataSessionTask
    func uploadTask(with request: URLRequest, from data: Data) -> any DataSessionTask
    func downloadTask(with request: URLRequest) -> any DataSessionTask
}
```

`Dyson` serve default network provider, `URLNetworkProvider` that implemented using `URLSession`.

## Responser
`Responser` is a protocol that abstracts how to respond to a network response.

Responsible for the implementation of how to handle the conventions for network responses between servers and clients.

```swift
public protocol Responser {
    func response<S: Spec>(
        _ response: Result<(Data, URLResponse), any Error>,
        spec: S
    ) throws -> S.Result
}
```

For example, you might need to filter by a range of status codes with your own communication protocols, or parse response data and header values together.

These characteristics usually depend on the server you're communicating with (just as different OpenAPIs have different communication protocols).

Typically, the implementation of a 'responser' looks like this.

```swift
func response<S: Spec>(
    _ response: Result<(Data, URLResponse), any Error>,
    spec: S
) throws -> S.Result {
    switch response {
        case let .success((data, response)):
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            // Check valid status code.
            guard (200..<300).contains(httpResponse.statusCode) else {
                // Parse to error model.
                do {
                    return try spec.error.map(data)
                } catch {
                    throw error
                }
            }
            
            // Parse to result model.
            do {
                return try spec.result.map(data)
            } catch {
                throw error
            }
            
        case let .failure(error):
            throw error
        }
}
```

## Interceptor
The `interceptor` is the most important feature of `Dyson`. Basically, an interceptor can modify a request before it is made, or intercept a response before it is completed.
```swift
public protocol Interceptor {
    /// Called before the request.
    func request(
        _ request: URLRequest,
        dyson: Dyson,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<URLRequest>
    )
    /// Called after receiving the response and before completion.
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        dyson: Dyson,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<Result<(Data, URLResponse), any Error>>
    )
    /// When request with `data(_:)`, called after receiving the response and before completion.
    /// `response(_:dyson:sepc:sessionTask:continuation:)` shoule be call before this.
    func result<S: Spec>(
        _ result: Result<S.Result, any Error>,
        dyson: Dyson,
        spec: S,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<Result<S.Result, any Error>>
    )
}
```

Registered all interceptors are called in the order `request` -> `response` -> `result`(only `data(_:)` request).

### Request intercept
The `request` intercept is useful for modifying requests. Such as modifying or adding header fields for authentication.

```swift
public struct HeaderInterceptor: Interceptor {
    // MARK: - Property
    private let key: String
    private let value: () -> String?
    
    // MARK: - Initializer
    public init(key: String, value: @escaping () -> String?) {
        self.key = key
        self.value = value
    }
    
    public init(key: String, value: String) {
        self.init(key: key) { value }
    }
    
    // MARK: - Public
    public func request(
        _ request: URLRequest,
        dyson: Dyson,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<URLRequest>
    ) {
        var request = request
        request.setValue(value(), forHTTPHeaderField: key)
        
        continuation(request)
    }
    
    // MARK: - Private
}
```

### Response intercept
The `response` intercept is useful when you need to do additional work before completing the response.

A good example would be for processes like JWT authentication.

```swift
func response(
    _ response: Result<(Data, URLResponse), any Error>,
    dyson: Dyson,
    spec: some Spec,
    sessionTask: ContainerSessionTask,
    continuation: Continuation<Result<(Data, URLResponse), any Error>>
) {
    guard case let .success((_, r)) = response,
        let httpResponse = r as? HTTPURLResponse
    else {
        // Finish this intercept and keep response process.
        continuation(response)
        return
    }
    
    guard httpResponse.statusCode == 401 else {
        // Finish this intercept and keep response process.
        continuation(response)
        return
    }
    
    sessionTask {
        // Request refresh spec for refreshing token.
        dyson.data(RefreshSpec(.init())) { result in
            switch result {
            case let .success(result):
                // Store new token.
                tokenStorage.set(result.token)
                
                sessionTask {
                    // Retry origin request.
                    dyson.response(spec) { result in
                        // Finish this intercept with new response.
                        continuation(result)
                    }
                }
                
            case let .failure(error):
                // Finish this intercept with throwing error.
                continuation(throwing: error)
            }
        }
    }
}
```

The first point of the above example is to show that you can initiate a new API request from an interceptor, because all of the interceptor's methods passed a continuation object for the process asynchronous task.

You must pass a result or an error via continue, and passing an error will cause this request to stop immediately.

The second is that the `ContainerSessionTask` can have child session tasks, which allow you to manage the entire request and ensure that when the request is canceled, all related requests are canceled.

### Data intercept
The `data` intercept is simillar with the `response` intercept.

It call only you request using `data(_:)` method. and all feature is same with the `response` intercept.

## Spec
The `Spec` represents a single API request. Most options for networking are set via `Spec`.
```swift
public protocol Spec {
    associatedtype Parameter
    associatedtype Result
    associatedtype Error: Swift.Error
    
    var parameter: Parameter { get }
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var transaction: Transaction { get }
    
    var headers: HTTPHeaders { get }
    
    var request: any Request { get }
    var responser: (any Responser)? { get }
    var result: Mapper<Result> { get }
    var error: Mapper<Error> { get }
}
```

Here is the sample `Spec`.
```swift
public struct GetInfoSpec: Spec {
    var baseURL: String { "https://your-server-url.com" }
    var path: String { "/info" }
    var method: HTTPMethod { .get }
    var transaction: Transaction { .data }
    var headers: HTTPSHeaders {
        [
            "Content-Type": "application/json"
        ]
    }
    var request: any Request { 
        .query([
            "id": parameter.id
        ])
    }
    var responser: (any Responser)? { YourServerResponser() }
    var result: Mapper<Result> { .codable }
    var error: Mapper<Error> { .codable }

    let parameter: Parameter

    public init(_ parameter: Parameter) {
        self.parameter = parameter
    }
}

public extension GetInfoSpec {
    public struct Parameter {
        let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public struct Result: Decodable {
        let name: String
    }
}
```

### Transaction
The `Transaction` is type of request. It offers three types, such as `URLSession`.
- `data`
- `upload(Data)`
- `download`

### Request
The `Request` indicates the method for creating the request.
```swift
public protocol Request {
    func make(url: URL) throws -> URLRequest
}
```

The `Dyson` serve some requests.
- none </br>
  Not exist additional process.
- query(_:isEncoded:) </br>
  Add the query parameters as a query to the URL.
- body(_:encoder:) </br>
  After encoding with the encoder, add the parameters as data to the HTTP body. </br>
  You can create your own encoder that adopts the `Encode` protocol.

### Mapper
The `Mapper` is a type that represents how you want to transform your data.
```swift
public protocol Map<Value> {
    associatedtype Value
    
    func map(_ data: Data) throws -> Value
}
```
Indicates the decode method, and `Dyson` provides the `Codable` type by default.

You can create your own `Mapper` that adopts the `Map` protocol.


# Contribution
Any ideas, issues, opinions are welcome.

# License
Dyson is available under the MIT license. See the LICENSE file for more info.
