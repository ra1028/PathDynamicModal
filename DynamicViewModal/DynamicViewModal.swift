//
//  DynamicViewModal.swift
//  DynamicViewModal-Demo
//
//  Created by Ryo Aoyama on 2/9/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

@objc class DynamicViewModal {
    
    /* public properties */
    
    var closeByTapBackground: Bool = true
    var closedHandler: (() -> Void)?
    
    /* private properties */
    
    private weak var view: UIView?
    private var baseView: ModalRetainView = ModalRetainView()
    private var backgroundView: UIControl! = UIControl()
    private var animator: UIDynamicAnimator!
    private var attachment: UIAttachmentBehavior?
    private var push: UIPushBehavior?
    
    /* public functions */
    
    class func show(contentView view: UIView, inView: UIView) -> DynamicViewModal {
        let modal = DynamicViewModal()
        modal.show(contentView: view, inView: inView)
        
        return modal
    }
    
    func show(contentView view: UIView, inView: UIView) {
        self.view = view
        self.baseView.modal = self
        
        self.baseView.center = inView.center
        self.configureViewPosition(view: view)
        self.baseView.addSubview(view)
        inView.addSubview(self.baseView)
        
        self.fadeBackgroundView(fromAlpha: 0, toAlpha: 1.0, completion: nil)
        self.applyShowBehaviors(view: view)
    }
    
    func close() {
        self.applyCloseBehaviors(view: self.view!)
        self.fadeBackgroundView(fromAlpha: 1.0, toAlpha: 0, completion: { (flag) -> () in
            self.baseView.removeFromSuperview()
            self.baseView.modal = nil
            self.closedHandler?()
            }
        )
    }
    
    init() {
        self.setup()
    }
    
    /* private functions */
    
    private func setup() {
        self.animator = UIDynamicAnimator(referenceView: self.baseView)

        self.baseView.frame = UIScreen.mainScreen().bounds
        
        self.backgroundView.frame = UIScreen.mainScreen().bounds
        self.backgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.backgroundView.addTarget(self, action: "handleBackgroundView:", forControlEvents: .TouchUpInside)
        
        self.baseView.addSubview(self.backgroundView)
    }
    
    private func applyShowBehaviors(#view: UIView) {
        self.animator.removeAllBehaviors()
        
        self.attachment = UIAttachmentBehavior(item: view, offsetFromCenter: UIOffsetMake(0, -20.0), attachedToAnchor: self.baseView.center)
        self.attachment!.length = 0
        self.attachment!.damping = 2.0
        self.attachment!.frequency = 10.0
        
        self.push = UIPushBehavior(items: [view], mode: .Instantaneous)
        self.push!.setTargetOffsetFromCenter(UIOffset(horizontal: -0.5, vertical: 0), forItem: view)
        self.push!.pushDirection = CGVectorMake(0, 100.0)
        self.push!.action = {[weak self] in
            self?.fixOnCenter()
            return
        }
        
        self.animator.addBehavior(self.attachment)
        self.animator.addBehavior(self.push)
    }
    
    private func applyCloseBehaviors(#view: UIView) {
        self.animator.removeAllBehaviors()
        
        self.push = UIPushBehavior(items: [view], mode: .Instantaneous)
        self.push!.setTargetOffsetFromCenter(UIOffset(horizontal: 2.0, vertical: 0), forItem: view)
        self.push!.pushDirection = CGVectorMake(0, 100.0)
        
        self.animator.addBehavior(self.push)
    }
    
    private func fixOnCenter() {
        if self.view?.center.y >= self.baseView.center.y + 15.0 {
            self.animator.removeAllBehaviors()
            UIView.animateWithDuration(0.12, delay: 0, options: .BeginFromCurrentState | .CurveEaseOut, animations: { () -> Void in
                self.view?.center = self.baseView.center
                self.view?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 90.0))
            }, completion: { (flag) -> Void in
                UIView.animateWithDuration(0.07, delay: 0, options: .BeginFromCurrentState | .CurveEaseIn, animations: { () -> Void in
                    self.view?.transform = CGAffineTransformIdentity
                    return
                }, completion: nil)
            })
        }
    }
    
    private func configureViewPosition(#view: UIView) {
        view.center = self.baseView.center
        view.frame.origin.y = -view.bounds.height
    }
    
    private func fadeBackgroundView(#fromAlpha: CGFloat, toAlpha: CGFloat, completion: (Bool -> ())?) {
        UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.backgroundView.alpha = fromAlpha
            self.backgroundView.alpha = toAlpha
        }) { (flag) -> Void in
            completion?(flag)
            return
        }
    }
    
    func handleBackgroundView(sender: UIControl) {
        if self.closeByTapBackground {
            self.close()
        }
    }
}

private class ModalRetainView: UIView {
    private var modal: DynamicViewModal?
}