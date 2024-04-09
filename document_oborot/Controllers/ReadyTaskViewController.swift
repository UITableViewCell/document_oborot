//
//  ReadyTaskViewController.swift
//  document_oborot
//
//  Created by 123 on 06.04.2024.
//

import UIKit

struct Task {
    let text: String
}

class ReadyTaskViewController: UIViewController {
    
    private var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.frame = CGRect(x: 20, y: 300, width: view.frame.width - 40, height: 400)
        view.addSubview(textView)
    }
    


}
