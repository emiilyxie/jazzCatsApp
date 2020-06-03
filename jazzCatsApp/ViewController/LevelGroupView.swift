//
//  LevelGroupView.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/30/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LevelGroupView: UIView {
    
    weak var parentVC: LevelGroupsVC?
    @IBOutlet weak var levelGroupCard: UIButton!
    
    
    @IBAction func levelButtonPressed(_ sender: UIButton) {
        print(levelGroupCard.title(for: .normal) ?? "no title")
        
        // get values from firebase
        
        guard let levelGroupDoc = levelGroupCard.title(for: .normal)?.lowercased() else { return }
        
        let levelGroupsRef = Firestore.firestore().collection("/level-groups")
        levelGroupsRef.document(levelGroupDoc).getDocument { (document, err) in
            if let document = document, document.exists {
                if let numOfMeasures = document.get("number-of-levels") as? Int {
                    self.parentVC?.selectedLevelGroup = document.documentID
                    self.parentVC?.levelGroupNumOfMeasures = numOfMeasures
                    self.parentVC?.performSegue(withIdentifier: "fromLevelGroupsToLevelSelectSegue", sender: self)
                }
                else {
                    print("document values not found")
                    return
                }
            }
            else {
                print("document was not found")
                return
            }
        }
        
    }
    
}
