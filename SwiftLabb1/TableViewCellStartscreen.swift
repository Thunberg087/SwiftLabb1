//
//  TableViewCellStartscreen.swift
//  SwiftLabb1
//
//  Created by Jonathan Thunberg on 2020-02-03.
//  Copyright © 2020 Jonathan Thunberg. All rights reserved.
//

import UIKit

class TableViewCellStartscreen: UITableViewCell {
    
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
