//
//  TableViewController.swift
//  SkyRoads
//
//  Created by dharay mistry on 03/11/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import UIKit
import RxSwift

class TableViewController: UITableViewController {
    let visibleScore = Observable.from(Const.CDscores)
    let sorterManager = SorterManager()
    let dateManager = DateManager()
    override func viewDidLoad() {
        super.viewDidLoad()

		
		Const.highScores.sort{$0>$1}
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
         tableView.register(MyCustomHeader.self,
              forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
  
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//        view.backgroundColor = .cyan
//
        let sorter = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        sorter.dataSource = self.sorterManager
        sorter.delegate = self.sorterManager
        sorter.backgroundColor = .red
        let stack = UIStackView(arrangedSubviews: [sorter])
        stack.backgroundColor = .orange
//        view.addSubview(stack)
//        stack.frame = tableView.headerView(forSection: section)!.frame
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
        "sectionHeader") as! MyCustomHeader
        view.stack.addArrangedSubview(sorter)
        view.backgroundColor = .cyan
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 30
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text="5"
        cell.detailTextLabel?.text = Const.CDscores[indexPath.row].date.description
        // Configure the cell...

        return cell
    }


 
}
class SorterManager: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 1 ? "sort by date" : "sort by value"
    }
    
    
}
class DateManager: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return 2
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return row == 1 ? "sort by date" : "sort by value"
       }
    
    
}

class MyCustomHeader: UITableViewHeaderFooterView {
    var stack = UIStackView()
//    let image = UIImageView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .red

        contentView.addSubview(stack)
        

        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
//            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor),
            stack.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        

        ])
    }
}
