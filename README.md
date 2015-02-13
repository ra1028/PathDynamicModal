PathDynamicModal
=======================

#### A modal view using UIDynamicAnimator, like the Path for iOS.


## Screen shots
![screen shot1](https://github.com/ra1028/PathDynamicModal/raw/master/Assets/screen_shot1.png)
![screen shot2](https://github.com/ra1028/PathDynamicModal/raw/master/Assets/screen_shot2.png)


## Animation
![animated gif](https://github.com/ra1028/PathDynamicModal/raw/master/Assets/animation.gif)


## Explanation
This is the library that present modal with dynamic animation.  
Slant of dismiss modal by tap background is depend on tap horizontal position.  
Also, slant of swiping modal is depend on touch horizontal position and amount of swipe down.  
If you want to change the modal dropping speed, please set the property showMagnitude or closeMagnitude.  
By all means, use the Demo-project.


## Installation
Simply copy & paste PathDynamicModal.swift into your project.  
Or, use the git-submodule, please.  
git submodule add https://github.com/ra1028/PathDynamicModal PathDynamicModal  
Cocoapods has not yet supported.


## Usage
1. Create a instance of any UIView subclass.
2. Call the show(modalView: , inView: ) of PathDynamicModal class-function or instance-function.
3. For detail, please refer to Demo-project.


## Functions
```
class func show(modalView view: UIView, inView: UIView) -> PathDynamicModal // Show modal with settings default all.
func show(modalView view: UIView, inView: UIView) // Show modal with custom settings.
func closeWithLeansRandom() // Close modal with random slant.
func closeWithStraight() // Close modal with non slant.
func closeWithLeansRight() // Close modal with right slant.
func closeWithLeansLeft() Close modal with left slant.
```


## Property
```
var backgroundColor: UIColor // Default is UIColor.blackColor()
var backgroundAlpha: CGFloat // Default is 0.7 
var showMagnitude: CGFloat // Default is 250.0. This affects the speed of modal dropping to show.
var closeMagnitude: CGFloat // Default is 170.0. This affects the speed of modal dropping to close.
var closeByTapBackground: Bool // Default is true
var closeBySwipeBackground: Bool // Default is true
var showedHandler: (() -> Void)?
var closedHandler: (() -> Void)?
```


## License
PathDynamicModal is available under the MIT license. See the LICENSE file for more info.