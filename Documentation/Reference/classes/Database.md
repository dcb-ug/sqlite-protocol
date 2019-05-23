**CLASS**

# `Database`

```swift
public final class Database
```

> Stores a shared Connection to a Database and provides functions to run read or write queries

## Methods
### `init()`

```swift
public init()
```

### `write(_:_:)`

```swift
public func write<Model: QueryProviding>(_ query: Model.WriteQuery, _ model: Model) throws
```

### `write(_:_:)`

```swift
public func write<Model: QueryProviding>(_ query: Model.WriteQuery, _ models: [Model]) throws
```

### `write(_:_:)`

```swift
public func write<Model: Persistable>(_ query: Model.WriteQuery, _ model: Model) throws
```

### `write(_:_:)`

```swift
public func write<Model: Persistable>(_ query: Model.WriteQuery, _ models: [Model]) throws
```

### `read(_:ofType:)`

```swift
public func read<Model: QueryProviding>(_ query: Model.ReadQuery, ofType: Model.Type) throws -> [Model]
```

### `read(_:ofType:)`

```swift
public func read<Model: Persistable>(_ query: Model.ReadQuery, ofType: Model.Type) throws -> [Model]
```

### `delete(_:ofType:)`

```swift
public func delete<Model: QueryProviding>(_ query: Model.DeleteQuery, ofType type: Model.Type) throws
```

### `delete(_:ofType:)`

```swift
public func delete<Model: Persistable>(_ query: Model.DeleteQuery, ofType type: Model.Type) throws
```
