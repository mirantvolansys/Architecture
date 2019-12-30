//
//  UserListCell.swift
//  MVVM_Architecture
//
//  Created by Shrenik on 31/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(forUser userObj: User) {
        // Set First Name + Last Name
        if let fName = userObj.firstName, let lName = userObj.lastName {
            self.lblUserName.text = fName + " " + lName
        }

        //set user avatar
        self.imgUserAvatar.download(imageFromURL: URL(string: userObj.avatar ?? "")!, contentMode: .scaleToFill, placeHolderImage: UIImage(named: "userPlaceholder") ) { (image) in
            DispatchQueue.main.async(execute: {
                self.imgUserAvatar.image = image
            })
        }

        // Set Email Address
        self.lblEmailAddress.text = userObj.emailAddress!
    }
}
