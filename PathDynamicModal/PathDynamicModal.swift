//
//  PathDynamicModal.swift
//  PathDynamicModal-Demo
//
//  Created by Ryo Aoyama on 2/9/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class PathDynamicModal: NSObject, UIGestureRecognizerDelegate {
    
    /* internal properties */
    
    var backgroundColor: UIColor = UIColor.blackColor() {
        didSet {
            self.backgroundView.backgroundColor = backgroundColor.colorWithAlphaComponent(self.backgroundAlpha)
        }
    }
    var backgroundAlpha: CGFloat = 0.7 {
        didSet {
            self.backgroundView.backgroundColor = self.backgroundColor.colorWithAlphaComponent(backgroundAlpha)
        }
    }
    var closeByTapBackground: Bool = true
    var closeBySwipeBackground: Bool = true
    var showedHandler: (() -> Void)?
    var closedHandler: (() -> Void)?
    var closeButton: UIButton? {
        didSet {
            
        }
    }
    
    /* private properties */
    
    private weak var view: UIView!
    private var contentView: UIView! = UIView()
    private var backgroundView: ModalRetainView! = ModalRetainView()
    private var animator: UIDynamicAnimator!
    private var attachment: UIAttachmentBehavior?
    private var push: UIPushBehavior?
    private var dynamicItem: UIDynamicItemBehavior?
    private var tap: UITapGestureRecognizer!
    private var pan: UIPanGestureRecognizer!
    private var originalTranslatesAutoresizingMaskIntoConstraints: Bool! = true
    private var originalCenter: CGPoint! = CGPointZero
    
    /* internal functions */
    
    class func show(modalView view: UIView, inView: UIView) -> PathDynamicModal {
        let modal = PathDynamicModal()
        modal.show(modalView: view, inView: inView)
        
        return modal
    }
    
    func show(modalView view: UIView, inView: UIView) {
        self.view = view
        self.backgroundView.modal = self
        
        self.backgroundView.center = inView.center
        self.configureContentView(view: view)
        inView.addSubview(self.backgroundView)
        
        self.fadeBackgroundView(fromAlpha: 0, toAlpha: 1.0, completion: nil)
        self.applyShowBehaviors()
    }
    
    func closeWithLeansLeft() {
        self.close(horizontalOffset: -2.0)
    }
    
    func closeWithLeansRight() {
        self.close(horizontalOffset: 2.0)
    }
    
    func closeWithStraight() {
        self.close(horizontalOffset: 0)
    }
    
    func closeWithLeansRandom() {
        var rand = (30.0 - CGFloat(arc4random_uniform(60))) / 10.0
        self.close(horizontalOffset: rand)
    }
    
    override init() {
        super.init()
        self.setup()
    }
    
    /* private functions */
    
    private func setup() {
        self.animator = UIDynamicAnimator(referenceView: self.backgroundView)
        
        self.tap = UITapGestureRecognizer(target: self, action: "handleBackgroundView:")
        self.tap.delegate = self
        
        self.pan = UIPanGestureRecognizer(target: self, action: "panBackgroundView:")
        self.pan.delegate = self
        
        self.backgroundView.frame = UIScreen.mainScreen().bounds
        self.backgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        self.backgroundView.addGestureRecognizer(self.tap)
        self.backgroundView.addGestureRecognizer(self.pan)
    }
    
    private func close(horizontalOffset h: CGFloat) {
        self.applyCloseBehaviors(horizontalOffset: h)
        
        self.fadeBackgroundView(fromAlpha: 1.0, toAlpha: 0, completion: { (flag) -> () in
            self.backgroundView.removeFromSuperview()
            self.backgroundView.modal = nil
            
            self.view.center = self.originalCenter
            self.view.setTranslatesAutoresizingMaskIntoConstraints(self.originalTranslatesAutoresizingMaskIntoConstraints)
            
            self.closedHandler?()
            }
        )
    }
    
    private func applyShowBehaviors() {
        self.animator.removeAllBehaviors()
        
        self.attachment = UIAttachmentBehavior(item: self.contentView, offsetFromCenter: UIOffsetMake(0, 0.0), attachedToAnchor: self.backgroundView.center)
        self.attachment!.length = 0
        self.attachment!.damping = 1.0
        self.attachment!.frequency = 5.0
        
        self.push = UIPushBehavior(items: [self.contentView], mode: .Instantaneous)
        self.push!.setTargetOffsetFromCenter(UIOffset(horizontal: -2.0, vertical: 0), forItem: self.contentView)
        self.push!.pushDirection = CGVectorMake(0, 100.0)
        self.push!.action = {[weak self] in
            if let sSelf = self {
                if sSelf.contentView.center.y >= sSelf.backgroundView.center.y - 20.0 {
                    sSelf.fixOnCenter()
                }
            }
        }
        
        self.animator.addBehavior(self.attachment)
        self.animator.addBehavior(self.push)
    }
    
    private func applyCloseBehaviors(horizontalOffset h: CGFloat) {
        self.animator.removeAllBehaviors()
        
        self.push = UIPushBehavior(items: [self.contentView], mode: .Instantaneous)
        self.push!.setTargetOffsetFromCenter(UIOffset(horizontal: h, vertical: 0), forItem: self.contentView)
        self.push!.pushDirection = CGVectorMake(0, 100.0)
        
        self.dynamicItem = UIDynamicItemBehavior(items: [self.contentView])
        self.dynamicItem!.density = 1.2
        
        self.animator.addBehavior(self.push)
        self.animator.addBehavior(self.dynamicItem)
    }
    
    private func fixOnCenter() {
        self.animator.removeAllBehaviors()
        
        UIView.animateWithDuration(0.12, delay: 0, options: .BeginFromCurrentState | .CurveEaseOut, animations: { () -> Void in
            self.contentView.center.y = self.backgroundView.center.y + 10.0
            self.contentView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 90.0))
            }, completion: { (flag) -> Void in
                UIView.animateWithDuration(0.14, delay: 0, options: .BeginFromCurrentState | .CurveEaseOut, animations: { () -> Void in
                    self.contentView.center = self.backgroundView.center
                    self.contentView.transform = CGAffineTransformIdentity
                    }, completion:  { (flag) -> Void in
                        self.showedHandler?()
                        return
                })
        })
    }
    
    private func configureContentView(#view: UIView) {
        self.originalCenter = view.center
        self.originalTranslatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints()
        view.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        self.contentView.frame = view.bounds
        self.contentView.center = self.backgroundView.center
        self.contentView.frame.origin.y = -self.contentView.bounds.height
        view.frame.origin = CGPointZero
        
        self.contentView.addSubview(view)
        self.backgroundView.addSubview(self.contentView)
    }
    
    private func fadeBackgroundView(#fromAlpha: CGFloat, toAlpha: CGFloat, completion: (Bool -> ())?) {
        UIView.animateWithDuration(0.4, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.backgroundView.backgroundColor = self.backgroundColor.colorWithAlphaComponent(self.backgroundAlpha * fromAlpha)
            self.backgroundView.backgroundColor = self.backgroundColor.colorWithAlphaComponent(self.backgroundAlpha * toAlpha)
        }) { (flag) -> Void in
            completion?(flag)
            return
        }
    }
    
    private func tapPointXPercentage(#pointX: CGFloat) -> CGFloat {
        /* return |-1 0 1| */
        let width = CGRectGetWidth(self.backgroundView.bounds)
        if pointX >= width / 2.0 {
            return (2.0 - width / pointX)
        }else {
            return -(2.0 - width / (width - (pointX + 1)))
        }
    }
    
    func handleBackgroundView(sender: UITapGestureRecognizer) {
        if self.closeByTapBackground {
            let locationX = sender.locationInView(self.backgroundView).x
            let offsetH: CGFloat = 3.0 * self.tapPointXPercentage(pointX: locationX)
            self.close(horizontalOffset: offsetH)
        }
    }
    
    func panBackgroundView(sender: UIPanGestureRecognizer) {
        if self.closeBySwipeBackground {
            let location = sender.locationInView(self.backgroundView)
            let pan = sender.translationInView(self.backgroundView)
            let velocityY = sender.velocityInView(self.backgroundView).y
            switch sender.state {
            case .Changed:
                let isDownGesuture = self.contentView.center.y >= self.backgroundView.center.y
                let panYAmountOnBackground = pan.y / CGRectGetHeight(self.backgroundView.bounds)
                let angle = (CGFloat(M_PI) / 180.0) * self.tapPointXPercentage(pointX: location.x) * (8.0 * panYAmountOnBackground)
                self.contentView.transform = CGAffineTransformMakeRotation(isDownGesuture ? angle : 0)
                self.contentView.center.y = self.backgroundView.center.y + (isDownGesuture ? pan.y : pan.y / 10.0)
                self.backgroundView.backgroundColor = self.backgroundColor.colorWithAlphaComponent(self.backgroundAlpha * (isDownGesuture ? 1.0 - panYAmountOnBackground : 1.0))
            case .Cancelled, .Ended:
                if self.contentView.center.y >= CGRectGetHeight(self.backgroundView.bounds)
                    || velocityY >= 200.0 {
                    self.close(horizontalOffset: 0)
                }else {
                    UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState | .CurveEaseOut, animations: { () -> Void in
                        self.contentView.transform = CGAffineTransformIdentity
                        self.contentView.center = self.backgroundView.center
                        self.backgroundView.backgroundColor = self.backgroundColor.colorWithAlphaComponent(self.backgroundAlpha)
                        }, completion: nil)
                }
            default:
                break
            }
        }
    }
    
    /* delegate functions */
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (gestureRecognizer.view == touch.view || gestureRecognizer == self.pan) ? true : false
    }
}

private class ModalRetainView: UIView {
    private var modal: PathDynamicModal?
}