//
//  ArcMenu.swift
//  WheelMenu
//
//  Created by RMC LTD on 22/02/16.
//  Copyright © 2016 RMC. All rights reserved.
//

import UIKit
protocol ArcMenuDelegate {
    func menuAction(sender:UIButton)
}

class ArcObject :NSObject{
    var minValue = Float();
    var maxValue = Float();
    var midValue = Float();
    var value = Int();
   
}
class ArcMenu: UIControl {
     var deltaAngle = Float()
    var minAlphavalue:CGFloat = 0.6;
    var maxAlphavalue :CGFloat = 1.0;
    var currentValue = Int()
    var numberOfSections = Int()
    var delegate :ArcMenuDelegate?
    var container = UIView()
    var cloves :NSMutableArray?
    var startTransform :CGAffineTransform?
    var tapGesture:UITapGestureRecognizer?
    var longPress :UILongPressGestureRecognizer?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    init(frame:CGRect,del:ArcMenuDelegate,buttonNumber:Int) {
            super.init(frame: frame)
            self.currentValue = 0;
            self.numberOfSections = buttonNumber;
            self.delegate = del;
            tapGesture = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
       // longPress = UILongPressGestureRecognizer(target:self,action: "longPressed")
        self.drawWheel()

        
      
    }
    
    func imageViewTapped(sender:UITapGestureRecognizer){
        
        //getCloveByValue(<#T##value: Int##Int#>)
    }
    func buttonAction(sender:UIButton){
        //if sender.touchesMoved(<#T##touches: Set<UITouch>##Set<UITouch>#>, withEvent: <#T##UIEvent?#>)
        delegate?.menuAction(sender)
    }

//    func dragAction(sender:UIButton){
//       sender.userInteractionEnabled = false
//    }
//    func dragExit(sender:UIButton){
//        sender.userInteractionEnabled = true
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getCloveByValue (value:Int)->UIImageView {
        var res = UIImageView()
        let views = container.subviews
        for im in views {
           if let btn = im as? UIImageView {
            if (btn.tag == value) {
                res = btn
            }
        }
        }
        return res
    }
   

    func drawWheel(){
      container = UIView(frame: self.frame)
        
        let angleSize  = (2 * M_PI) / Double(numberOfSections)
        for i in 0..<numberOfSections {
          let im = UIImageView(frame: CGRectMake(0, 0, 40, 100))
            im.layer.anchorPoint = CGPointMake(0.3, 1.0)
            im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                container.bounds.size.height/2.0-container.frame.origin.y)
                        im.transform = CGAffineTransformMakeRotation(CGFloat(angleSize * Double(i)))
            im.alpha = minAlphavalue;
            im.tag = i;
            im.userInteractionEnabled = true
            //im.backgroundColor = UIColor.greenColor()
            
            
//            if (i == 0) {
//                im.alpha = maxAlphavalue;
//            }
            let cloveImage = UIButton(frame: CGRectMake(0,0,40, 40))
            cloveImage.backgroundColor = UIColor.purpleColor()
            cloveImage.layer.cornerRadius = 20
            cloveImage.tag = i+1
            //cloveImage.userInteractionEnabled = false
            //cloveImage.addGestureRecognizer(tapGesture!)
            cloveImage.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
//            cloveImage.addTarget(self, action: "dragAction:", forControlEvents: UIControlEvents.TouchDragInside)
//            cloveImage.addTarget(self, action: "dragExit:", forControlEvents: UIControlEvents.TouchUpOutside)
            //cloveImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%i.png", i]];
            im.addSubview(cloveImage)
            container.addSubview(im)
            
        }
        
       container.userInteractionEnabled = true;
        //container.backgroundColor = UIColor.orangeColor()
        self.addSubview(container)
        cloves = NSMutableArray(capacity: numberOfSections)
        let mask = UIButton(frame: CGRectMake(0, 0, 58, 58))
        mask.backgroundColor = UIColor.blueColor()
        mask.layer.cornerRadius = 29
        mask.center = self.center
        mask.tag = 100
        mask.center = CGPointMake(mask.center.x, mask.center.y+3);
       mask.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(mask)
        if numberOfSections % 2 == 0{
            self.buildClovesEven()
        }
        else  {
              self.buildClovesOdd()
        }

        }
    
//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//    
//           var hitView = super.hitTest(point, withEvent: event)
//        if (hitView == container) {
//        return nil
//       
//                    }
//        else{
//            return hitView
//
//        }
//        
//        
//    }
    
    func buildClovesEven() {
        let fanWidth :Float = Float(2 * M_PI) / Float(numberOfSections)
        var mid :Float = 0
        for i in 0..<numberOfSections {
            let clove = ArcObject()
            clove.midValue = mid
            clove.minValue = mid - (fanWidth/2);
            clove.maxValue = mid + (fanWidth/2);
            clove.value = i;
            if (Double(clove.maxValue - fanWidth) < -M_PI) {
                
                mid = Float(M_PI);
                clove.midValue = mid;
                clove.minValue = fabsf(clove.maxValue);
                
            }
            
            mid -= fanWidth;
            cloves?.addObject(clove)
        }
    }
    func buildClovesOdd() {
        let fanWidth :Float = Float(2 * M_PI) / Float(numberOfSections)
        var mid :Float = 0
        for i in 0..<numberOfSections {
            let clove = ArcObject()
            clove.midValue = mid
            clove.minValue = mid - (fanWidth/2);
            clove.maxValue = mid + (fanWidth/2);
            clove.value = i;
            mid -= fanWidth;
            if (Double(clove.minValue) < -M_PI) {
                
                mid = -mid;
                mid -= fanWidth;
                
            }
            
           
            cloves?.addObject(clove)
        }
    }
    
    func calculateDistanceFromCenter (point:CGPoint)->Float {
        let center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return Float(sqrt(dx * dx - dy * dy))
    }
//    override func sendActionsForControlEvents(controlEvents: UIControlEvents) {
//        if controlEvents == .TouchUpInside {
//            print("sS")
//        }
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchPoint  = touch!.locationInView(self)
        let dist = self.calculateDistanceFromCenter(touchPoint)
        if dist < 40 || dist > 100 {
            //return false
        }
        let dx  = touchPoint.x - container.center.x
        let dy = touchPoint.y - container.center.y
        deltaAngle = atan2(Float(dy),Float(dx));
        let im = self.getCloveByValue(currentValue)
        im.alpha = minAlphavalue;
        startTransform = container.transform;
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
         let touch = touches.first
        let touchPoint  = touch!.locationInView(self)
        let dist = self.calculateDistanceFromCenter(touchPoint)
        if dist < 40 || dist > 100 {
            //return false
        }
        let dx  = touchPoint.x - container.center.x
        let dy = touchPoint.y - container.center.y
        let ang = atan2(Float(dy),Float(dx));
        let angleDifference = deltaAngle - ang;
        container.transform = CGAffineTransformRotate(startTransform!, CGFloat(-angleDifference))
    }
//    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
//        
//        return true
//    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let radians = atan2f(Float(container.transform.b), Float(container.transform.a))
        var newVal = 0.0
        for c in cloves! {
            
            if (c.minValue > 0 && c.maxValue < 0) { // anomalous case
                
                if (c.maxValue > radians || c.minValue < radians) {
                    
                    if (radians > 0) { // we are in the positive quadrant
                        
                        newVal = Double(radians) - M_PI;
                        
                    } else { // we are in the negative one
                        
                        newVal = M_PI + Double(radians)
                        
                    }
                    currentValue = c.value;
                    
                }
                
            }
                
            else if (radians > c.minValue && radians < c.maxValue) {
                
                newVal = Double(radians) - Double(c.midValue)
                currentValue = c.value;
                
            }
            
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        let t = CGAffineTransformRotate(container.transform, CGFloat(-newVal))
        container.transform = t;
        UIView.commitAnimations()
//        let im = self.getCloveByValue(currentValue)
//        im.alpha = maxAlphavalue
    }
//    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
//        //container.userInteractionEnabled = true;
//        
//        
//        
//    }
    
    
    


}
