//
//  TaskCell.swift
//  Doit
//
//  Created by Vitalii Kryvoshapka on 18.11.2021.
//

import UIKit

class TaskCell: UITableViewCell {

    //MARK: - OUTLETS -
    
    @IBOutlet weak var symbol: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
