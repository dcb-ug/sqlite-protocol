**CLASS**

# `DefaultReadQuery`

```swift
public final class DefaultReadQuery<Model: Persistable>: ReadQueryProtocol
```

## Methods
### `_readFirst(using:)`

```swift
public static func _readFirst (using connection: Connection) throws -> [Model]
```

> this is exposed like this so you can use it when building your own queries

### `_read(withPrimaryKey:using:)`

```swift
public static func _read (withPrimaryKey key: Model.Columns.PrimaryKeyType,
                          using connection: Connection) throws -> [Model]
```

> this is exposed like this so you can use it when building your own queries

### `_readAll(using:)`

```swift
public static func _readAll (using connection: Connection) throws -> [Model]
```

> this is exposed like this so you can use it when building your own queries

### `swallowNoSuchTableError(function:)`

```swift
public static func swallowNoSuchTableError(function: () throws -> [Model]) rethrows -> [Model]
```

> this is exposed like this so you can use it when building your own queries

### `withPrimaryKey(_:)`

```swift
public static func withPrimaryKey(_ key: Model.Columns.PrimaryKeyType) -> DefaultReadQuery
```

### `run(using:)`

```swift
public func run(using connection: Connection) throws -> [Model]
```
