//
//  MenuItemsVC.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit

protocol BackDataToRetDetails {
    func backDataToDetilsReload(index1:Int)
}

class MenuItemsVC: UIViewController {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblAddOns: UITableView!
    
    
    //MARK: - Variables
    internal var previousOffset: CGFloat = 0
    var protObj:BackDataToRetDetails?
    
    var categoryDataModelArray = [CategoryDataModel]()
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    //MARK: - View Life Cycle Methods
    //TODO: View didLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initialStup()
        
        categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "7", name: "Most Popular", isSelected: true, index: 0))
        categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "11", name: "Main Course", isSelected: false, index: 1))
        categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "6", name: "Pizza", isSelected: false, index: 2))
        categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "12", name: "Burger", isSelected: false, index: 3))
        categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "18", name: "Drinks", isSelected: true, index: 0))
        categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "8", name: "Dessert", isSelected: false, index: 1))
        categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "9", name: "Snacks", isSelected: false, index: 2))
       
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
    }
    
    //TODO: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Actions,Gesture
    //TODO: Save Actions
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Drag dismiss function
    //TODO:
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            
            viewTranslation = sender.translation(in: view)
            if viewTranslation.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            }
        case .ended:
            if viewTranslation.y < 100 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
}
