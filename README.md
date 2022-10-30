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
    // create User model from database column
    init(databaseColumns columns: Columns) throws {
        self.username = columns.username
        self.role = columns.role
    }
    
    // define the representation inside the database
    struct Columns: ColumnSchema {
        var username: String
        var role: String
        
        static let columns: [Builder<User, Columns>] = [
            Builder("username", \.username) { $0.username },
            Builder("role", \.role) { $0.role },
        ]
        
        static let primaryColumn = PrimaryColumn<User, Columns, String>("username", \.username) {
          $0.username
        }

        init() {
            self.username = ""
            self.role = ""
        }
        
        init(model user: User) {
            username = user.username
            role = user.role
        }
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
    
    // delete by referencing model instance
    let user = User(username: "my-user", role: "admin")
    try? database.delete(.model(user), ofType: User.self)
    
    // delete by referencing multiple model instances
    let users = [
        User(username: "user-1", role: "user"),
        User(username: "user-1", role: "user")
    ]
    try? database.delete(.models(users), ofType: User.self)
    
    // delete by primary key
    try? database.delete(.where(primaryKey: "my-user"), ofType: User.self)
    
    // delete mutiple by primary keys
    try? database.delete(.where(primaryKeys: ["user-1", "user-2"]), ofType: User.self)
    
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
