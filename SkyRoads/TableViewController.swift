//
//  TableViewController.swift
//  SkyRoads
//
//  Created by dharay mistry on 03/11/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import Foundation

class TableViewController: UITableViewController {
    let visibleScore: BehaviorRelay<[HS]> = BehaviorRelay(value: [])//= Observable.from(Const.CDscores)
    private let disposeBag = DisposeBag()
    let sorterManager = SorterManager()
    let dateManager = DateManager()
//    var visibleScoreData = "A"
    let sorter = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
    let datePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
    override func viewDidLoad() {
        super.viewDidLoad()
        //  row == 0 ? "Show All time" : "Show today"
        //  row == 0 ? "Sort by value" : "Sort by date"
        

        sorterManager.closure = {(row) in
//            let sortRow = self.sorter.selectedRow(inComponent: 0)
            if row == 0 {
                self.visibleScore.accept(self.visibleScore.value.sorted(by: {$0.hscore > $1.hscore}))
                
            } else {
                self.visibleScore.accept(self.visibleScore.value.sorted(by: {$0.date > $1.date}))
            }
            
        }
        dateManager.closure = {(row) in
            let sortRow = self.sorter.selectedRow(inComponent: 0)
            if row == 0 {
                self.visibleScore.accept(Const.CDscores)
                
            } else {
                self.visibleScore.accept(self.visibleScore.value.filter({ Calendar.current.isDateInToday($0.date) }))
            }
            self.sorterManager.closure(sortRow)
            
        }
        
        visibleScore.asObservable()
        .subscribe(onNext: { //2
          [unowned self] value in
            print(value)
            self.tableView.reloadData()
        })
        .disposed(by: disposeBag) //3
        dateManager.closure(0)
        
//		Const.highScores.sort{$0>$1}
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

        
        sorter.dataSource = self.sorterManager
        sorter.delegate = self.sorterManager
        sorter.backgroundColor = .red
//        let stack = UIStackView(arrangedSubviews: [sorter])
//        stack.backgroundColor = .orange

 
        datePicker.dataSource = self.dateManager
        datePicker.delegate = self.dateManager
        datePicker.backgroundColor = .orange
//        let stack = UIStackView(arrangedSubviews: [sorter,datePicker])
//        stack.backgroundColor = .orange
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
        "sectionHeader") as! MyCustomHeader
        view.stack.addArrangedSubview(sorter)
        view.stack.addArrangedSubview(datePicker)
        
        view.backgroundColor = .cyan
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return visibleScore.value.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = visibleScore.value[indexPath.row].hscore.description
        cell.detailTextLabel?.text = visibleScore.value[indexPath.row].date.description.dropLast(5).description
        // Configure the cell...

        return cell
    }


 
}
class SorterManager: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var closure: (Int) -> Void = {_ in }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "Sort by value" : "Sort by date"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        closure(row)
    }
    
    
}
class DateManager: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var closure: (Int) -> Void = {_ in }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "Show All time" : "Show today"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        closure(row)
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
        stack.backgroundColor = .green
        stack.distribution = .fillEqually
        stack.axis = .vertical
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
