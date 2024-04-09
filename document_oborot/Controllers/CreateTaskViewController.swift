//
//  TaskViewController.swift
//  document_oborot
//
//  Created by 123 on 06.04.2024.
//

import UIKit

class CreateTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var workers: [String]!
    
    let role: Int!
    
    var task: Order?
    
    private var textLabel: UILabel!
    private var pickerView: UIPickerView!
    private var titleTextView: UITextField!
    
    private var textView: UITextView!
    private var createButton: UIButton!
    
    init(role: Int) {
        self.role = role
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    @objc func hideKeyboard() {
          view.endEditing(true)
      }
    
    private func setup() {
        switch role {
        case 0:
            self.workers = ["Глава Отдела", "Специалист отдела"]
        case 1:
            self.workers = ["Специалист отдела"]
        default: return
        }


    }
    
    private func setupUI() {
        
        
        textLabel = UILabel()
        textLabel.text = "Исполнитель"
        textLabel.textAlignment = .center
        textLabel.frame = CGRect(x: 20, y: 40, width: view.frame.width - 40, height: 40)
        view.addSubview(textLabel)
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.showsLargeContentViewer = false
        pickerView.dataSource = self
        pickerView.frame = CGRect(x: 20, y: 50, width: view.frame.width-40, height: 150)
        view.addSubview(pickerView)
        
        
        titleTextView = UITextField()
        titleTextView.placeholder = "Тема"
        titleTextView.backgroundColor = .secondarySystemBackground
        titleTextView.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 40)
        view.addSubview(titleTextView)
        
        
        
        
        
        textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.frame = CGRect(x: 20, y: 250, width: view.frame.width - 40, height: 400)
        view.addSubview(textView)
        
        
        createButton = UIButton(type: .system)
        createButton.setTitle("Создать", for: .normal)
        createButton.backgroundColor = .green
        createButton.layer.cornerRadius = 20
        createButton.frame = CGRect(x: 20, y: view.frame.maxY - 150, width: view.frame.width - 40, height: 40)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        view.addSubview(createButton)
    }
    
    
    func configure(with task: Order) {
        self.task = task
        titleTextView.text = task.name
        textView.text = task.text
    }
    
    // MARK: - UIPickerView Delegate & DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workers[row]
    }
    
    
    // MARK: - Actions
    
    @objc private func createButtonTapped() {
        
        let creator = role!
        let implementer = pickerView.selectedRow(inComponent: 0) + 1 + role
        let name = titleTextView.text ?? ""
        let text = textView.text ?? ""
        
        print(implementer)
        print(name )
        print(text )
        var worker = "nil"
        
        if implementer == 2 {
            worker = "Специалист отдела"
        } else if implementer == 1 {
            worker = "Глава Отдела"
        }
        
        
        guard var task = task else {
            FirebaseManager.shared.newTask(task: Order(name: name, text: text, implementer: implementer, creator: creator)) { [weak self] in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Готово", message: "Создано поручение для: \(worker)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                        self?.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                }
                
            }
            
            return
        }
        task.creator += 1
        task.implementer += 1
        task.text = text
        task.name = name
        
        FirebaseManager.shared.newTask(task: task) { [weak self] in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Готово", message: "Создано поручение для: \(worker)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAction)
                self?.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
        
        

        
        // end
        
        
        
    }
    
    
    
    
}
