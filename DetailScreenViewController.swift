//
//  DetailScreenViewController.swift
//  CocktailBook
//
//  Created by Prameela Akkinapalli on 13/12/23.
//  Copyright © 2023 Prameela Akkinapalli. All rights reserved.
//

import UIKit

protocol FavChanged {
    func getDataFromDetailsVC(isFav: Bool, name: String)
}

class DetailScreenViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var descView: UITextView!
    @IBOutlet weak var IngredientsView: UITextView!
    @IBOutlet weak var heartIcon: UIBarButtonItem!
    
    var itemTitle: String!
    var time: Int!
    var image: UIImage!
    var desc: String!
    var ing: [String]!
    var heartImage: UIImage!
    
    var mainScreenVC: MainScreenViewController?
    var isFavorite = false
    
    var favDelegate: FavChanged?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = itemTitle
        minutesLabel.text = String(time)
        itemImageView.image = image
        descView.text = desc
        descView.isEditable = false
        let ingstr = "▸ " + ing.joined(separator: "\n▸ ")
        IngredientsView.text = ingstr
        IngredientsView.isEditable = false
        heartIcon.image = heartImage
        if heartImage.description.contains("fill") {
            isFavorite = true
        } else {
            isFavorite = false
        }
    }

    // MARK: - Favorite icon action method
    
    @IBAction func favIconAction(_ sender: UIButton) {
        isFavorite = isFavorite == true ? false : true
        if isFavorite {
            heartIcon.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        } else {
            heartIcon.image = UIImage(systemName: "heart")
        }
        // Passing data to Main screen
        self.favDelegate?.getDataFromDetailsVC(isFav: isFavorite, name: itemTitle)
    }
}
