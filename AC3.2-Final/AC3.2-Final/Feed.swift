//
//  Feed.swift
//  AC3.2-Final
//
//  Created by Annie Tung on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Feed {
    let key: String
    let uid: String
    let comment: String
    
    init(key: String, uid: String, comment: String) {
        self.key = key
        self.uid = uid
        self.comment = comment
    }
    
    var asDictionary: [String:String] {
        return ["uid" : uid, "comment" : comment]
    }
}
