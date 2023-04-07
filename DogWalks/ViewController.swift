//
//  ViewController.swift
//  DogWalks
//
//  Created by Yury on 07/04/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: Properties
    private var managedContext: NSManagedObjectContext!
    private let cellID = "Cell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        //tableView.delegate = self
        return tableView
    }()
    
    
    // MARK: Init
    init(managedContext: NSManagedObjectContext!) {
        super.init(nibName: nil, bundle: nil)
        self.managedContext = managedContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetup()
        view.addSubview(tableView)
        tableConstraints()
    }

}

// MARK: Table View Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Hello"
        cell.contentConfiguration = content
        
        return cell
    }
    
}


extension ViewController {
    // MARK: Constraints
    private func tableConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: Navigation Bar
    private func navigationBarSetup() {
        let appereance = UINavigationBarAppearance()
        appereance.backgroundColor = .systemPink
        appereance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appereance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appereance
        navigationController?.navigationBar.scrollEdgeAppearance = appereance
        
        navigationController?.navigationBar.tintColor = .white
        title = "Walk List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWalk))
    }
    
    @objc private func addWalk() {
        
    }
}

