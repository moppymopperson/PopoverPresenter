//
//  PopoverPresenter.swift
//  PopoverPresenter
//
//  Created by Erik Hornberger on 12/8/16.
//  Copyright © 2016 EExT. All rights reserved.
//

import UIKit

/** 
 This class presents any view controller as a popover on top of some other view controller.
 
 - Author: Erik
 */
class PopoverPresenter: UIViewController {
    
    /// The view controller that will be presented as a popover
    var childController:UIViewController!
    
    /// Offset the presented view to the left/right
    var xOffset:CGFloat         = 0
    
    /// Offset the presented view up/down
    var yOffset:CGFloat         = 0
    
    /// Change the width of the view as a fraction of it's parent view
    var widthFraction:CGFloat   = 0.85
    
    /// Change the height of the view as a fraction of it's parent view
    var heightFraction:CGFloat  = 0.6
    
    /// If true, tapping outside the presented view controller will dismiss it
    var dismissOnTap = true
    
    /// A tap gesture recognizer that can be used to dismiss the presented view controller
    private var tapGestureRecognizer = UITapGestureRecognizer()
    
    /// Designated initializer: (must be called)
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overCurrentContext // Ensures the view controller behind is still shown
        modalTransitionStyle   = .coverVertical      // animate in vertically
        view.backgroundColor   = .clear              // make the background clear so the controller behind can be seen
        
        tapGestureRecognizer.addTarget(self, action: #selector(dismissTapped))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// Unused, but required to compile
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Always use this initializer
    convenience init(presenting controller:UIViewController) {
        self.init(nibName: nil, bundle: nil)
        self.childController = controller
    }
    
    /// The child view is not inserted until willAppear.
    /// This provides an opportunity to change the offset and fraction
    /// properties before calling presentViewController.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        insertchildControllersView()
    }
    
    
    /// Add the `childController` as a child view controller and insert
    /// it's view as a subview constrainted to a fraction of the view.
    private func insertchildControllersView() {
        
        // Add as a child controller.
        //`willMove` and `didMove` need to be called to keep the view
        // hiearchy and controller hierarchy in synch.
        childController.willMove(toParentViewController: self)
        addChildViewController(childController)
        childController.didMove(toParentViewController: self)
        
        // Add the subview and constrain it
        let subView = childController.view!
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xOffset).isActive = true
        subView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset).isActive = true
        subView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthFraction).isActive = true
        subView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightFraction).isActive = true
        
    }
    
    /// Dismiss the popover when the background is tapped if `dismissOnTap` is set to `true`.
    @objc private func dismissTapped() {
        if dismissOnTap {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}


extension PopoverPresenter: UIGestureRecognizerDelegate {
    
    /// If the touch event came from inside of the child controller's view, don't respond to it
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return  !(touch.view!.isDescendant(of: childController.view!))
    }
}
