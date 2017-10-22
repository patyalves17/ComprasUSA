//
//  CompraViewController.swift
//  AlexandrePatricia
//
//  Created by ABC Education on 18/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit
import CoreData

class CompraViewController: UIViewController {

    @IBOutlet weak var tfnomeProduct: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfEstado: UITextField!
    @IBOutlet weak var tfValor: UITextField!
    @IBOutlet weak var swCartao: UISwitch!
    @IBOutlet weak var btCadastrar: RoundedButton!
    
    var produto: Product!
    var smallImage: UIImage!
    var estados:[State] = []
    var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carregaEstados()
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        tfEstado.inputView = pickerView
        tfEstado.inputAccessoryView = toolbar
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage(tapGestureRecognizer:)))
        ivImage.isUserInteractionEnabled = true
        ivImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        if produto != nil {
            tfnomeProduct.text = produto.nome
            tfValor.text = "\(produto.valor)"
            tfEstado.text = produto.estado?.nome
            swCartao.setOn(produto.cartao, animated: false)
            if let image = produto.imagem as? UIImage {
                ivImage.image = image
            }
        }

    }
    
    func cancel() {
        tfEstado.resignFirstResponder()
    }
    
    func done() {
        tfEstado.text = estados[pickerView.selectedRow(inComponent: 0)].nome
        cancel()
    }
    
    func carregaEstados (){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            estados = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
    }

    @IBAction func addImage(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func adicionaProduto(_ sender: Any) {
        
        print(estados[pickerView.selectedRow(inComponent: 0)])
        
        if produto == nil {
            produto = Product(context: context)
        }
        
//        guard let name = tfnomeProduct.text else {
//            print("No name to submit")
////            show("No name to submit", sender: <#Any?#>)
//            return
//        }
        
        guard tfnomeProduct.text?.isEmpty == false else {
            print("No name to submit")
            alertaCampos(campo: "Nome do produto")
            return
        }
        
        guard tfValor.text?.isEmpty == false else {
            print("No tfValor to submit")
            alertaCampos(campo: "Valor do produto")
            return
        }
        
        
        salvar()
       
    }
    
    func alertaCampos(campo: String){
        let alert = UIAlertView(title: "",
                                message: "Preencha o campo \(campo)", delegate: nil, cancelButtonTitle: "Ok")
        alert.delegate = self
        alert.show()
    }
    
    func salvar(){
        produto.nome = tfnomeProduct.text!
        produto.estado=estados[pickerView.selectedRow(inComponent: 0)]
        produto.valor = Float(tfValor.text!)!
        produto.cartao = swCartao.isOn
        if smallImage != nil {
            produto.imagem = smallImage
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
        
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
extension CompraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        let smallSize = CGSize(width: 240 , height: 128)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivImage.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}


extension CompraViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Retornando o texto recuperado do objeto dataSource, baseado na linha selecionada
        return estados[row].nome
    }
}

extension CompraViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return estados.count
    }
}
