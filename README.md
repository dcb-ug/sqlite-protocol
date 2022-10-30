# SQLiteProtocol

## Usage

Assuimg wer have the following model:

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
    do {
        try database.write(.createOrUpdate, user)
    } catch (let e) {
        print(e)
    }
    
    // write many
    let users = [
        User(username: "user-1", role: "user"),
        User(username: "user-2", role: "user"),
        User(username: "user-3", role: "user"),
    ]
    do {
        try database.write(.createOrUpdate, users)
    } catch (let e) {
        print(e)
    }
```

### Query

```swift
    let database = Database()
    
    // read first
    let firstUser = try? database.read(.first, ofType: User.self)
    if let firstUser = firstUser {
        print(firstUser)
    }
    
    // read by primary key
    let myUser = try? database.read(.withPrimaryKey("my-user"), ofType: User.self)
    if let myUser = myUser {
        print(myUser)
    }

    // read all
    let allUsers = try? database.read(.all, ofType: User.self)
    if let allUsers = allUsers {
        print(allUsers)
    }
```

### Delete

```swift
    let database = Database()
    
    // delete by referencing model instance
    let user = User(username: "my-user", role: "admin")
    do {
        try database.delete(.model(user), ofType: User.self)
    } catch (let e) {
        print(e)
    }
    
    // delete by referencing multiple model instances
    let users = [
        User(username: "user-1", role: "user"),
        User(username: "user-1", role: "user")
    ]
    do {
        try database.delete(.models(users), ofType: User.self)
    } catch (let e) {
        print(e)
    }
    
    // delete by primary key
    do {
        try database.delete(.where(primaryKey: "my-user"), ofType: User.self)
    } catch (let e) {
        print(e)
    }
    
    // delete mutiple by primary keys
    do {
        try database.delete(.where(primaryKeys: ["user-1", "user-2"]), ofType: User.self)
    } catch (let e) {
        print(e)
    }
    
    // delete all
    do {
        try database.delete(.all, ofType: User.self)
    } catch (let e) {
        print(e)
    }
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
