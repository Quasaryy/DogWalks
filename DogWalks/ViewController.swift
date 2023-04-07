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
    private var currentDog: Dog?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var dateFormater: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .medium
        return dateFormater
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
        addConstraints()
        checkingDogExisting()

    }
    
}

// MARK: Table View Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentDog?.walks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        guard let walk: Walk = currentDog?.walks?[indexPath.row] as? Walk,
              let date = walk.date else { return cell }
        
        var content = cell.defaultContentConfiguration()
        content.text = dateFormater.string(from: date)
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currentDog?.removeFromWalks(at: indexPath.row)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Can't save \(error), \(error.userInfo)")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

// MARK: Table View Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension ViewController {
    // MARK: Constraints
    private func addConstraints() {
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
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        title = "Walk List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWalk))
    }
    
    @objc private func addWalk() {
        let currentWalk = Walk(context: managedContext)
        currentWalk.date = Date()
        currentDog?.addToWalks(currentWalk)
        
        do {
            try managedContext.save()
            guard let walks = currentDog?.walks else { return }
            let indexPath: IndexPath = [0, walks.count - 1]
            tableView.insertRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("Can't save \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK: Checking Dog Existing
    private func checkingDogExisting() {
        do {
            currentDog = try managedContext.fetch(Dog.fetchRequest()).first
            
            if currentDog == nil {
                currentDog = Dog(context: managedContext)
                currentDog?.name = "Rex"
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
}

