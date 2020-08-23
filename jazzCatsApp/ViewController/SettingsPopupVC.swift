//
//  SettingsPopupVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

class SettingsPopupVC: UIViewController {
    
    public var currentTempo: Int = LevelSetup.defaultTempo
    public var currentPgs: Int = LevelSetup.defaultMaxPages
    public var currentMPP: Int = LevelSetup.defaultNumberOfMeasures
    public var currentBPM: Int = LevelSetup.defaultBpm
    public var currentSPB: Int = LevelSetup.defaultSubdivision
    
    public var newTempo: Int = LevelSetup.defaultTempo
    public var newPgs: Int = LevelSetup.defaultMaxPages
    public var newMPP: Int = LevelSetup.defaultNumberOfMeasures
    public var newBPM: Int = LevelSetup.defaultBpm
    public var newSPB: Int = LevelSetup.defaultSubdivision

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoPlaceholder: UILabel!
    @IBOutlet weak var tempoTextField: UITextField!
    
    @IBOutlet var settingLabels: [UILabel]!
    @IBOutlet var settingValues: [UILabel]!
    @IBOutlet var settingSteppers: [UIStepper]!
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        
        parentVC.currentScene?.isUserInteractionEnabled = false
        parentVC.currentScene?.isPaused = true
        self.view.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGraphics()
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        guard let musicScene = parentVC.currentScene as! MusicScene? else {
            return
        }
        
        parentVC.currentScene?.isUserInteractionEnabled = false
        parentVC.currentScene?.isPaused = true
        self.view.isUserInteractionEnabled = true
        
        self.tempoTextField.keyboardType = .numberPad
        dismissKeyboard()
        
        currentTempo = musicScene.tempo
        currentPgs = musicScene.maxPages
        currentMPP = musicScene.numberOfMeasures
        currentBPM = musicScene.bpm
        currentSPB = musicScene.subdivision
        newTempo = musicScene.tempo
        newPgs = musicScene.maxPages
        newMPP = musicScene.numberOfMeasures
        newBPM = musicScene.bpm
        newSPB = musicScene.subdivision
        currentSettings()
        
    }
    
    func setUpGraphics() {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.clear
            self.scrollContentView.backgroundColor = ColorPalette.friendlyGold
            UIStyling.setPopupBackground(popupView: self.bgView)
            UIStyling.setButtonStyle(button: self.cancelButton)
            UIStyling.setButtonStyle(button: self.submitButton)
            self.cancelButton.layer.cornerRadius = 10
            self.submitButton.layer.cornerRadius = 10
            self.tempoTextField.backgroundColor = .white
            self.tempoTextField.textColor = ColorPalette.lineColor
        }
    }
    
    func currentSettings() {
        tempoTextField.text = String(currentTempo)
        
        settingValues[0].text = String(currentPgs)
        settingValues[1].text = String(currentMPP)
        settingValues[2].text = String(currentBPM)
        settingValues[3].text = String(currentSPB)
        
        settingSteppers[0].value = Double(currentPgs)
        settingSteppers[1].value = Double(currentMPP)
        settingSteppers[2].value = Double(currentBPM)
        settingSteppers[3].value = Double(currentSPB)
    }
    
    func processDisabled(disabled: [String]?) {
        guard let disabledCategories = disabled else {
            print("no categories to disable")
            return
        }
        
        for disabledCategory in disabledCategories {
            
            switch disabledCategory {
            case "tempo":
                tempoLabel.isHidden = true
                tempoPlaceholder.isHidden = true
                tempoTextField.isHidden = true
            case "pgs":
                settingLabels[0].isHidden = true
                settingValues[0].isHidden = true
                settingSteppers[0].isHidden = true
            case "mpp":
                settingLabels[1].isHidden = true
                settingValues[1].isHidden = true
                settingSteppers[1].isHidden = true
            case "bpm":
                settingLabels[2].isHidden = true
                settingValues[2].isHidden = true
                settingSteppers[2].isHidden = true
            case "spb":
                settingLabels[3].isHidden = true
                settingValues[3].isHidden = true
                settingSteppers[3].isHidden = true
            default:
                print("cant recognize disabled category")
            }
            
        }
    }
    
    @IBAction func editTempo(_ sender: Any) {
        guard let tempoString = tempoTextField.text, let tempoValue = Int(tempoString) else {
            UIStyling.showAlert(viewController: self, text: "Please put in a number.")
            tempoTextField.text = String(newTempo)
            return
        }
        let lowestTempo = 30
        let highestTempo = 400
        
        if tempoValue >= lowestTempo && tempoValue <= highestTempo {
            tempoTextField.text = String(tempoValue)
            newTempo = tempoValue
        }
        else {
            UIStyling.showAlert(viewController: self, text: "Tempo must be in range [30, 400].")
            tempoTextField.text = String(newTempo)
            return
        }
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
        guard let parentVC = self.parent as! GameViewController? else {
            print("cant get parnetvc")
            return
        }
        self.view.removeFromSuperview()
        parentVC.currentScene?.isPaused = false
        parentVC.currentScene?.isUserInteractionEnabled = true
    }
    
    @IBAction func confirmEdits(_ sender: UIButton) {
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        guard let musicScene = parentVC.currentScene as! MusicScene? else {
            return
        }
        musicScene.tempo = newTempo
        GameUser.conductor?.sequencer?.setTempo(Double(newTempo))
        
        musicScene.maxPages = newPgs
        musicScene.numberOfMeasures = newMPP
        musicScene.bpm = newBPM
        musicScene.subdivision = newSPB
        musicScene.oldNumOfMeasures = currentMPP
        musicScene.oldBpm = currentBPM
        musicScene.oldSubdivision = currentSPB
        musicScene.reloadLayout()
        
        self.view.removeFromSuperview()
        parentVC.currentScene?.isPaused = false
        parentVC.currentScene?.isUserInteractionEnabled = true
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != bgView {
            self.closePopover(self)
        }
    }
}
