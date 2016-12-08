//
//  ViewController.swift
//  PopoverPresenter
//
//  Created by Erik Hornberger on 12/8/16.
//  Copyright © 2016 EExT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func pressedProgramaticSegueButton(_ sender: Any) {
        
        // 1. Create the view controller to present as a popover
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .purple
        
        // 2. Create the presenter
        let presenter = PopoverPresenter(presenting: vc3)
        
        // 3. Present the presenter
        present(presenter, animated: true, completion: nil)
    }

}

