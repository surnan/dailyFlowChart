//
//  DailyTaskListCell.swift
//  Daily Flow Chart
//
//  Created by admin on 3/17/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit



class DailyTaskListCell: UITableViewCell {
    
    
    var myTask: Task? {
        didSet {
            myString = (myTask?.name)!
            print("MY STRING = \(myString)")
            
            //name
            nameLabel.text = myTask?.name
            
            //date
            let myDateFormater = DateFormatter()
            myDateFormater.dateFormat = "hh:mm a"
            if let myDate = myTask?.date {
                dateLabel.text = myDateFormater.string(from: myDate)
            }
            
            //image
            if let myImageView = myTask?.picture {
                let imageData = UIImage(data: myImageView)
                iconImageView.image = imageData
            }
        }
    }
    
    var myString = ""
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "COMPANY NOT PROVIDED"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.teal
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "DATE NOT PROVIDED"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.teal
        return label
    }()
    
    let iconImageView : UIImageView = {
        let myImage = UIImageView()
        myImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        myImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return myImage
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.teal
        
        //Can't combine these two into same '.forEach'
        [nameLabel, dateLabel, iconImageView].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        [nameLabel, dateLabel, iconImageView].forEach {addSubview($0)}
        
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

