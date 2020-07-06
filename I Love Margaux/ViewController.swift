//
//  ViewController.swift
//  I Love Margaux
//
//  Created by Georges Kanaan on 5/7/20.
//  Copyright © 2020 Georges Kanaan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var currentIndex: Int = 0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.becomeFirstResponder() // To get shake gesture

        self.currentIndex = 0
        
        self.titleLabel.alpha = 0.0
        self.descriptionLabel.alpha = 0.0
        
        self.titleLabel.text = steps[0].0
        self.descriptionLabel.text = steps[0].1
        
        self.imageView.backgroundColor = self.view.backgroundColor
        self.imageView.frame = self.view.frame
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        // Create the heart
        let heartSizePortion: CGFloat = 0.9
        let heartWidth: CGFloat = heartSizePortion*self.view.frame.width
        let heartX: CGFloat = (self.view.frame.width - heartWidth)/2
        
        let heartView = HeartView(frame: CGRect(x: heartX, y: 10, width: heartWidth, height: heartWidth))
        
        self.view.addSubview(heartView)
        self.view.bringSubviewToFront(self.imageView)

        let descriptionY: CGFloat = heartWidth+heartView.frame.origin.y+10
        
        self.titleLabel.center = CGPoint(x: heartView.center.x, y: heartView.center.y - 20)
        self.descriptionLabel.frame = CGRect(x: 1, y: descriptionY, width: self.view.frame.width-2, height: self.view.frame.height - descriptionY)
        
        // Animate the heart and text
        heartView.animateHeart(duration: 1.5)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.titleLabel.alpha = 1.0
        
        }) { (completed) in
            UIView.animate(withDuration: 1.5) {
                self.descriptionLabel.alpha = 1.0
            }
        }
        
    }

    @IBAction func screenWasTapped(_ sender: UITapGestureRecognizer) {
        currentIndex = (currentIndex+1 == steps.count) ? 0 : currentIndex+1
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.descriptionLabel.alpha = 0
            
        }) { (completed) in
            let tuple: (String, String) = self.steps[self.currentIndex]
            self.titleLabel.text = tuple.0
            self.descriptionLabel.text = tuple.1
            
            UIView.animate(withDuration: 0.3) {
                self.imageView.image = UIImage(named: String(self.currentIndex))

                self.titleLabel.alpha = 1.0
                self.descriptionLabel.alpha = 1.0
            }
        }
        
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.imageView.image = UIImage(named: String(self.currentIndex))
            self.imageView.isHidden = !self.imageView.isHidden
            
        }
    }
}

// From https://stackoverflow.com/questions/26578023/animate-drawing-of-a-circle
class HeartView: UIView {
    let heartLayer: CAShapeLayer = CAShapeLayer()
    
    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear

        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let heartPath = UIBezierPath(heartIn: self.bounds)

        // Setup the CAShapeLayer with the path, colors, and line width
        heartLayer.path = heartPath.cgPath
        heartLayer.fillColor = UIColor.clear.cgColor
        heartLayer.strokeColor = UIColor.systemPink.cgColor
        heartLayer.lineWidth = 5.0;

        // Don't draw the circle initially
        heartLayer.strokeEnd = 0.0

        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(heartLayer)
    }
    
    func animateHeart(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        // Set the animation duration appropriately
        animation.duration = duration

        // Animate from 0 (no heart) to 1 (full heart)
        animation.fromValue = 0
        animation.toValue = 1

        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        heartLayer.strokeEnd = 1.0

        // Do the actual animation
        heartLayer.add(animation, forKey: "animateHeart")
    }
}

// Heart Bezier Extension from: https://stackoverflow.com/questions/29227858/how-to-draw-heart-shape-in-uiview-ios
extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()

        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2

        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)

        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))

        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)

        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))

        //Left Bottom Line
        self.close()
    }
}

// DegreeToRads Extension
extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
