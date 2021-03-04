//
//  MainTabBarController.swift
//  GoLocal
//
//  Created by C100-104on 27/12/20.
//

import UIKit

class MainTabBarController: UITabBarController {

    var currentRole : UserRole = .Owner
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()       
    }
    
    func setupUI() {
        addAboveShadow()
        
        switch currentRole {
        case .Owner:
            self.BussinessOwnerTabSetUp()
            break
            
        case .Employee:
            break
        }
    }
    
    func BussinessOwnerTabSetUp(){
        let orderRequestVc = OrderRequestViewController(nibName: "OrderRequestViewController", bundle: .main)
        let orderListVc = OrderViewController(nibName: "OrderViewController", bundle: .main)
//        let categoryListVc = CategoryListViewController(nibName: "CategoryListViewController", bundle: .main)
        let driversVc = DriversListViewController(nibName: "DriversListViewController", bundle: .main)
        let profileVc = ProfileViewController(nibName: "ProfileViewController", bundle: .main)
        
        orderRequestVc.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 0)
        orderListVc.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 1)
//        categoryListVc.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        driversVc.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 3)
        profileVc.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 4)

        viewControllers?.removeAll()
        viewControllers = [orderRequestVc,orderListVc,driversVc,profileVc]

        let selectedColor = GreenColor
       // tabBar.tintColor = .none
        tabBarItem.badgeColor = selectedColor


        let tabImages: [[UIImage]] = [
            [
               #imageLiteral(resourceName: "order_req_icon"),
               #imageLiteral(resourceName: "order_icon"),
//               #imageLiteral(resourceName: "product_icon"),
               #imageLiteral(resourceName: "driver_icon"),
                #imageLiteral(resourceName: "profile_icon")
            ],
            [
               #imageLiteral(resourceName: "order_req_icon_en"),
                #imageLiteral(resourceName: "order_icon_en"),
//                #imageLiteral(resourceName: "product_icon_en"),
                #imageLiteral(resourceName: "driver_icon_en"),
                #imageLiteral(resourceName: "profile_icon_en")
            ]
        ]
        var index = 0
        for item in tabBar.items! {
            item.image = tabImages[0][index]
            item.selectedImage = tabImages[1][index]
            item.imageInsets = UIEdgeInsets(top: HAS_TOP_NOTCH ? 10 : 5, left: 0, bottom: HAS_TOP_NOTCH ? -15 : -5, right: 0)
            index += 1
        }
        tabBar.backgroundColor = .white
    }
    
    //Add Shadow
    func addAboveShadow()
    {
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.tabBar.layer.shadowRadius = 10
        self.tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        self.tabBar.layer.shadowOpacity = 0.3
    }
    
    // add viewcontroller to tab bar
    func addToTabBar(_ vc: UIViewController) {
        /*
         let navvc = UINavigationController(rootViewController: vc)
         navvc.navigationBar.isHidden = true
         //navvc.setNavigationBarHidden(true, animated: false)
         navvc.navigationBar.barStyle = UIBarStyle.blackOpaque
         */
        viewControllers?.append(vc)
    }

}
