//
//  DefaultQuery.swift
//  enter-ios
//
//  Created by Manuel Reich on 21.12.18.
//  Copyright © 2018 DevCrew Berlin. All rights reserved.
//

import Foundation
import SQLite

public final class DefaultQuery<Model>: AnyQuery<Model> {}

extension DefaultQuery: DefaultQueryProviding where Model: Persistable & ColumnSettersProviding {
    public static var delete: DefaultQuery {
        return DefaultQuery { model, database in
            let row = User.table.filter(model.databaseRowSelector)
            try database.run(row.delete())
        }
    }

    public static var createOrUpdate: DefaultQuery {
        return DefaultQuery { model, database in
            try database.run(Model.table.insert(or: .replace, model.columnSetters))
        }
    }
}

extension DefaultQuery where Model: Collection,
                             Model: Persistable,
                             Model.Element: Persistable,
                             Model.Element.Query: DefaultQueryProviding {
    public static var delete: DefaultQuery {
        return DefaultQuery { models, database in
            if Model.Element.Query.self == DefaultQuery<Model.Element>.self {
                // if the query for the collection member is the default delete-query written above
                // we can just select all rows and delte them at once
                let row = User.table.filter(models.databaseRowSelector)
                try database.run(row.delete())
            } else {
                // but when we don't know the content and side effects of the delete-query
                // we have to actually run it for each member of the collection
                for model in models {
                    try Model.Element.Query.delete.run(persisting: model, inside: database)
                }
            }
        }
    }

    public static var createOrUpdate: DefaultQuery {
        return DefaultQuery { models, database in
            for model in models {
                try Model.Element.Query.createOrUpdate.run(persisting: model, inside: database)
            }
        }
    }
}
