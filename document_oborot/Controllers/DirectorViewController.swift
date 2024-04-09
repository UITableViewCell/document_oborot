//
//  DirectorViewController.swift
//  document_oborot
//
//  Created by 123 on 06.04.2024.
//

import UIKit

class DirectorViewController: UIViewController {
    
    var role = 0
    
    var name = ["Директор"]
    var workers = ["Глава Отдела", "Специалист отдела"]
    var tasks: [Order] = []
    
    var aproveTasks: [Order] = []
    var completedTasks: [Order] = []
    private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Директор"
        view.backgroundColor = .systemGray2
        setupUI()
        setupConstranits()
        fetchData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))

    }
    
    
    fileprivate func fetchData() {
        FirebaseManager.shared.getAllTasks(role: 1) { [weak self] tasks in
            self?.tasks.removeAll()
            self?.aproveTasks.removeAll()
            self?.completedTasks.removeAll()
            self?.tasks = tasks
            print(tasks)
            for order in tasks {
                if order.status == "done" {
                    self?.completedTasks.append(order)
                } else if order.status == "ready" && order.implementer == self!.role + 1 {
                    self?.aproveTasks.append(order)
                }
                self?.tableView.reloadData()
            }
            
        }
    }
    
    
    @objc func refresh() {
        fetchData()
    }
    
    private func setupUI() {
        // create task
        // tasks
        // closed

        let createTaskButton = UIButton()
        createTaskButton.setTitle("Создать поручение", for: .normal)
        createTaskButton.backgroundColor = .green
        createTaskButton.translatesAutoresizingMaskIntoConstraints = false
        createTaskButton.addTarget(self, action: #selector(createTask), for: .touchUpInside)
        view.addSubview(createTaskButton)
        createTaskButton.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
        createTaskButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        createTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        createTaskButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        createTaskButton.layer.cornerRadius = 20
        createTaskButton.layer.masksToBounds = true
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 150, width: view.frame.width, height: view.frame.height - 50))
        tableView.delegate = self
        tableView.dataSource = self
        createTaskButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
       }
    
    
    private func setupConstranits() {
        NSLayoutConstraint.activate([

        ])
    }
    // MARK: - Actions
    
    @objc private func createTask() {
        present(CreateTaskViewController(role: role), animated: true)
    }


}

extension DirectorViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK:  Table View DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        
        switch section {
        case 0: return aproveTasks.count
        case 1: return completedTasks.count
//        case 2: return completedTasks.count
        default: return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let section = indexPath.section
        switch section {
        case 0: cell.textLabel?.text = aproveTasks[indexPath.row].name
        case 1: cell.textLabel?.text = completedTasks[indexPath.row].name
//        case 2: cell.textLabel?.text = completedTasks[indexPath.row]
        default: break
        }
        return cell
    }
    

    // MARK:  Table View Delegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Подписать"
        case 1: return "Закрытые поручения"
//        case 2: return "Закрытые поручения"
        default: return ""
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        switch section {
        case 0:
            let taskVC = TaskViewController()
            taskVC.configure(with: aproveTasks[indexPath.row], and: role)
            present(taskVC, animated: true)
        case 1:
            let taskVC = TaskViewController()
            taskVC.configure(with: completedTasks[indexPath.row], and: role)
            present(taskVC, animated: true)
        default: return
        }
        
    }


}

