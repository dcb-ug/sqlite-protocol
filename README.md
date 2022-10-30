# SQLiteProtocol

## Usage

Assuimg we have the following model:

```swift
struct User {
    let username: String
    let role: String
}
```

### Make Persistable

We can make that user persisitable by conforming to the `Persistable` Protocol.

```swift
extension User: Persistable {
    // define a adapter type `Colums` that can map between the database and the model
    struct Columns: ColumnSchema {
        var username: String = ""
        var role: String = ""
        
        // a primary column is required
        // it sets the name it has in the database,
        // the key in this model
        // and how the value is retrieved from the user model
        static let primaryColumn = PrimaryColumn<User, Columns, String>("username", \.username) { $0.username
        }

        // also a list of column builders
        // the builders are set up the same way as the primary key
        static let columns: [Builder<User, Columns>] = [
            Builder("role", \.role) { $0.role },
        ]
        
    }
    
    // define an initalizer that can create a model type from our adapter type
    init(databaseColumns columns: Columns) throws {
        self.username = columns.username
        self.role = columns.role
    }
}
```

### Persist

```swift
    let database = Database()

    // write one
    let user = User(username: "my-user", role: "admin")
    try? database.write(.createOrUpdate, user)
    
    // write many
    let users = [
        User(username: "user-1", role: "user"),
        User(username: "user-2", role: "user"),
        User(username: "user-3", role: "user"),
    ]
    try? database.write(.createOrUpdate, users)
```

### Query

```swift
    let database = Database()
    
    // read first
    let firstUser = try? database.read(.first, ofType: User.self)
    
    // read by primary key
    let myUser = try? database.read(.withPrimaryKey("my-user"), ofType: User.self)

    // read all
    let allUsers = try? database.read(.all, ofType: User.self)
```

### Delete

```swift
    let database = Database()
    
    // delete by primary key
    try? database.delete(.where(primaryKey: "my-user"), ofType: User.self)
    
    // delete mutiple by primary keys
    try? database.delete(.where(primaryKeys: ["user-1", "user-2"]), ofType: User.self)
    
    // delete by comparing model
    // this simply compares the value defined as the primary key
    let user = User(username: "my-user", role: "admin")
    try? database.delete(.model(user), ofType: User.self)
    
    // delete by comparring multiple models
    // this simply compares the values defined as the primary key
    let users = [
        User(username: "user-1", role: "user"),
        User(username: "user-1", role: "user")
    ]
    try? database.delete(.models(users), ofType: User.self)
    
    // delete all
    try? database.delete(.all, ofType: User.self)
```

## Install

**Package.swift:**
```swift
dependencies: [
    // …
    .package(url: "https://github.com/dcb-ug/sqlite-protocol.git", from: "1.1.0"),
],
// …
targets: [
    .target(
        name: "YOUR_TARGET",
        dependencies: ["SQLiteProtocol"]
    ),
]
```
