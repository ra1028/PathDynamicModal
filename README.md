PathDynamicModal
=======================

#### A modal view using UIDynamicAnimator, like the Path for iOS.


## Screen shots
![screen shot1](https://github.com/ra1028/PathDynamicModal/raw/master/Assets/screen_shot1.png)
![screen shot2](https://github.com/ra1028/PathDynamicModal/raw/master/Assets/screen_shot2.png)


## Animation
![animated gif](https://github.com/ra1028/PathDynamicModal/raw/master/Assets/animation.gif)


## Installation
Simply copy & paste PathDynamicModal.swift into your project.
Or, use the git-submodule, please.
git submodule add https://github.com/ra1028/PathDynamicModal PathDynamicModal
Cocoapods has not yet supported.


## Usage
1. Create a instance of any UIView subclass.
2. Call the show(modalView: , inView: ) of PathDynamicModal class-function or instance-function.
3. For detail, please refer to Demo-project.


## Property
```
var backgroundColor: UIColor // Default is UIColor.blackColor()
var backgroundAlpha: CGFloat // Default is 0.7 
var showMagnitude: CGFloat // Default is 250.0. This affects the speed modal of dropping to show.
var closeMagnitude: CGFloat // Default is 170.0. This affects the speed of modal dropping to close.
var closeByTapBackground: Bool // Default is true
var closeBySwipeBackground: Bool // Default is true
var showedHandler: (() -> Void)?
var closedHandler: (() -> Void)?
```


## License
PathDynamicModal is available under the MIT license. See the LICENSE file for more info.