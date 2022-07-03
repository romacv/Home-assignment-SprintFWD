//
//  DetailsVC.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

import UIKit

class DetailsVC: UIViewController {
    
    let viewModel = DetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Details"
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage.init(named: "share"),
                        style: .plain,
                        target: self,
                        action: #selector(shareTapped))
    }
    
    @objc private func shareTapped() {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
