//
//  eventDetailController.swift
//  smios
//
//  Created by Fhict on 12/12/16.
//  Copyright © 2016 Fhict. All rights reserved.
//

import UIKit

class EventDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // om te zien welke title meegegeven wordt in de volgende view
    var event: Event?{
        didSet{
            navigationItem.title = event?.name
        }
    }

    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(EventDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
//            let segmentedControl: UISegmentedControl = {
//                let sc = UISegmentedControl(items: ["Info", "Discussie"])
//                sc.selectedSegmentIndex = 0
//                sc.tintColor = UIColor.purple
//                return sc
//            }()
//        
//        self.view.addSubview(segmentedControl)

    }
    

    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EventDetailHeader
        header.event = event
        return header
        
    }
    
    // de size van de header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    

}


// wat er in de header komt
class EventDetailHeader: BaseCell{
    
    var event: Event?{
        didSet{
            if let imageName = event?.image{
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        //imageView.center = imageView.center
        return iv
    }()

    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha:0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()

        addSubview(imageView)
        imageView.backgroundColor = UIColor.red
        addSubview(dividerLineView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        

        // constraints voor imageView (header)
        addContrainsWithFormat(format: "H:|[v0(350)]", views: imageView)
        addContrainsWithFormat(format: "V:|[v0(150)]", views: imageView)
        
        //constraints voor dividerline(full view width)
        addContrainsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addContrainsWithFormat(format: "V:|-170-[v0(0.5)]|", views: dividerLineView)

    }
}






extension UIView {
    func addContrainsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints =  false
        }
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
    }
}
