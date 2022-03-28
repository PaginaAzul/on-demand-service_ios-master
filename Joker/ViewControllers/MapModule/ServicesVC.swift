//
//  ServicesVC.swift
//  Joker
//
//  Created by Callsoft on 22/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

protocol ServicesCategoryDelegate {
    
    func selectedCategory(category:String,subCategory:String)
}



import UIKit

class ServicesVC: UIViewController {

    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var sampleTreeView: CITreeView!
    
    @IBOutlet weak var viewBlur: UIView!
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var delegate:ServicesCategoryDelegate?
    
    var tableArr = NSArray()
    var data : [CITreeViewData] = []
    let treeViewCellIdentifier = "TreeViewCellIdentifier"
    let treeViewCellNibName = "CITreeViewCell"
    
    let connection = webservices()
   // var sectionArr = ["Air Conditioner","Screen Audios","Kitchen Appliances","Computer Office Equipements","Home Appliances","Phone and Tablets","Personal Care"]
  //  var rowArr = ["Split","Air Purify","Window"]
    var sectionSelectionArr = NSMutableArray()
    var rowArr = NSArray()
    
    var sectionArr = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.backgroundImage = UIImage()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ServicesVC.handleTap(_:)))
        
        viewBlur.addGestureRecognizer(tap)
        
        viewBlur.isUserInteractionEnabled = true
                
      //  data = CITreeViewData.getDefaultCITreeViewData()
        
        data = initialSetup()
        
        sampleTreeView.collapseNoneSelectedRows = false
        sampleTreeView.register(UINib(nibName: treeViewCellNibName, bundle: nil), forCellReuseIdentifier: treeViewCellIdentifier)
        
        //////
        
        self.sectionSelectionArr.removeAllObjects()
        
        configureTableView()
        
        self.apiCallForGetServices()
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
       
        self.dismiss(animated: true, completion: nil)
    }
    
    func initialSetup() -> [CITreeViewData] {
        
        let subChild121 = CITreeViewData(name: "Albea")
        let subChild122 = CITreeViewData(name: "Egea")
        let subChild123 = CITreeViewData(name: "Linea")
        let subChild124 = CITreeViewData(name: "Siena")

        let child11 = CITreeViewData(name: "Volvo")
        let child12 = CITreeViewData(name: "Fiat", children:[subChild121, subChild122, subChild123, subChild124])
        let child13 = CITreeViewData(name: "Alfa Romeo")
        let child14 = CITreeViewData(name: "Mercedes")
        let parent1 = CITreeViewData(name: "Sedan", children: [child11, child12, child13, child14])

        let subChild221 = CITreeViewData(name: "Discovery")
        let subChild222 = CITreeViewData(name: "Evoque")
        let subChild223 = CITreeViewData(name: "Defender")
        let subChild224 = CITreeViewData(name: "Freelander")

        let child21 = CITreeViewData(name: "GMC")
        let child22 = CITreeViewData(name: "Land Rover" , children: [subChild221,subChild222,subChild223,subChild224])
        let parent2 = CITreeViewData(name: "SUV", children: [child21, child22])

        let child31 = CITreeViewData(name: "Wolkswagen")
        let child32 = CITreeViewData(name: "Toyota")
        let child33 = CITreeViewData(name: "Dodge")
        let parent3 = CITreeViewData(name: "Truck", children: [child31, child32,child33])

        let subChildChild5321 = CITreeViewData(name: "Carrera", children: [child31, child32,child33])
        let subChildChild5322 = CITreeViewData(name: "Carrera 4 GTS")
        let subChildChild5323 = CITreeViewData(name: "Targa 4")
        let subChildChild5324 = CITreeViewData(name: "Turbo S")

        let parent4 = CITreeViewData(name: "Van",children:[subChildChild5321,subChildChild5322,subChildChild5323,subChildChild5324])

        let subChild531 = CITreeViewData(name: "Cayman")
        let subChild532 = CITreeViewData(name: "911",children:[subChildChild5321,subChildChild5322,subChildChild5323,subChildChild5324])

        let child51 = CITreeViewData(name: "Renault")
        let child52 = CITreeViewData(name: "Ferrari")
        let child53 = CITreeViewData(name: "Porshe", children: [subChild531, subChild532])
        let child54 = CITreeViewData(name: "Maserati")
        let child55 = CITreeViewData(name: "Bugatti")
        let parent5 = CITreeViewData(name: "Sports Car",children:[child51,child52,child53,child54,child55])

        return [parent5,parent2,parent1,parent3,parent4]
        
    }
    
    func configureTableView(){
        
        let cellNib = UINib(nibName: "ServicesTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
        tableview.rowHeight = 35
        tableview.tableFooterView = UIView()
        
        self.tableview.backgroundView = nil
        self.tableview.backgroundColor = UIColor.white
        
        tableview.dataSource = self
        tableview.delegate = self
    }

}


extension ServicesVC:CITreeViewDelegate{
    
    func treeViewNode(_ treeViewNode: CITreeViewNode, willExpandAt indexPath: IndexPath) {
        
    }
    
    func treeViewNode(_ treeViewNode: CITreeViewNode, didExpandAt indexPath: IndexPath) {
        
    }
    
    func treeViewNode(_ treeViewNode: CITreeViewNode, willCollapseAt indexPath: IndexPath) {
        
    }
    
    func treeViewNode(_ treeViewNode: CITreeViewNode, didCollapseAt indexPath: IndexPath) {
        
    }
    
    func willExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {}
    
    func didExpandTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {}
    
    func willCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {}
    
    func didCollapseTreeViewNode(treeViewNode: CITreeViewNode, atIndexPath: IndexPath) {}
    
    
    func treeView(_ treeView: CITreeView, heightForRowAt indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> CGFloat {
        return 40
    }
    
    func treeView(_ treeView: CITreeView, didSelectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
        
        
        print(treeViewNode.item)
        print(treeViewNode.level)
        print(indexPath.row)
        
        let dataObj = treeViewNode.item as! CITreeViewData
        let nodeName = dataObj.name
        
        print(nodeName)
        
     
        
    }
    
    func treeView(_ treeView: CITreeView, didDeselectRowAt treeViewNode: CITreeViewNode, atIndexPath indexPath: IndexPath) {
        if let parentNode = treeViewNode.parentNode{
            
            print(parentNode.item)
            
        }
    }
}


extension ServicesVC:CITreeViewDataSource{
    
    func treeViewSelectedNodeChildren(for treeViewNodeItem: AnyObject) -> [AnyObject] {

        if let dataObj = treeViewNodeItem as? CITreeViewData {
            return dataObj.children
        }
        return []
    }
    
    
//    func treeViewSelectedNodeChildren(for treeViewNodeItem: Any) -> [Any] {
//
//        if let dataObj = treeViewNodeItem as? CITreeViewData {
//            return dataObj.children
//        }
//        return []
//    }
    
//    func treeViewDataArray() -> [Any] {
//
//        return data
//    }
    
    func treeViewSelectedNodeChildren(for treeViewNodeItem: Any) -> [AnyObject] {
        if let dataObj = treeViewNodeItem as? CITreeViewData {
            return dataObj.children
        }
        return []
    }
    
    func treeViewDataArray() -> [AnyObject] {
        return data
    }
    
    func treeView(_ treeView: CITreeView, atIndexPath indexPath: IndexPath, withTreeViewNode treeViewNode: CITreeViewNode) -> UITableViewCell {
        
        let cell = treeView.dequeueReusableCell(withIdentifier: treeViewCellIdentifier) as! CITreeViewCell
        let dataObj = treeViewNode.item as! CITreeViewData
        cell.nameLabel.text = dataObj.name
        cell.setupCell(level: treeViewNode.level)
        
        return cell;
    }
    
}


////////tableview integration in place of CI Tree View
extension ServicesVC:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sectionSelectionArr.object(at: section) as? String == "0"{
            
            return 0
        }
        else{
            
            return rowArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServicesTableViewCell
        
       // cell.lblTitle.text = rowArr[indexPath.row]
        
        let dict = rowArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let subCatName = dict.object(forKey: "subCategoryName") as? String ?? ""
        
        cell.lblTitle.text = subCatName
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header:ServicesSectionHeader = Bundle.main.loadNibNamed("ServicesSectionHeader", owner: self, options: nil)!.first! as! ServicesSectionHeader
        
       // header.lblCategory.text = sectionArr[section]
        
        let dict = sectionArr.object(at: section) as? NSDictionary ?? [:]
        
        let categoryName = dict.object(forKey: "categoryName") as? String ?? ""
        
        header.lblCategory.text = categoryName
        
        header.btnSection.tag = section
        header.btnSection.addTarget(self, action: #selector(ServicesVC.tapSectionBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = rowArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let categoryName = dict.object(forKey: "categoryName") as? String ?? ""
        let subCatName = dict.object(forKey: "subCategoryName") as? String ?? ""
        
        self.delegate?.selectedCategory(category: categoryName, subCategory: subCatName)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func tapSectionBtn(sender:UIButton){
        
        let index = sender.tag
        
        if sectionSelectionArr.object(at: index) as? String ?? "" == "0"{
            
            sectionSelectionArr.removeAllObjects()
            
            for _ in 0..<sectionArr.count{
                
                self.sectionSelectionArr.add("0")
            }
            
            sectionSelectionArr.replaceObject(at: index, with: "1")
            
            let dict = sectionArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
            let categoryId = dict.object(forKey: "_id") as? String ?? ""
            
            self.apiCallForGetSubCategoryList(categoryID: categoryId)
        }
        else{
                
            sectionSelectionArr.replaceObject(at: index, with: "0")
        }
            
        self.tableview.reloadData()

    }
    
}


extension ServicesVC{
    
    func apiCallForGetServices(){
        
        IJProgressView.shared.showProgressView(view: self.view)
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetCategory as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let arr = receivedData.object(forKey: "response") as? NSArray{
                            
                            self.sectionArr = arr
                            
                            for _ in 0..<self.sectionArr.count{
                                
                                self.sectionSelectionArr.add("0")
                            }
                            
                            self.tableview.reloadData()
                        }
                    }
                    else{
                        
                        
                    }
                }
                else{
                    
                     CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
              CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
            
        }
        
    }
    
    
    func apiCallForGetSubCategoryList(categoryID:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["categoryId":categoryID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForGetSubCategory as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                print(receivedData)
                
                IJProgressView.shared.hideProgressView()
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let arr = receivedData.object(forKey: "response") as? NSArray{
                            
                            self.rowArr = arr
                            
                            self.tableview.reloadData()
                            
                        }
                        
                       // if sectio
                    }
                    else{
                        
                        
                    }
                }
                else{
                    
                     CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
              CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}


//आप में से अधिकांश साथी परिचित होंगे की आज मेरा अंतिम कार्य दिवस है. मै विगत 3 बर्षो से कंपनी में कार्यरत रहा हूँ और इसके लिए मै आप सभी सह कर्मियों का सादर धन्यबाद करता हूँ।
//मै आभार व्यक्त करता हूँ हमारे सी ई ओ आदरणीय अनिल शर्मा जी, आपने मेरे  भविष्य को एक नयी गति प्रदान की और आपके साथ कार्य करने का सौभाग्य प्राप्त हुआ. मेरे सभी मार्गदर्शक गिरीश नैलवाल जी , अम्बालिका घोष , अमिता शर्मा , प्रशांत चौधरी , प्रियंका भट्ट , राहुल साही मुझे आप सभी की कार्यशैली से कुछ सीखने का अवसर प्राप्त हुआ . आगामी बर्षो में मै कंपनी और सभी सहकर्मियों के उज्जवल भविष्य की कामना करता हूँ .
//
//तरुण राजपूत 
