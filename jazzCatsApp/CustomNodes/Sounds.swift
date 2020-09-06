//
//  Sounds.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 8/5/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import SpriteKit

class Sound: Codable {
    var id: String
    var index: Int
    var name: String
    var group: String
    var instrument: String
    var description: String
    var cost: Int
    
    init(id: String, index: Int, name: String, group: String, instrument: String, description: String, cost: Int) {
        self.id = id
        self.index = index
        self.name = name
        self.group = group
        self.instrument = instrument
        self.description = description
        self.cost = cost
    }
    
    convenience init(data: [String: Any]) {
        let id = data["id"] as! String
        let index = data["index"] as! Int
        let name = data["name"] as! String
        let group = data["group"] as! String
        let instrument = data["instrument"] as! String
        let description = data["description"] as! String
        let cost = data["cost"] as! Int
        
        self.init(id: id, index: index, name: name, group: group, instrument: instrument, description: description, cost: cost)
    }
    
}

struct Sounds {
    
    static func saveSoundArray(soundArray: [String]) {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("cant get doc dir")
            return
        }
        
        let fileUrl = docDirURL.appendingPathComponent("sound-array.json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: soundArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    static func getSoundArray() -> [String]? {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("sound-array.json")

        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let soundArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return nil}
            return soundArray
        } catch {
            print(error)
        }
        return nil
    }
    
    static func sortSounds(sounds: [Sound]) -> [Sound] {
        let sorted = sounds.sorted(by: {$0.index < $1.index})
        return sorted
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
    
    static func getSoundFromFirebase(soundID: String, completion: @escaping (Sound) -> ()) {
        let soundsRef = Firestore.firestore().collection("/sounds")
        
        soundsRef.document(soundID).getDocument { (document, err) in
            if let err = err {
                print("get sound doc error: \(err.localizedDescription)")
                if let topVC = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
                    UIStyling.showAlert(viewController: topVC, text: err.localizedDescription)
                }
            }
            if let document = document, document.exists {
                if let data = document.data() {
                    let sound = Sound(data: data)
                    completion(sound)
                }
            }
        }
        return
    }
    
    static func saveSound(sound: Sound, completion: @escaping () -> ()) {
        
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("cant get doc dir")
            return
        }
        let dirUrl = docDirURL.appendingPathComponent("sounds/\(sound.id)")
        let fileUrl = docDirURL.appendingPathComponent("sounds/\(sound.id)/\(sound.id).json")
        let encoder = JSONEncoder()
        do {
            try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            let encoded = try encoder.encode(sound)
            try encoded.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
        
        saveSoundMedia(sound: sound, completion: completion)
    }
    
    static func saveSoundMedia(sound: Sound, completion: @escaping () -> ()) {
        
        var audioDone = false
        var imgDone = false
        
        let storageRef = Storage.storage().reference()
        let audioRef = storageRef.child("sounds/\(sound.id)/\(sound.id).mp3")
        let imgRef = storageRef.child("sounds/\(sound.id)/\(sound.id).png")
        
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("cant get doc dir")
            return
        }
        
        let audioFileUrl = docDirURL.appendingPathComponent("sounds/\(sound.id)/\(sound.id).mp3")
        let imgFileUrl = docDirURL.appendingPathComponent("sounds/\(sound.id)/\(sound.id).png")
        
        
        let audioDownload = audioRef.write(toFile: audioFileUrl) { (url, err) in
            if let err = err {
                print("audio download error: \(err.localizedDescription)")
                if let topVC = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
                    UIStyling.showAlert(viewController: topVC, text: "Error: \(err.localizedDescription) Please connect to the internet and try again.", duration: 10)
                }
            }
        }
        
        let imgDownload = imgRef.write(toFile: imgFileUrl) { (url, err) in
            if let err = err {
                print("img download error: \(err.localizedDescription)")
                if let topVC = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
                    UIStyling.showAlert(viewController: topVC, text: "Error: \(err.localizedDescription) Please connect to the internet and try again.", duration: 10)
                }
            }
        }
        
        audioDownload.observe(.success) { (snapshot) in
            audioDone = true
            if audioDone && imgDone {
                completion()
            }
        }
        
        imgDownload.observe(.success) { (snapshot) in
            imgDone = true
            if audioDone && imgDone {
                completion()
            }
        }
    }
    
    static func getSoundFromFiles(soundID: String) -> Sound? {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("sounds/\(soundID)/\(soundID).json")

        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            let decoder = JSONDecoder()
            let sound = try decoder.decode(Sound.self, from: data)
            return sound
        } catch {
            print("couldn't decode sound: \(error)")
        }
        return nil
    }
    
    static func getSoundImg(soundID: String) -> UIImage? {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("sounds/\(soundID)/\(soundID).png")
        do {
            let imgData = try Data(contentsOf: fileUrl)
            return UIImage(data: imgData)
        } catch {
            print("couldnt get sound img: \(error)")
            return nil
            
        }
    }
    
    static func getSoundAudio(soundID: String) -> URL? {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("sounds/\(soundID)/\(soundID).mp3")
        return fileUrl
    }
    
}
