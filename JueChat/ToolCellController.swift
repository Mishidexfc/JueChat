//
//  ToolCellController.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/6.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit
class ToolCellController:UITableViewCell{
    @IBOutlet weak var ToolTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
