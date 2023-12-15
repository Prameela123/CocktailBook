//
//  MainScreenViewController.swift
//  CocktailBook
//
//  Created by Prameela Akkinapalli on 12/12/23.
//  Copyright © 2023 Prameela Akkinapalli. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavChanged {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var segmentIndex = 0
    var isFavorite: [String: Bool] = [:]
    private let cocktailsAPI = FakeCocktailsAPI()
    
    var items: [NSDictionary] = []
    var alcoholicItems: [NSDictionary] = []
    var nonAlcoholicItems: [NSDictionary] = []
    var favItems: [NSDictionary] = []
    var nonfavItems: [NSDictionary] = []
    
    let img = UIImage(systemName: "heart")
    let img1 = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        titleLabel.text = "All Cocktails"
        cocktailsAPI.fetchAllDrinks { result in
            if case let .success(data) = result {
                self.items = data
                self.items = self.sortDict(dictArr: self.items)
                for item in self.items {
                    let str = item["name"] as! String
                    self.isFavorite[str] = false
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        for item in cocktailsAPI.items {
            if item["type"] as? String == "alcoholic" {
                alcoholicItems.append(item)
                alcoholicItems = sortDict(dictArr: alcoholicItems)
            } else if item["type"]as? String == "non-alcoholic" {
                nonAlcoholicItems.append(item)
                nonAlcoholicItems = sortDict(dictArr: nonAlcoholicItems)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailsVC = segue.destination as! DetailScreenViewController
        let selectedRow = tableView.indexPathForSelectedRow!.row
        var data = items
        if segmentIndex == 1 {
            data = alcoholicItems
        } else if segmentIndex == 2 {
            data = nonAlcoholicItems
        }
        detailsVC.favDelegate = self
        detailsVC.itemTitle = data[selectedRow]["name"] as? String
        detailsVC.time = data[selectedRow]["preparationMinutes"] as? Int
        let imgName = (data[selectedRow]["imageName"] as? String)!
        let imge = UIImage(named: imgName)
        detailsVC.image = imge
        detailsVC.desc = data[selectedRow]["longDescription"] as? String
        detailsVC.ing = data[selectedRow]["ingredients"] as? [String]
        if isFavorite[detailsVC.itemTitle] == true {
            detailsVC.heartImage = img1
        } else {
            detailsVC.heartImage = img
        }
        let backItem = UIBarButtonItem()
        backItem.title = titleLabel.text
        backItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backItem
    }

    // MARK: - Sort array of dictionaries
      
      func sortDict(dictArr: [NSDictionary]) -> [NSDictionary] {
          var res: [NSDictionary] = []
          res = dictArr.sorted(by: { (Obj1, Obj2) -> Bool in
              let Obj1_Name = Obj1["name"] as! String
              let Obj2_Name = Obj2["name"] as! String
              return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
          })
          return res
      }
    
    
    // MARK: - Segment control action method
    
    @IBAction func segmentControllClick(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            titleLabel.text = "All Cocktails"
            segmentIndex = 0
            tableView.reloadData()
        case 1 :
            titleLabel.text = "Alcoholic Cocktails"
            segmentIndex = 1
            tableView.reloadData()
        case 2:
            titleLabel.text = "Non-Alcoholic Cocktails"
            segmentIndex = 2
            tableView.reloadData()
        default:
            break
        }
    }
    
    // MARK: - Favorite icon action method
    
    @objc func favBtnAction(sender: UIButton) {
        rearrangeItemsData(str: "", sender: sender)
    }
    
    // MARK: - Getting data back from Details VC
    
    func getDataFromDetailsVC(isFav: Bool, name: String) {
           isFavorite[name] = isFav
           rearrangeItemsData(str: name, sender: UIButton())
    }
    
    
    func rearrangeItemsData(str: String, sender: UIButton) {
        
        var dicts = items
        nonfavItems = dicts.filter({!favItems.contains($0)})
        if segmentIndex == 1 {
            dicts = alcoholicItems
        } else if segmentIndex == 2 {
            dicts = nonAlcoholicItems
        }
        var movedObject : NSDictionary = [:]
        var x = str
        if sender.imageView?.image == nil {
             movedObject = dicts.filter({($0["name"] as! String) == str}).first!
        } else {
            x = dicts[sender.tag]["name"] as! String
            isFavorite[x] = isFavorite[x] == false ? true : false
            movedObject = dicts[sender.tag]
        }
        
        if isFavorite[x] == true {
            favItems.append(movedObject)
            nonfavItems = nonfavItems.filter({($0["name"] as! String) != (movedObject["name"]as! String)})
            favItems = sortDict(dictArr: favItems)

        } else {
            nonfavItems.append(movedObject)
            favItems = favItems.filter({($0["name"] as! String) != (movedObject["name"]as! String)})
            nonfavItems = sortDict(dictArr: nonfavItems)
        }
        
        items = favItems + nonfavItems
        let alfavItems = favItems.filter({($0["type"] as! String) == "alcoholic"})
        let alnonfavItems = nonfavItems.filter({($0["type"] as! String) == "alcoholic"})
        alcoholicItems = alfavItems + alnonfavItems
        let nonAlfavItems = favItems.filter({($0["type"] as! String) == "non-alcoholic"})
        let nonAlnonfavItems = nonfavItems.filter({($0["type"] as! String) == "non-alcoholic"})
        nonAlcoholicItems = nonAlfavItems + nonAlnonfavItems
        
        tableView.reloadData()
    }
        
}


extension MainScreenViewController {
    
    // MARK: - Table view delegate methods

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           var count = cocktailsAPI.items.count
           if segmentIndex == 1 {
               count = alcoholicItems.count
           } else if segmentIndex == 2 {
               count = nonAlcoholicItems.count
           }
           return count
       }

       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? ListTableViewCell
           var dict = items[indexPath.row]
           if segmentIndex == 1 {
               dict = alcoholicItems[indexPath.row]
           } else if segmentIndex == 2 {
               dict = nonAlcoholicItems[indexPath.row]
           }
           cell?.name.text = dict["name"] as? String
           cell?.shortDesc.text = dict["shortDescription"] as? String
           cell?.favButton.tag = indexPath.row
           cell?.favButton.addTarget(self, action: #selector(favBtnAction(sender:)), for: .touchUpInside)
           if favItems.contains(dict) {
               cell?.name.textColor = UIColor.purple
               cell?.favButton.setImage(img1, for: .normal)
           } else {
               cell?.name.textColor = UIColor.black
               cell?.favButton.setImage(img, for: .normal)
           }
           return cell!
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           self.performSegue(withIdentifier: "ViewToDetails", sender: self)

       }
       
       func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
           true
       }
           
}
