//
//  SettingsViewController.swift
//  AlexandrePatricia
//
//  Created by ABC Education on 13/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit
import CoreData

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
    
    @IBAction func addEstado(_ sender: UIButton) {
        let myalert = UIAlertController(title: "Adicionar Estado", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        myalert.addTextField { (textField) in
            textField.placeholder = "Nome do estado"
        }
        myalert.addTextField { (textField) in
             textField.keyboardType = .decimalPad
            textField.placeholder = "imposto"
        }
        
        myalert.addAction(UIAlertAction(title: "Adicionar", style: .default) { (action:UIAlertAction!) in
            print("Selected")
             let nome = myalert.textFields?[0].text
            let imposto = myalert.textFields?[1].text
            
            if nome != "" && imposto != "" {
                print ("\(nome)")
                print ("\(imposto)")
                let state = State(context: self.context)
                state.nome = nome!
                state.imposto = Float(imposto!)!
                
                do {
                    try self.context.save()
                } catch {
                    print(error.localizedDescription)
                }
               
            }
            
        })
        myalert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel")
        })
        
        self.present(myalert, animated: true)
     

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
