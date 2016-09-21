//
//  PHWindow.swift
//  ne
//
//  Created by eye on 2016/9/21.
//  Copyright © 2016年 eye. All rights reserved.
//

import UIKit

public class PHWindow {
    
    /** Shared instance */
    static let sharedInstance = PHWindow()
    
    /** The main window that is used to display PHWindow */
    private let window:UIWindow!
    
    /** The previous window displayed */
    private var previousWindow:UIWindow?
    
    /** Configure default values for PHWindow */
    private init() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(white: 0, alpha: 0)
        vc.view.addSubview(ProgressWindow(frame: vc.view.bounds))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert
        window.rootViewController = vc
        window.alpha = 0
        
        previousWindow = UIWindow(frame: UIScreen.main.bounds)
        if let window = UIApplication.shared.delegate?.window {
            previousWindow = window
        }
    }
    
    /*Show*/
    public class func show(Name:String) {
        guard let previousWindow = UIApplication.shared.delegate?.window else {
            assert(false, "Couldn't find main window.")
            return
        }
        
        PHWindow.sharedInstance.previousWindow = previousWindow
        PHWindow.sharedInstance.window.makeKeyAndVisible()
        
        //ShowImage
        for view in PHWindow.sharedInstance.window.rootViewController!.view.subviews {
            //待解決 view.isKind(of: ProgressWindow())
            (view as! ProgressWindow).ImageShow(Name: Name)
        }
        
        //動畫 漸漸出現
        UIView.animate(withDuration: 0.35) {
            PHWindow.sharedInstance.window.alpha = 1
        }
    }
    
    /** HUD hide.*/
    public class func hide() {
        UIView.animate(withDuration: 0.35, animations: {
            PHWindow.sharedInstance.window.alpha = 0
        }) { (Bool) in
            PHWindow.sharedInstance.previousWindow?.makeKeyAndVisible()
        }
    }
    
}

/** The progressWindow class */
private class ProgressWindow: UIView {
    /** A required method. */
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    /** The hud view */
    var hudView:UIView!
    
    /** The hud Image */
    var hudImage:UIImageView!
    
    /** Init with a frame and setup th progressHUD with default values. */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let hudFrame = CGRect(x: 0 , y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-20)
        
        hudView = UIView(frame: hudFrame)
        hudView.clipsToBounds = true
        hudView.backgroundColor = UIColor.white
    
        hudImage = UIImageView(frame: hudFrame)

        hudView.addSubview(hudImage)
        addSubview(hudView)
    }
    
    func ImageShow(Name:String){
        hudImage.contentMode = UIViewContentMode.scaleAspectFit
        hudImage.image = UIImage(named: Name)
    }
}
