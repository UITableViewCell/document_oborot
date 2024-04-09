//
//  DepartmentWorkerViewController.swift
//  document_oborot
//
//  Created by 123 on 06.04.2024.
//

import UIKit

class DepartmentWorkerViewController: UIViewController {
    
    
    private var role = 2
    private var tableView: UITableView!
    
    private var tasks: [Order] = []
    
    private var newTasks: [Order] = []
    private var sendedTasks: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Работник"
        view.backgroundColor = .systemBackground
        setupUI()
        //        setupConstranits()
        fetchData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
    }
    
    
    fileprivate func fetchData() {
        FirebaseManager.shared.getAllTasks(role: 1) { [weak self] tasks in
            self?.tasks.removeAll()
            self?.newTasks.removeAll()
            self?.sendedTasks.removeAll()
            self?.tasks = tasks
            print(tasks)
            for order in tasks {
                if order.status == "new" && order.implementer == self?.role {
                    self?.newTasks.append(order)
                } else if order.status == "ready" && order.implementer == self?.role {
                    self?.sendedTasks.append(order)
                }
                self?.tableView.reloadData()
            }
            
        }
    }
    
    
    
    @objc func refresh() {
        fetchData()
    }
    
    private func setupUI() {
        
        tableView = UITableView(frame: view.safeAreaLayoutGuide.layoutFrame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    
}


// MARK: - Table View DataSource
extension DepartmentWorkerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return newTasks.count
        case 1: return sendedTasks.count
        default: return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        let section = indexPath.section
        switch section {
        case 0: cell.textLabel?.text = newTasks[indexPath.row].name
        case 1: cell.textLabel?.text = sendedTasks[indexPath.row].name
        default: break
        }
        
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Новые поручения"
        case 1: return "Отправленные"
        default: return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        switch section {
        case 0:
            let taskVC = TaskViewController()
            taskVC.configure(with: newTasks[indexPath.row], and: role)
            present(taskVC, animated: true)
        case 1:
            let taskVC = TaskViewController()
            taskVC.configure(with: sendedTasks[indexPath.row], and: role)
            present(taskVC, animated: true)
        default: return
        }
        
    }
    
    
}

