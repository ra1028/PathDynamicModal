//
//  DynamicViewModal.swift
//  DynamicViewModal-Demo
//
//  Created by Ryo Aoyama on 2/9/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class DynamicViewModal: NSObject, UIGestureRecognizerDelegate {
    
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
    private var backgroundView: ModalRetainView! = ModalRetainView()
    private var animator: UIDynamicAnimator!
    private var attachment: UIAttachmentBehavior?
    private var push: UIPushBehavior?
    private var dynamicItem: UIDynamicItemBehavior?
    private var tap: UITapGestureRecognizer!
    private var pan: UIPanGestureRecognizer!
    private var originalCenter: CGPoint! = CGPointZero
    
    /* internal functions */
    
    class func show(contentView view: UIView, inView: UIView) -> DynamicViewModal {
        let modal = DynamicViewModal()
        modal.show(contentView: view, inView: inView)
        
        return modal
    }
    
    func show(contentView view: UIView, inView: UIView) {
        self.view = view
        self.backgroundView.modal = self
        
        self.backgroundView.center = inView.center
        self.configureViewPosition(view: view)
        self.backgroundView.addSubview(view)
        inView.addSubview(self.backgroundView)
        
        self.fadeBackgroundView(fromAlpha: 0, toAlpha: 1.0, completion: nil)
        self.applyShowBehaviors(view: view)
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
    
    private func close(horizontalOffset h: CGFloat, backgroundFromAlpha: CGFloat = 1.0) {
        self.applyCloseBehaviors(view: self.view, horizontalOffset: h)
        self.fadeBackgroundView(fromAlpha: backgroundFromAlpha, toAlpha: 0, completion: { (flag) -> () in
            self.backgroundView.removeFromSuperview()
            self.backgroundView.modal = nil
            self.view.center = self.originalCenter
            self.closedHandler?()
            }
        )
    }
    
    private func applyShowBehaviors(#view: UIView) {
        self.animator.removeAllBehaviors()
        
        self.attachment = UIAttachmentBehavior(item: view, offsetFromCenter: UIOffsetMake(0, 0.0), attachedToAnchor: self.backgroundView.center)
        self.attachment!.length = 0
        self.attachment!.damping = 1.0
        self.attachment!.frequency = 5.0
        
        self.push = UIPushBehavior(items: [view], mode: .Instantaneous)
        self.push!.setTargetOffsetFromCenter(UIOffset(horizontal: -3.0, vertical: 0), forItem: view)
        self.push!.pushDirection = CGVectorMake(0, 100.0)
        self.push!.action = {[weak self] in
            if let sSelf = self {
                if sSelf.view.center.y >= sSelf.backgroundView.center.y - 20.0 {
                    sSelf.fixOnCenter()
                }
            }
        }
        
        self.animator.addBehavior(self.attachment)
        self.animator.addBehavior(self.push)
    }
    
    private func applyCloseBehaviors(#view: UIView, horizontalOffset h: CGFloat) {
        self.animator.removeAllBehaviors()
        
        self.push = UIPushBehavior(items: [view], mode: .Instantaneous)
        self.push!.setTargetOffsetFromCenter(UIOffset(horizontal: h, vertical: 0), forItem: view)
        self.push!.pushDirection = CGVectorMake(0, 100.0)
        
        self.dynamicItem = UIDynamicItemBehavior(items: [view])
        self.dynamicItem!.density = 0.8
        
        self.animator.addBehavior(self.push)
        self.animator.addBehavior(self.dynamicItem)
    }
    
    private func fixOnCenter() {
        self.animator.removeAllBehaviors()
        UIView.animateWithDuration(0.12, delay: 0, options: .BeginFromCurrentState | .CurveEaseOut, animations: { () -> Void in
            self.view.center.y = self.backgroundView.center.y + 10.0
            self.view.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 135.0))
            }, completion: { (flag) -> Void in
                UIView.animateWithDuration(0.12, delay: 0, options: .BeginFromCurrentState | .CurveEaseOut, animations: { () -> Void in
                    self.view.center = self.backgroundView.center
                    self.view.transform = CGAffineTransformIdentity
                    }, completion:  { (flag) -> Void in
                        self.showedHandler?()
                        return
                })
        })
    }
    
    private func configureViewPosition(#view: UIView) {
        self.originalCenter = view.center
        view.center = self.backgroundView.center
        view.frame.origin.y = -view.bounds.height
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
                let isDownGesuture = self.view.center.y >= self.backgroundView.center.y
                let panYAmountOnBackground = pan.y / CGRectGetHeight(self.backgroundView.bounds)
                let angle = (CGFloat(M_PI) / 180.0) * self.tapPointXPercentage(pointX: location.x) * (5.0 * panYAmountOnBackground)
                self.view.transform = CGAffineTransformMakeRotation(isDownGesuture ? angle : 0)
                self.view.center.y = self.backgroundView.center.y + (isDownGesuture ? pan.y : pan.y / 10.0)
                self.backgroundView.backgroundColor = self.backgroundColor.colorWithAlphaComponent(self.backgroundAlpha * (isDownGesuture ? 1.0 - panYAmountOnBackground : 1.0))
            case .Cancelled, .Ended:
                if self.view.center.y >= CGRectGetHeight(self.backgroundView.bounds)
                    || velocityY >= 200.0 {
                    self.close(horizontalOffset: 0)
                }else {
                    UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState | .CurveEaseOut, animations: { () -> Void in
                        self.view.transform = CGAffineTransformIdentity
                        self.view.center = self.backgroundView.center
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
    private var modal: DynamicViewModal?
}