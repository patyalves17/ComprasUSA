//
//  SettingsViewController.swift
//  AlexandrePatricia
//
//  Created by ABC Education on 13/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit
import CoreData

enum CategoryType {
    case add
    case edit
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tfCotacaoDolar: UITextField!
    @IBOutlet weak var tfIof: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var appDefaults: UserDefaults!
    var estados: [State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDefaults = UserDefaults.standard
        tableView.dataSource = self
        tableView.delegate = self
        carregaEstados()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appSettingsBundle()
    }
    
    @IBAction func editCotacaoDolar(_ sender: Any) {
        appDefaults.set(tfCotacaoDolar.text!, forKey: "cotacaoDolar")
    }
    
    @IBAction func editIof(_ sender: Any) {
         appDefaults.set(tfIof.text!, forKey: "iof")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appSettingsBundle(){
        
        tfCotacaoDolar.text = appDefaults.string(forKey: "cotacaoDolar")
        tfIof.text = appDefaults.string(forKey: "iof")
    }
    
    @IBAction func addEstado(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }
    
    func showAlert(type: CategoryType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome da estado"
            if let nome = state?.nome {
                textField.text = nome
            }
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto do estado"
            if let imposto = state?.imposto {
                textField.text = "\(imposto)"
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let state = state ?? State(context: self.context)
            state.nome = alert.textFields?.first?.text
            state.imposto = Float((alert.textFields?.last?.text)!)!
            do {
                try self.context.save()
                self.carregaEstados()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    
    }
    
    func carregaEstados (){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            estados = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
   

}

extension SettingsViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return estados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let state = estados[indexPath.row]
        cell.textLabel?.text = state.nome
        cell.accessoryType = .none
        return cell
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.estados[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.estados.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action:UITableViewRowAction, indexPath: IndexPath) in
            let state = self.estados[indexPath.row]
            tableView.setEditing(false, animated: true)
            self.showAlert(type: .edit, state: state)
            
        }
        editAction.backgroundColor = .green
        
     return [deleteAction, editAction]
    }
    
}




