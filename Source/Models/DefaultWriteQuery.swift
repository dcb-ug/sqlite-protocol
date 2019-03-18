//
//  DefaultWriteQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultWriteQuery<Model>: AnyWriteQuery<Model> {}

extension DefaultWriteQuery: DefaultWriteQueryProviding where Model: Persistable & ColumnSettersProviding {
    public static var delete: DefaultWriteQuery {
        return DefaultWriteQuery { model, database in
            let row = Model.table.filter(model.singleRowSelector)
            try database.run(row.delete())
        }
    }

    public static var createOrUpdate: DefaultWriteQuery {
        return DefaultWriteQuery { model, database in
            try database.run(Model.table.insert(or: .replace, model.columnSetters))
        }
    }
}

extension DefaultWriteQuery where Model: Sequence,
                                  Model: Persistable,
                                  Model.Element: Persistable,
                                  Model.Element.WriteQuery: DefaultWriteQueryProviding {
    public static var delete: DefaultWriteQuery {
        return DefaultWriteQuery { models, database in
            if Model.Element.WriteQuery.self == DefaultWriteQuery<Model.Element>.self {
                // if the query for the sequence member is the default delete-query written above
                // we can just select all rows and delte them at once
                let row = Model.table.filter(models.singleRowSelector)
                try database.run(row.delete())
            } else {
                // but when we don't know the content and side effects of the delete-query
                // we have to actually run it for each member of the sequence
                for model in models {
                    try Model.Element.WriteQuery.delete.run(persisting: model, inside: database)
                }
            }
        }
    }

    public static var createOrUpdate: DefaultWriteQuery {
        return DefaultWriteQuery { models, database in
            for model in models {
                try Model.Element.WriteQuery.createOrUpdate.run(persisting: model, inside: database)
            }
        }
    }
}
