//
//  CategoryCell.swift
//  smios
//
//  Created by Fhict on 08/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var allEventsController: AllEventsController?
    
    var eventCategory: EventCategory? {
        didSet {
            if let name = eventCategory?.name {
                nameLabel.text = name
            }
        }
    }
    
    var events: [Event]? {
        didSet {
            self.appsCollectionView.reloadData()
        }
    }
    
    private let cellId = "appCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // label voor main genre
    let nameLabel: UILabel = {
        let label = UILabel()
        //label.text = "Hardstyle"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.textAlignment = NSTextAlignment.center;
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // notice we set layout.scrollDirection to horizontal
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        backgroundColor = UIColor.clear
        
        addSubview(appsCollectionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        
        // CONSTRAINTS
        
        // constraint voor name label
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        // constraints voor divider lijn
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(30)][v0][v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView, "v1": dividerLineView, "nameLabel": nameLabel]))
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.events?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // show different events for different items
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! AppCell
        //cell.event = eventCategory?.events?[indexPath.item]
        
        //cell.nameLabel.text = self.events?[indexPath.row].name
        
        cell.event = self.events?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // click on each category cell -> roept showEventDetail methode aan in AllEventsController
        
        if let event = self.events?[indexPath.item]{
            allEventsController?.showEventDetail(event: event)
        }
        
       

        
    }
    
}

class AppCell: UICollectionViewCell {
    
    // name/category/time of event shown
    var event: Event? {
        didSet {
            nameLabel.text = event?.name
            categoryLabel.text = event?.genre
            timeLabel.text = event?.timeStart
            let imageName = event?.image
            imageView.image = UIImage(named: imageName!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        //iv.image = UIImage(named: "defqonNew")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 1
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Defqon"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 11)
        label.textAlignment = NSTextAlignment.center;
        label.numberOfLines = 2
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Hardstyle"
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.center;
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:00"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.center;
        return label
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(timeLabel)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect(x: 0, y: frame.width+2, width: frame.width, height: 20)
        categoryLabel.frame = CGRect(x: 0, y: frame.width+16, width: frame.width, height: 20)
        timeLabel.frame = CGRect(x: 0, y: frame.width+36, width: frame.width, height: 20)
    }
    
}
