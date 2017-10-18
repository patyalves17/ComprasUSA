//
//  TotalViewController.swift
//  AlexandrePatricia
//
//  Created by ABC Education on 18/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet weak var tfDolar: UILabel!
    @IBOutlet weak var tfReal: UILabel!
    
    var fetchedProductsController: NSFetchedResultsController<Product>!
    var produtos: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carregaProdutos()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carregaProdutos() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedProductsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedProductsController.delegate = self
        do {
            try fetchedProductsController.performFetch()
            self.produtos = fetchedProductsController.fetchedObjects!
            calcula()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func calcula(){
        let cotacaoDolar = Float(UserDefaults.standard.string(forKey: "cotacaoDolar") ?? "0")!
        
        let iofTaxa = Float(UserDefaults.standard.string(forKey: "iof") ?? "0")!
        
        var dolars: Float = 0.0
        var reais: Float = 0.0
        
        print("cotacaoDolar: \(cotacaoDolar)")
        print("iofTaxa: \(iofTaxa)")
        
        for produto in produtos {
             dolars += produto.valor
            let prodReais = produto.valor * cotacaoDolar
            
            var prodIof:Double = 0
            let prodImposto = (prodReais * (produto.estado?.imposto)!) / 100
            
            if produto.cartao {
                prodIof = Double((prodReais * iofTaxa) / 100)
            }
            
            reais += prodReais + Float(prodIof) + prodImposto
            
        }
        
        tfDolar.text = String(format: "%.2f", dolars)
        tfReal.text = String(format: "%.2f", reais)
    }
    

}
extension TotalViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        produtos = fetchedProductsController.fetchedObjects!
        calcula()
    }
}
