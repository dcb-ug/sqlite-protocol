**CLASS**

# `DefaultWriteQuery`

```swift
public final class DefaultWriteQuery<Model: Persistable>: WriteQueryProtocol
```

## Methods
### `_createOrUpdateFunction(model:connection:)`

```swift
public static func _createOrUpdateFunction(model: Model, connection: Connection) throws
```

> this is exposed like this so you can use it when building your own queries

### `run(persisting:using:)`

```swift
public func run(persisting model: Model, using connection: Connection) throws
```
