//
//  Prospect.swift
//  HotProspects
//
//  Created by Dathan Wong on 7/13/20.
//  Copyright © 2020 Dathan Wong. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable{
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject{
    @Published var people: [Prospect]
    
    init(){
        self.people = []
    }
    
    func toggle(_ prospect: Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
    }
}
