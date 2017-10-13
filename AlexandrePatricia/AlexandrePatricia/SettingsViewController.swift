//
//  SettingsViewController.swift
//  AlexandrePatricia
//
//  Created by ABC Education on 13/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tfCotacaoDolar: UITextField!
    @IBOutlet weak var tfIof: UITextField!
    var appDefaults: UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appSettingsBundle()
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appSettingsBundle(){
         appDefaults = UserDefaults.standard
        tfCotacaoDolar.text = appDefaults.string(forKey: "cotacaoDolar")
        tfIof.text = appDefaults.string(forKey: "iof")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
