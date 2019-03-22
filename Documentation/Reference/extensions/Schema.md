**EXTENSION**

# `Schema`

## Properties
### `primaryKeySelector`

```swift
public var primaryKeySelector: Expression<Bool>
```

## Methods
### `build(column:keyPath:)`

```swift
public static func build<Property: Value>(column name: String, keyPath: WritableKeyPath<Self, Property>) -> Column
```

### `build(column:keyPath:)`

```swift
public static func build<Property: Value>(column name: String, keyPath: WritableKeyPath<Self, Property?>) -> Column
```

### `buildTable(tableBuilder:)`

```swift
public static func buildTable(tableBuilder: TableBuilder)
```

### `from(row:)`

```swift
public static func from(row: Row) -> Self
```

### `primaryKeySelector(value:)`

```swift
public static func primaryKeySelector(value: PrimaryKeyType) -> Expression<Bool>
```
