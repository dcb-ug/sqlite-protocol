//
//  DefaultWriteQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//

import SQLite

public final class DefaultWriteQuery<Model>: AnyWriteQuery<Model> {}

extension DefaultWriteQuery: DefaultWriteQueryProviding where Model: Persistable {
    public static var delete: DefaultWriteQuery {
        return DefaultWriteQuery { model, database in
            let schema = Model.Schema(model: model)
            let row = Model.Schema.table.filter(schema.primaryKeySelector)
            try database.run(row.delete())
        }
    }

    public static var createOrUpdate: DefaultWriteQuery {
        return DefaultWriteQuery { model, database in
            let setters = Model.Schema.columns.map { $0.setterBuilder(model) }
            try database.run(Model.Schema.table.insert(or: .replace, setters))
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
                let schema = Model.Schema(model: models)
                let row = Model.Schema.table.filter(schema.primaryKeySelector)
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
