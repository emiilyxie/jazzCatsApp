//
//  Configuration.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/16/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

struct PhysicsCategories {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let noteCategory: UInt32 = 0x1
    static let measureBarCategory: UInt32 = 0x1 << 1
    public static let finalBarCategory: UInt32 = 0x1 << 2
}

struct ColorPalette {
    static let apricot = UIColor(red: 1.00, green: 0.80, blue: 0.70, alpha: 1.00)
    static let melon = UIColor(red: 1.00, green: 0.71, blue: 0.64, alpha: 1.00)
    static let pastelPink = UIColor(red: 0.90, green: 0.60, blue: 0.61, alpha: 1.00)
    static let englishLavender = UIColor(red: 0.71, green: 0.51, blue: 0.55, alpha: 1.00)
    static let oldLavender = UIColor(red: 0.43, green: 0.41, blue: 0.46, alpha: 1.00)
    
    static let unselectedButton = UIColor(red: 0.90, green: 0.82, blue: 0.63, alpha: 1.00)
    static let lineColor = UIColor(red: 0.2, green: 0.1, blue: 0.1, alpha: 1.00)
    static let brightManuscript = UIColor(red: 0.97, green: 0.93, blue: 0.76, alpha: 1.00)
    static let friendlyGold = UIColor(red: 0.92, green: 0.79, blue: 0.51, alpha: 1.00)
    static let softAlert = UIColor(red: 0.91, green: 0.49, blue: 0.44, alpha: 1.00)
    static let humbleWood = UIColor(red: 0.67, green: 0.55, blue: 0.45, alpha: 1.00)
    static let goldWood = UIColor(red: 0.86, green: 0.78, blue: 0.57, alpha: 1.00)
}

struct UIStyling {
    
    static func setViewBg(view: UIView, bgImage: String) {
        let background = UIImage(named: bgImage)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    static func setButtonStyle(button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.setTitleColor(ColorPalette.lineColor, for: .normal)
        button.layer.borderWidth = CGFloat(2)
        button.layer.borderColor = ColorPalette.lineColor.cgColor
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Gaegu-Regular", size: CGFloat(24))
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    static func setPopupBackground(popupView: UIView) {
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = 10
        popupView.backgroundColor = ColorPalette.friendlyGold
        popupView.layer.borderWidth = 3
        popupView.layer.borderColor = ColorPalette.lineColor.cgColor
        
    }
    
    static func setHeader(header: UILabel) {
        header.textColor = ColorPalette.lineColor
        header.font = UIFont(name: "Gaegu-Regular", size: CGFloat(30))
        header.layer.masksToBounds = true
        header.layer.borderWidth = 3
        header.layer.borderColor = ColorPalette.lineColor.cgColor
        header.backgroundColor = ColorPalette.goldWood
    }
    
    static func setTextField(textField: UITextField, placeholder: String) {
        textField.backgroundColor = .white
        textField.textColor = ColorPalette.lineColor
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    static func showLoading(viewController: UIViewController) {
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:0.3)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.bringSubviewToFront(viewController.view)
        activityIndicator.layer.zPosition = 9999
        activityIndicator.center = viewController.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.tag = -738264
        viewController.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            if activityIndicator.isAnimating {
                UIStyling.showAlert(viewController: viewController, text: "Your network seems to be weak or offline. Please connect to the internet and try again.", duration: 30)
            }
        }
        
        viewController.view.isUserInteractionEnabled = false
    }
    
    static func hideLoading(view: UIView) {
        var activityIndicator = view.viewWithTag(-738264) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
        view.isUserInteractionEnabled = true
    }
    
    static func showAlert(viewController: UIViewController, text: String, duration: Double = 0.25) {
        let alertView = UILabel(frame: CGRect(width: 200, height: 500))
        alertView.text = text
        alertView.font = UIFont(name: "Gaegu-Bold", size: 20)
        alertView.backgroundColor = ColorPalette.lineColor
        alertView.layer.masksToBounds = true
        alertView.layer.cornerRadius = 5
        alertView.textColor = .white
        
        //viewController.addChild(alertView)
        alertView.numberOfLines = -1
        alertView.sizeThatFits(CGSize(width: 300, height: 500))
        alertView.sizeToFit()
        alertView.frame = CGRect(width: alertView.frame.width + 20, height: alertView.frame.height + 20)
        alertView.textAlignment = .center
        UIView.transition(with: viewController.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
          viewController.view.addSubview(alertView)
        }, completion: nil)
        //viewController.view.addSubview(alertView)
        alertView.bringSubviewToFront(viewController.view)
        alertView.center = viewController.view.center
        
        //alertView.didMove(toParent: viewController)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.transition(with: viewController.view, duration: 1.0, options: [.transitionCrossDissolve], animations: {
              alertView.removeFromSuperview()
            }, completion: nil)
            //alertView.removeFromSuperview()
        }
    }
    
    static func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
       let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
       let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
     
       let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale
     
       let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
     kCGImageSourceShouldCacheImmediately: true,
     kCGImageSourceCreateThumbnailWithTransform: true,
     kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
      let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!
     
       return UIImage(cgImage: downsampledImage)
    }
}

enum ButtonType: String {
    case add, erase, navigate, play, pause, stop
}

struct MusicValues {
    static public var middleCMidi = 60
    static public let octaveSize = 12
    static public let octaveStepSizes = [2, 2, 1, 2, 2, 2, 1]
    static public let reversedOctaveStepSizes = [1, 2, 2, 2, 1, 2, 2]
    static public var middleCPos = 0
    
    static public var midiNoteDict = [("F2", 41), ("G2", 43), ("A2", 45), ("B2", 47), ("C3", 48), ("D3", 50), ("E3", 52), ("F3", 53), ("G3", 55), ("A3", 57), ("B3", 59), ("C4", 60), ("D4", 62), ("E4", 64), ("F4", 65), ("G4", 67), ("A4", 69), ("B4", 71), ("C5", 72), ("D5", 74), ("E5", 76), ("F5", 77), ("G5", 79)]

    static public var trebleMidiNoteDict = [("C4", 60), ("D4", 62), ("E4", 64), ("F4", 65), ("G4", 67), ("A4", 69), ("B4", 71), ("C5", 72), ("D5", 74), ("E5", 76), ("F5", 77), ("G5", 79)]

    static public var trebleNotes = ["B3", "C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5", "D5", "E5", "F5", "G5", "C4s", "D4s", "E4s", "F4s", "G4s", "A4s", "B4s", "C5s", "D5s", "E5s", "F5s", "G5s"]
}

public func scaleNode(size: CGSize, factor: Double) -> CGSize {
    return CGSize(width: size.width * CGFloat(factor), height: size.height * CGFloat(factor))
}

struct UsefulFuncs {
    static func roundTwoDecimals(float: CGFloat) -> CGFloat {
        let rounded = (100 * float).rounded() / 100
        return rounded
    }
}

public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }

    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
    
    static func getTopViewController() -> UIViewController? {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window {
            return window?.visibleViewController
        }
        return nil
    }
}



/*
extension CGPoint {
    
    static public func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
}
*/
