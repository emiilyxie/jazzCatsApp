//
//  Sounds.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 8/5/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import FirebaseFirestore

class Sound {
    var id: String
    var index: Int
    var name: String
    var group: String
    var description: String
    var cost: Int
    var unlocked: Bool
    
    init(id: String, index: Int, name: String, group: String, description: String, cost: Int, unlocked: Bool) {
        self.id = id
        self.index = index
        self.name = name
        self.group = group
        self.description = description
        self.cost = cost
        self.unlocked = unlocked
    }
    
    convenience init(data: [String: Any], unlocked: Bool) {
        let id = data["id"] as! String
        let index = data["index"] as! Int
        let name = data["name"] as! String
        let group = data["group"] as! String
        let description = data["description"] as! String
        let cost = data["cost"] as! Int
        let unlocked = unlocked
        
        self.init(id: id, index: index, name: name, group: group, description: description, cost: cost, unlocked: unlocked)
    }
}

struct Sounds {
    
    static func sortSounds(sounds: [Sound]) -> [Sound] {
        let sorted = sounds.sorted(by: {$0.index < $1.index})
        return sorted
    }
    
    static func getUnlockedSounds(allSounds: [Sound]) -> [Sound] {
        var unlockedSounds: [Sound] = []
        for sound in allSounds {
            if sound.unlocked == true {
                unlockedSounds.append(sound)
            }
        }
        return unlockedSounds
    }
    
    static func getSound(from sounds: [Sound], id: String) -> Sound? {
        let soundIDs = sounds.map { $0.id }
        if let soundIndex = soundIDs.firstIndex(of: id) {
            return sounds[soundIndex]
        }
        return nil
    }
    
    static func getSound(from sounds: [Sound], index: Int) -> Sound? {
        let soundIndexes = sounds.map { $0.index }
        if let soundIndex = soundIndexes.firstIndex(of: index) {
            return sounds[soundIndex]
        }
        return nil
    }
}
