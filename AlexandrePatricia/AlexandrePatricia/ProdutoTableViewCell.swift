//
//  ProdutoTableViewCell.swift
//  AlexandrePatricia
//
//  Created by ABC Education on 14/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell {
   
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbValor: UILabel!
    @IBOutlet weak var lbNome: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
