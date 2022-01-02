//
//  HamburgerViewController.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 29/05/1443 AH.
//

import UIKit
protocol HamburgerMenuControllerDelegate {
    func hideHamburgerMenu()
}

class HamburgerViewController: UIViewController {
    var delegate:HamburgerMenuControllerDelegate?
    
    
    
    
    var hamburgerMenuInfo = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpHamburgerUI()
    }
    private func setUpHamburgerUI(){
        
        
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
