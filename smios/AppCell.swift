//
//  AppCell.swift
//  smios
//
//  Created by Fhict on 08/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import Foundation
import UIKit

class AppCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var appCategory: AppCategory? {
        didSet {
            
            if let name = appCategory?.name {
                nameLabel.text = name
            }
            
        }
    }
    
    var app: App? {
        didSet {
            if let name = app?.name {
                nameLabel.text = name
            }
            
            categoryLabel.text = app?.category
            
            if let price = app?.price {
                priceLabel.text = "$\(price)"
            } else {
                priceLabel.text = ""
            }
            
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "defqonNew")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Defqon"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Hardstyle"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "12:00"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect(x: 0, y: frame.width+2, width: frame.width, height: 40)
        categoryLabel.frame = CGRect(x: 0, y: frame.width+38, width: frame.width, height: 20)
        priceLabel.frame = CGRect(x: 0, y: frame.width+56, width: frame.width, height: 20)
    }
    
}
