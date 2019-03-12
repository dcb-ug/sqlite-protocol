**PROTOCOL**

# `Persistable`

```swift
public protocol Persistable
```

## Properties
### `databaseRowSelector`

```swift
var databaseRowSelector: Expression<Bool>
```

## Methods
### `init(databaseRow:)`

```swift
init(databaseRow: Row) throws
```

### `schema(tableBuilder:)`

```swift
static func schema(tableBuilder: TableBuilder)
```
