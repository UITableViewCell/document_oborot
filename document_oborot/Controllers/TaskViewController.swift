//
//  TaskViewController.swift
//  document_oborot
//
//  Created by 123 on 06.04.2024.
//

import UIKit
import MobileCoreServices


class TaskViewController: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    private let picker = UIImagePickerController()
    
    private var task: Order!
    private var role: Int!
    private var textLabel: UILabel!
    private var textLabel2: UILabel!
    private var textLabel3: UILabel!
    private var delegateTaskButton: UIButton!
    private var loadDocButton: UIButton!
    private var documentViewButton: UIButton!
    
    private var cancelButton: UIButton?
    private var sendForRevisionButton: UIButton?
    private var aprooveButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstranits()
        
        
    }
    
    private func setupUI() {
        switch role{
        case 0:
            textLabel = UILabel()
            textLabel.backgroundColor = .secondarySystemBackground
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.text = "Поручение: " + task.name
            view.addSubview(textLabel)
            
            textLabel2 = UILabel()
            textLabel2.backgroundColor = .secondarySystemBackground
            textLabel2.translatesAutoresizingMaskIntoConstraints = false
            
            if task.creator == 0 {
                textLabel2.text = "От " + "Директор"
            } else if task.creator == 1 {
                textLabel2.text = "От " + "Руководитель отдела"
            }
            view.addSubview(textLabel2)
            
            
            textLabel3 = UILabel()
            textLabel3.backgroundColor = .secondarySystemBackground
            textLabel3.translatesAutoresizingMaskIntoConstraints = false
            textLabel3.numberOfLines = 0
            textLabel3.text = task.text
            view.addSubview(textLabel3)
            
 
            cancelButton = UIButton()
            guard let cancelButton = cancelButton else {return}
            cancelButton.layer.cornerRadius = 10
            cancelButton.layer.masksToBounds = true
            cancelButton.setTitle("Отменить", for: .normal)
            cancelButton.backgroundColor = .systemRed
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            
     
            sendForRevisionButton = UIButton()
            guard let sendForRevisionButton = sendForRevisionButton else {return}
            sendForRevisionButton.backgroundColor = .systemOrange
            sendForRevisionButton.layer.cornerRadius = 10
            sendForRevisionButton.layer.masksToBounds = true
            sendForRevisionButton.setTitle("Отправить на доработку", for: .normal)
            sendForRevisionButton.addTarget(self, action: #selector(sendForRevisionButtonTapped), for: .touchUpInside)
            
            
            aprooveButton = UIButton()
            guard let aprooveButton = aprooveButton else {return}
            aprooveButton.backgroundColor = .systemGreen
            aprooveButton.layer.cornerRadius = 10
            aprooveButton.layer.masksToBounds = true
            aprooveButton.setTitle("Подписать", for: .normal)
            aprooveButton.addTarget(self, action: #selector(aprooveButtonTapped), for: .touchUpInside)
            
      
            view.addSubview(cancelButton)
            view.addSubview(sendForRevisionButton)
            view.addSubview(aprooveButton)

            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            sendForRevisionButton.translatesAutoresizingMaskIntoConstraints = false
            aprooveButton.translatesAutoresizingMaskIntoConstraints = false
            
           
            
            
            
            
            documentViewButton = UIButton()
            documentViewButton.addTarget(self, action: #selector(documentAction), for: .touchUpInside)
            documentViewButton.layer.cornerRadius = 10
            documentViewButton.layer.masksToBounds = true
            documentViewButton.translatesAutoresizingMaskIntoConstraints = false
            documentViewButton.backgroundColor = .systemBlue
            documentViewButton.setTitle("⬇ "+task.docId, for: .normal)
//            documentViewButton.setImage(UIImage(systemName: "square.and.arrow.down")?.withRenderingMode(.alwaysOriginal), for: .normal)
            documentViewButton.isHidden = true
            view.addSubview(documentViewButton)
            
            
            
            if task.docId.isEmpty {
//                loadDocButton = UIButton()
//                delegateTaskButton.isHidden = false
//                loadDocButton.addTarget(self, action: #selector(loadAction), for: .touchUpInside)
//                loadDocButton.translatesAutoresizingMaskIntoConstraints = false
//                loadDocButton.backgroundColor = .systemGreen
//                loadDocButton.setTitle("Загрузить документ", for: .normal)
//                view.addSubview(loadDocButton)
                
            } else {
                documentViewButton.isHidden = false
//                loadDocButton = UIButton()
//                loadDocButton.addTarget(self, action: #selector(loadAction), for: .touchUpInside)
//                loadDocButton.translatesAutoresizingMaskIntoConstraints = false
//                loadDocButton.backgroundColor = .systemRed
//                loadDocButton.setTitle("Удалить файл", for: .normal)
//                view.addSubview(loadDocButton)
            }
        case 1:
            textLabel = UILabel()
            textLabel.backgroundColor = .secondarySystemBackground
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.text = "Поручение: " + task.name
            view.addSubview(textLabel)
            
            textLabel2 = UILabel()
            textLabel2.backgroundColor = .secondarySystemBackground
            textLabel2.translatesAutoresizingMaskIntoConstraints = false
            
            if task.creator == 0 {
                textLabel2.text = "От: " + "Директор"
            } else if task.creator == 1 {
                textLabel2.text = "От: " + "Руководитель отдела"
            }
            view.addSubview(textLabel2)
            
            
            textLabel3 = UILabel()
            textLabel3.translatesAutoresizingMaskIntoConstraints = false
            textLabel3.numberOfLines = 0
            textLabel3.text = task.text
            textLabel3.backgroundColor = .secondarySystemBackground
            view.addSubview(textLabel3)
            
            delegateTaskButton = UIButton()
            delegateTaskButton.layer.cornerRadius = 10
            delegateTaskButton.layer.masksToBounds = true
            delegateTaskButton.addTarget(self, action: #selector(delegateAction), for: .touchUpInside)
            delegateTaskButton.translatesAutoresizingMaskIntoConstraints = false
            delegateTaskButton.backgroundColor = .systemOrange
            delegateTaskButton.setTitle("Делегировать", for: .normal)
            delegateTaskButton.isHidden = true
            view.addSubview(delegateTaskButton)
            
            
            
            documentViewButton = UIButton()
            documentViewButton.addTarget(self, action: #selector(documentAction), for: .touchUpInside)
            documentViewButton.layer.cornerRadius = 10
            documentViewButton.layer.masksToBounds = true
            documentViewButton.translatesAutoresizingMaskIntoConstraints = false
            documentViewButton.backgroundColor = .systemBlue
            documentViewButton.setTitle("⬇ "+task.docId, for: .normal)
  
            documentViewButton.isHidden = true
            view.addSubview(documentViewButton)
            
            
            
            if task.docId.isEmpty {
                loadDocButton = UIButton()
                loadDocButton.layer.cornerRadius = 10
                loadDocButton.layer.masksToBounds = true
                delegateTaskButton.isHidden = false
                loadDocButton.addTarget(self, action: #selector(loadAction), for: .touchUpInside)
                loadDocButton.translatesAutoresizingMaskIntoConstraints = false
                loadDocButton.backgroundColor = .systemGreen
                loadDocButton.setTitle("Загрузить документ", for: .normal)
                view.addSubview(loadDocButton)
                
            } else {
                documentViewButton.isHidden = false
                loadDocButton = UIButton()
                loadDocButton.layer.cornerRadius = 10
                loadDocButton.layer.masksToBounds = true
                loadDocButton.addTarget(self, action: #selector(loadAction), for: .touchUpInside)
                loadDocButton.translatesAutoresizingMaskIntoConstraints = false
                loadDocButton.backgroundColor = .systemRed
                loadDocButton.setTitle("Удалить файл", for: .normal)
                view.addSubview(loadDocButton)
                
                
                
                if task.status == "ready" {
                    cancelButton = UIButton()
                    guard let cancelButton = cancelButton else {return}
                    cancelButton.layer.cornerRadius = 10
                    cancelButton.layer.masksToBounds = true
                    cancelButton.setTitle("Отменить", for: .normal)
                    cancelButton.backgroundColor = .systemRed
                    cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
                    
             
                    sendForRevisionButton = UIButton()
                    guard let sendForRevisionButton = sendForRevisionButton else {return}
                    sendForRevisionButton.backgroundColor = .systemOrange
                    sendForRevisionButton.layer.cornerRadius = 10
                    sendForRevisionButton.layer.masksToBounds = true
                    sendForRevisionButton.setTitle("Отправить на доработку", for: .normal)
                    sendForRevisionButton.addTarget(self, action: #selector(sendForRevisionButtonTapped), for: .touchUpInside)
                    
                    
                    aprooveButton = UIButton()
                    guard let aprooveButton = aprooveButton else {return}
                    aprooveButton.backgroundColor = .systemGreen
                    aprooveButton.layer.cornerRadius = 10
                    aprooveButton.layer.masksToBounds = true
                    aprooveButton.setTitle("Подписать", for: .normal)
                    aprooveButton.addTarget(self, action: #selector(aprooveButtonTapped), for: .touchUpInside)
                    
              
                    view.addSubview(cancelButton)
                    view.addSubview(sendForRevisionButton)
                    view.addSubview(aprooveButton)

                    cancelButton.translatesAutoresizingMaskIntoConstraints = false
                    sendForRevisionButton.translatesAutoresizingMaskIntoConstraints = false
                    aprooveButton.translatesAutoresizingMaskIntoConstraints = false
                    
                    
                    NSLayoutConstraint.activate([

                        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        cancelButton.bottomAnchor.constraint(equalTo: documentViewButton.topAnchor, constant: -80),

                        sendForRevisionButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 20),
                        sendForRevisionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        sendForRevisionButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
                        
                        aprooveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        aprooveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        aprooveButton.topAnchor.constraint(equalTo: sendForRevisionButton.bottomAnchor, constant: 20)
                        
                    ])
                
                }
                
                
                
            }
            
            
        case 2:
            textLabel = UILabel()
            textLabel.backgroundColor = .secondarySystemBackground
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.text = "Поручение: " + task.name
            view.addSubview(textLabel)
            
            textLabel2 = UILabel()
            textLabel2.translatesAutoresizingMaskIntoConstraints = false
            textLabel2.backgroundColor = .secondarySystemBackground
            
            if task.creator == 0 {
                textLabel2.text = "От " + "Директор"
            } else if task.creator == 1 {
                textLabel2.text = "От " + "Руководитель отдела"
            }
            view.addSubview(textLabel2)
            
            
            textLabel3 = UILabel()
            textLabel3.translatesAutoresizingMaskIntoConstraints = false
            textLabel3.numberOfLines = 0
            textLabel3.backgroundColor = .secondarySystemBackground
            textLabel3.text = task.text
            view.addSubview(textLabel3)
            
            
            
            documentViewButton = UIButton()
            documentViewButton.addTarget(self, action: #selector(documentAction), for: .touchUpInside)
            documentViewButton.layer.cornerRadius = 10
            documentViewButton.layer.masksToBounds = true
            documentViewButton.translatesAutoresizingMaskIntoConstraints = false
            documentViewButton.backgroundColor = .systemBlue
            documentViewButton.setTitle(task.docId, for: .normal)

            documentViewButton.isHidden = true
            view.addSubview(documentViewButton)
            
            
            
            if task.docId.isEmpty {
                loadDocButton = UIButton()
                loadDocButton.layer.cornerRadius = 10
                loadDocButton.layer.masksToBounds = true
                loadDocButton.addTarget(self, action: #selector(loadAction), for: .touchUpInside)
                loadDocButton.translatesAutoresizingMaskIntoConstraints = false
                loadDocButton.backgroundColor = .systemGreen
                loadDocButton.setTitle("Загрузить документ", for: .normal)
                view.addSubview(loadDocButton)
                
            } else {
                documentViewButton.isHidden = false
                loadDocButton = UIButton()
                loadDocButton.layer.cornerRadius = 10
                loadDocButton.layer.masksToBounds = true
                loadDocButton.addTarget(self, action: #selector(loadAction), for: .touchUpInside)
                loadDocButton.translatesAutoresizingMaskIntoConstraints = false
                loadDocButton.backgroundColor = .systemRed
                loadDocButton.setTitle("Удалить файл", for: .normal)
                view.addSubview(loadDocButton)
            }
        default: return
        }
    }
    
    private func setupConstranits() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            
            textLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textLabel2.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            
            textLabel3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textLabel3.topAnchor.constraint(equalTo: textLabel2.bottomAnchor, constant: 20),
            
            documentViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            documentViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            documentViewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
           
            
            
            
        ])
        
        if role == 0 {
            NSLayoutConstraint.activate([

                cancelButton!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                cancelButton!.bottomAnchor.constraint(equalTo: documentViewButton.topAnchor, constant: -20),

                sendForRevisionButton!.leadingAnchor.constraint(equalTo: cancelButton!.trailingAnchor, constant: 20),
                sendForRevisionButton!.centerYAnchor.constraint(equalTo: cancelButton!.centerYAnchor),
                
                aprooveButton!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                aprooveButton!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                aprooveButton!.topAnchor.constraint(equalTo: documentViewButton.bottomAnchor, constant: 20)
                
            ])
        }
        
        if role == 1 {
            NSLayoutConstraint.activate([
                loadDocButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                loadDocButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                loadDocButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                
                
            delegateTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            delegateTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            delegateTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
             ])
        }
        if role == 2 {
            NSLayoutConstraint.activate([
                loadDocButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                loadDocButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                loadDocButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                

                
            ])
        }
        
    }
    
    public func configure(with model: Order, and role: Int) {
        self.task = model
        self.role = role
    }
    
    
    

     @objc func cancelButtonTapped() {
         task.status = "canceled"
         FirebaseManager.shared.newTask(task: self.task) { [weak self] in
             DispatchQueue.main.async {
                 self?.dismiss(animated: true)
             }
             
         }
     }

     @objc func sendForRevisionButtonTapped() {
         task.status = "new"
         FirebaseManager.shared.newTask(task: self.task) { [weak self] in
             DispatchQueue.main.async {
                 self?.dismiss(animated: true)
             }
             
         }
     }
    
    @objc func aprooveButtonTapped() {
        task.status = "done"
        FirebaseManager.shared.newTask(task: self.task) { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
            
        }
     }
    
    
    
    @objc private func documentAction() {
        FirebaseManager.shared.downloadFile(fileName: task.docId) {localFileURL in
            
            let activityViewController = UIActivityViewController(activityItems: [localFileURL], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    @objc private func delegateAction() {
        let vc = CreateTaskViewController(role: role)
        
        present(vc, animated: true) {
            vc.configure(with: self.task)
        }
    }
    
    @objc private func loadAction() {
        if task.docId.isEmpty {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.content])
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
        } else {
            self.task.docId = ""
            self.task.status = "new"
            FirebaseManager.shared.newTask(task: self.task) { [weak self] in
                DispatchQueue.main.async {
                    self?.loadDocButton.setTitle("Загрузить документ", for: .normal)
                    self?.loadDocButton.backgroundColor = .systemGreen
                    if self?.role == 1 {
                        self?.delegateTaskButton.isHidden = false
                    }
                    self?.documentViewButton.isHidden = true
                    
                }
                
            }
        }
        
    }
    
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else {
            print("Файл не выбран")
            return
        }
        
        FirebaseManager.shared.loadFile(fileURL: fileURL) { fileName in
            
            self.task.docId = fileName
            self.task.status = "ready"
            FirebaseManager.shared.newTask(task: self.task) { [weak self] in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Готово", message: fileName+" сохранен", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                    
                    self?.loadDocButton.setTitle("Удалить файл", for: .normal)
                    self?.loadDocButton.backgroundColor = .systemRed
                    if self?.role == 1 {
                        self?.delegateTaskButton.isHidden = true
                    }
                    self?.documentViewButton.isHidden = false
                    self?.documentViewButton.setTitle(fileName, for: .normal)
                    
                }
                
            }
        }
        
        
        
        
        
    }
    
    
    
}
