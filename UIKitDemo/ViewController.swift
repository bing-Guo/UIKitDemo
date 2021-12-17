//
//  ViewController.swift
//  UIKitDemo
//
//  Created by Bing Kuo on 2021/12/17.
//

import UIKit

class ViewController: UIViewController {
    lazy var collectionViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go to CollectionView Demo", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(collectionViewButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Setup UI
extension ViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionViewButton)
        
        NSLayoutConstraint.activate([
            collectionViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionViewButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionViewButton.widthAnchor.constraint(equalToConstant: 300),
            collectionViewButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - Actions
extension ViewController {
    @objc func collectionViewButtonTapped(_ sender: UIButton) {
        let viewController = DemoCollectionViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
