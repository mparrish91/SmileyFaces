//
//  ViewController.swift
//  SmileyFaces
//
//  Created by parry on 11/2/16.
//  Copyright © 2016 parry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!

    var trayOpen = true

    @IBOutlet weak var downArrowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayCenterWhenOpen = trayView.center
        trayCenterWhenClosed = CGPoint(x: 187.5, y: 720.0)

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector(("imageTapped")))
        downArrowImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped()
    {
        if trayOpen {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.trayView.center = self.trayCenterWhenClosed
                
                }, completion: { (finished) in
                    
            })

        }
        else
        {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.trayView.center = self.trayCenterWhenOpen
                
                }, completion: { (finished) in
                    
            })

        }
        trayOpen = !trayOpen
  
    }


    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let parentView = self.view
        let point = sender.location(in: parentView)
        let translation = sender.translation(in: parentView)
        print(trayView.center)

        if sender.state == .began {
            print("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture changed at: \(point)")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
            if sender.velocity(in: parentView).y < 0
            {
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.trayView.center = self.trayCenterWhenOpen

                    }, completion: { (finished) in
                        
                })
            }
            else
            {
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.trayView.center = self.trayCenterWhenClosed
                    
                    }, completion: { (finished) in
                        
                })
            }

        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
        }
    }


    
}

