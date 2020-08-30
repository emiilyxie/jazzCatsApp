//
//  ShareCompVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 7/11/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import ReplayKit

class ShareCompVC: UIViewController, RPPreviewViewControllerDelegate {
    
    let recorder = RPScreenRecorder.shared()
    var isRecording = false
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
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

        // Do any additional setup after loading the view.
        setUpGraphics()
        
    }
    
    func setUpGraphics() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            UIStyling.setPopupBackground(popupView: self.bgView)
            UIStyling.setButtonStyle(button: self.cancelButton)
            UIStyling.setButtonStyle(button: self.recordButton)
            UIStyling.setButtonStyle(button: self.stopRecordingButton)

        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        guard let parentVC = self.parent as! GameViewController? else {
            print("cant get parentvc")
            return
        }
        parentVC.currentScene?.isPaused = false
        parentVC.currentScene?.isUserInteractionEnabled = true
        self.view.removeFromSuperview()
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        guard recorder.isAvailable else {
            print("recorder unavailable")
             return
        }
        
        recorder.isMicrophoneEnabled = false

        recorder.startRecording{ [unowned self] (error) in
            guard error == nil else {
                print("There was an error starting the recording.")
                return
            }
            
            print("Started Recording Successfully")
            self.isRecording = true
            
            self.bgView.removeFromSuperview()
            self.stopRecordingButton.isHidden = false
            self.rewindToBeginning()
        }
    }
    
    @IBAction func stopRecordingButtonPressed(_ sender: UIButton) {
        if isRecording == false {
            return
        }
        recorder.stopRecording { [unowned self] (preview, error) in
            print("Stopped recording")
            self.isRecording = false
            self.view.removeFromSuperview()
            
            if let unwrappedPreview = preview {
                unwrappedPreview.previewControllerDelegate = self
                self.present(unwrappedPreview, animated: true)
            }
        }
    }
    
    func rewindToBeginning() {
        guard let gameVC = self.parent as? GameViewController,
            let musicScene = gameVC.currentScene as? MusicScene else {
            print("cant get gamevc")
            return
        }
        
        for note in musicScene.pages[musicScene.pageIndex] {
            note.alpha = 0
            note.physicsBody?.categoryBitMask = PhysicsCategories.none
        }
        musicScene.pageIndex = 0
        for note in musicScene.pages[0] {
            note.alpha = 1
            note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
        }
        musicScene.updatePgCount()
        musicScene.isPaused = false
        musicScene.enterMode(sender: musicScene.buttons.object(forKey: "stopButton"), index: 5) // stop & reset
        musicScene.enterMode(sender: musicScene.buttons.object(forKey: "playButton"), index: 3) // play
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
        
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        
        parentVC.currentScene?.isUserInteractionEnabled = true
        parentVC.currentScene?.isPaused = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != bgView {
            self.cancelButtonPressed(UIButton())
        }
    }
}
