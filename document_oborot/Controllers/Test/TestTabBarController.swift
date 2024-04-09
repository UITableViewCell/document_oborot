//
//  TestTabBarViewController.swift
//  document_oborot
//
//  Created by 123 on 08.04.2024.
//

import UIKit

class TestTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let nav1 = UINavigationController(rootViewController: DirectorViewController())
        let nav2 = UINavigationController(rootViewController: HeadOfDepartmentViewController())
        let nav3 = UINavigationController(rootViewController: DepartmentWorkerViewController())
        
        viewControllers = [nav1, nav2, nav3]
        
        
    }
    

   

}
