//
//  QueryFactory.swift
//  pethug
//
//  Created by Raul Pena on 14/10/23.
//

import FirebaseFirestore
//Build query to fetch with filter options
func buildQuery(for options: FilterOptions, collection: String) -> Query {
    let db = Firestore.firestore()
    var query: Query
    
    query = db.collection(collection)
    
        if options.age.min != 0 ||
           options.age.max != 25 {
            
            if options.age.min != 0 {
                query = query.whereField("age", isGreaterThanOrEqualTo: options.age.min)
            }
            
            if options.age.max != 25 {
                query = query.whereField("age", isLessThanOrEqualTo: options.age.max)
            }
            
            query = query.order(by: "age", descending: false)
            
        } else {
            query = query.order(by: "timestamp", descending: true)
        }
        
        
        if options.gender != .all {
            query = query.whereField("gender", isEqualTo: options.gender.rawValue)
            
        }
        
        if options.size != .all {
            
            query = query.whereField("size", isEqualTo: options.size.rawValue)
            
        }
        
        if let address = options.address,
               address != .AllCountry {
            
               query = query.whereField("address", isEqualTo: address.rawValue)
        }
        
        query = query.limit(to: 10)
    
    return query
}
