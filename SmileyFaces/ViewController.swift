//
//  ViewController.swift
//  SmileyFaces
//
//  Created by parry on 11/2/16.
//  Copyright © 2016 parry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!

    var trayOpen = true
    
    var imageOriginalCenter: CGPoint!


    @IBOutlet weak var downArrowImage: UIImageView!
    var newlyCreatedFace: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        trayCenterWhenOpen = trayView.center
        trayCenterWhenClosed = CGPoint(x: 187.5, y: 720.0)

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector(("onTrayArrowTapped")))
        downArrowImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func onTrayArrowTapped()
    {
        if trayOpen {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.trayView.center = self.trayCenterWhenClosed
                
                self.downArrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(180 * M_PI / 180))

                }, completion: { (finished) in
                    
            })

        }
        else
        {
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.trayView.center = self.trayCenterWhenOpen
                
                self.downArrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(1 * M_PI / 180))

                
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
            
            if sender.velocity(in: parentView).y < 0
            {
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.trayView.center = self.trayCenterWhenOpen

                    self.downArrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(1 * M_PI / 180))

                    
                    }, completion: { (finished) in
                        
                })
            }
            else
            {
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.trayView.center = self.trayCenterWhenClosed
                    
                    self.downArrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(180 * M_PI / 180))


                    
                    }, completion: { (finished) in
                        
                })
            }

        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
        }
    }


    @IBAction func onFacePanGesture(_ sender: UIPanGestureRecognizer) {
        
        let parentView = self.view
        let point = sender.location(in: parentView)
        
        if sender.state == .began {
            print("Gesture began at: \(point)")
           createNewImage(sender: sender)
            
        } else if sender.state == .changed {
            print("Gesture changed at: \(point)")
            newlyCreatedFace.center = point
//            print(newlyCreatedFace.center)
            
            
        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
            //if location in view is in the trayview
            //animate back to
            
            if newlyCreatedFace.isDescendant(of: trayView)
            {
                UIView.animate(withDuration: 0.8, animations: {
                    self.newlyCreatedFace.center = self.imageOriginalCenter
                    
                })
            }
            
        
            
        }
    }

    
    func createNewImage(sender: UIPanGestureRecognizer)
    {
        // Gesture recognizers know the view they are attached to
        let imageView = sender.view as! UIImageView
        
        // Create a new image view that has the same image as the one currently panning
        self.newlyCreatedFace = UIImageView(image: imageView.image)
        self.newlyCreatedFace.isUserInteractionEnabled = true

        // Add the new face to the tray's parent view.
        view.addSubview(newlyCreatedFace)
        
        imageOriginalCenter = imageView.center
        // Initialize the position of the new face.
        newlyCreatedFace.center = imageView.center
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        newlyCreatedFace.center.y += trayView.frame.origin.y
        createPanGestureRecognizer(targetView: imageView)
        createPinGestureRecognizer(targetView: imageView)
        createRotGestureRecognizer(targetView: imageView)
        createDoubleTapGestureRecognizer(targetView: imageView)

        
    }
    
    func createPanGestureRecognizer(targetView: UIImageView)
    {
        
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(ViewController.handlePanningFaceGesture(_:))))
        targetView.addGestureRecognizer(panGesture)
    }
    
    func createPinGestureRecognizer(targetView: UIImageView)
    {
        
        let pinGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handlePinFaceGesture(_:)))
        pinGesture.delegate = self;

        targetView.addGestureRecognizer(pinGesture)
    }
    
    func createRotGestureRecognizer(targetView: UIImageView)
    {
        
        let rotGesture = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.handlePinFaceGesture(_:)))
        targetView.addGestureRecognizer(rotGesture)
    }
    
    func createDoubleTapGestureRecognizer(targetView: UIImageView)
    {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    func doubleTapped() {
        newlyCreatedFace.removeFromSuperview()
    }
    
    
    func handlePinFaceGesture(_ sender: UIPanGestureRecognizer) {
        let parentView = self.view
        let point = sender.location(in: parentView)
        let translation = sender.translation(in: parentView)
        
        if sender.state == .began {
            print("Gesture began at: \(point)")
            
        } else if sender.state == .changed {
            print("Gesture changed at: \(point)")
            newlyCreatedFace.center = point
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            
        }
    }


    
    func handlePanningFaceGesture(_ sender: UIPanGestureRecognizer) {
        
        let parentView = self.view
        let point = sender.location(in: parentView)
        let translation = sender.translation(in: parentView)
        
        if sender.state == .began {
            print("Gesture began at: \(point)")
            
        } else if sender.state == .changed {
            print("Gesture changed at: \(point)")
            newlyCreatedFace.center = point
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)

            
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
    }
    
}

