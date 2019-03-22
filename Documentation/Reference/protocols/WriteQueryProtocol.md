**PROTOCOL**

# `WriteQueryProtocol`

```swift
public protocol WriteQueryProtocol
```

## Methods
### `createTableIfNotExists(using:)`

```swift
func createTableIfNotExists(using connection: Connection) throws
```

### `run(persisting:using:)`

```swift
func run(persisting model: Model, using connection: Connection) throws
```
