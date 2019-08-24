//
//  VoiceListVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class VoiceListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        let attrs = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9137254902, green: 0.431372549, blue: 0.1803921569, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = attrs
        tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.9137254902, green: 0.431372549, blue: 0.1803921569, alpha: 1)
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
