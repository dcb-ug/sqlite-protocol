//
//  DefaultWriteQuery.swift
//  SQLiteProtocol
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultWriteQuery<Model: Persistable>: AnyWriteQuery<Model> {
    public static var delete: DefaultWriteQuery {
        return DefaultWriteQuery { model, database in
            let columns = Model.Columns(model: model)
            let row = DefaultWriteQuery.table.filter(columns.primaryKeySelector)
            try database.run(row.delete())
        }
    }

    public static var createOrUpdate: DefaultWriteQuery {
        return DefaultWriteQuery { model, database in
            let setters = Model.Columns.columns.map { $0.setterBuilder(model) }
            try database.run(DefaultWriteQuery.table.insert(or: .replace, setters))
        }
    }
}

//extension DefaultWriteQuery where Model: Sequence,
//                                  Model: Persistable,
//                                  Model.Element: Persistable,
//                                  Model.Element.WriteQuery: DefaultWriteQueryProviding {
//    public static var delete: DefaultWriteQuery {
//        return DefaultWriteQuery { models, database in
//            let table = Model.Element.WriteQuery.table
//            if Model.Element.WriteQuery.self == DefaultWriteQuery<Model.Element>.self {
//                // if the query for the sequence member is the default delete-query written above
//                // we can just select all rows and delte them at once
//                let columns = Model.Columns(model: models)
//                let row = table.filter(columns.primaryKeySelector)
//                try database.run(row.delete())
//            } else {
//                // but when we don't know the content and side effects of the delete-query
//                // we have to actually run it for each member of the sequence
//                for model in models {
//                    try Model.Element.WriteQuery.delete.run(persisting: model, inside: database)
//                }
//            }
//        }
//    }
//
//    public static var createOrUpdate: DefaultWriteQuery {
//        return DefaultWriteQuery { models, database in
//            for model in models {
//                try Model.Element.WriteQuery.createOrUpdate.run(persisting: model, inside: database)
//            }
//        }
//    }
//}
