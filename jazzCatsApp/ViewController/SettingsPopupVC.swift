//
//  SettingsPopupVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

class SettingsPopupVC: UIViewController {
    
    public var currentPgs: Int!
    public var currentMPP: Int!
    public var currentBPM: Int!
    public var currentSPB: Int!
    
    public var newPgs: Int!
    public var newMPP: Int!
    public var newBPM: Int!
    public var newSPB: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(0.8))
        
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        guard let freestyleScene = parentVC.currentScene as! Freestyle? else {
            return
        }
        
        currentPgs = freestyleScene.maxPages
        currentMPP = freestyleScene.numberOfMeasures
        currentBPM = freestyleScene.bpm
        currentSPB = freestyleScene.subdivision
        newPgs = freestyleScene.maxPages
        newMPP = freestyleScene.numberOfMeasures
        newBPM = freestyleScene.bpm
        newSPB = freestyleScene.subdivision
        currentSettings()

    }
    
    @IBOutlet var settingValues: [UILabel]!
    
    @IBOutlet var settingSteppers: [UIStepper]!
    
    func currentSettings() {
        settingValues[0].text = String(currentPgs)
        settingValues[1].text = String(currentMPP)
        settingValues[2].text = String(currentBPM)
        settingValues[3].text = String(currentSPB)
        
        settingSteppers[0].value = Double(currentPgs)
        settingSteppers[1].value = Double(currentMPP)
        settingSteppers[2].value = Double(currentBPM)
        settingSteppers[3].value = Double(currentSPB)
    }
    
    @IBAction func editPgs(_ sender: UIStepper) {
        settingValues[0].text = String(Int(settingSteppers[0].value))
        newPgs = Int(settingSteppers[0].value)
    }
    
    @IBAction func editMPP(_ sender: UIStepper) {
        settingValues[1].text = String(Int(settingSteppers[1].value))
        newMPP = Int(settingSteppers[1].value)
    }
    
    @IBAction func editBPM(_ sender: UIStepper) {
        settingValues[2].text = String(Int(settingSteppers[2].value))
        newBPM = Int(settingSteppers[2].value)
    }
    
    @IBAction func editSPB(_ sender: UIStepper) {
        settingValues[3].text = String(Int(settingSteppers[3].value))
        newSPB = Int(settingSteppers[3].value)
    }
    
    
    @IBAction func closePopover(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func confirmEdits(_ sender: UIButton) {
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        guard let freestyleScene = parentVC.currentScene as! Freestyle? else {
            return
        }
        freestyleScene.maxPages = newPgs
        freestyleScene.numberOfMeasures = newMPP
        freestyleScene.bpm = newBPM
        freestyleScene.subdivision = newSPB
        freestyleScene.oldSubdivision = currentSPB
        freestyleScene.reloadLayout()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
