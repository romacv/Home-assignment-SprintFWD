//
//  UIImageView.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 4/7/2022.
//
import UIKit

extension UIImageView {
    func setImage(_ urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: URL(string: urlString)!)
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }
    }
}
