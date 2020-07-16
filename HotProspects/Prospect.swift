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
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"
    
    init(){
        if let data = UserDefaults.standard.data(forKey: Prospects.saveKey){
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data){
                self.people = decoded
                return
            }
        }
        self.people = []
    }
    
    private func save(){
        if let encoded = try? JSONEncoder().encode(people){
            UserDefaults.standard.set(encoded, forKey: Prospects.saveKey)
        }
    }
    
    func addPerson(_ prospect: Prospect){
        self.people.append(prospect)
        self.save()
    }
    
    func toggle(_ prospect: Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
    }
}
