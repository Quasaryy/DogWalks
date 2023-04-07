//
//  ViewController.swift
//  DogWalks
//
//  Created by Yury on 07/04/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    
    init(managedContext: NSManagedObjectContext!) {
        super.init(nibName: nil, bundle: nil)
        self.managedContext = managedContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }


}

