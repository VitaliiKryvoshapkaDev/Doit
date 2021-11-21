//
//  TaskTypeController.swift
//  Doit
//
//  Created by Vitalii Kryvoshapka on 21.11.2021.
//

import UIKit

class TaskTypeController: UITableViewController {
    
    //MARK: - Use xib cell -
    //1. Tuple show type of task
    typealias TypeCellDescription = (type: TaskPriority, title: String, description: String)
    
    //2. Collection of use type of task
    private var taskTypesInformation: [TypeCellDescription] = [
        (type: .important, title: "Важная", description: "Такой тип задач является наиболее приоритетным для выполнения. Все важные задачи выводятся в самом верху списка задач"),
        (type: .normal, title: "Текущая", description: "Задача с обычным приоритетом")
    ]
    //3. Select Priority
    var selectedType: TaskPriority = .normal
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: REGISTER Xib
        //Register Xib Cell
        //1. Get UINib type
        let cellTypeNib = UINib(nibName: "TaskTypeCell", bundle: nil)
        //2. Register castom cell in tableView
        tableView.register(cellTypeNib, forCellReuseIdentifier: "TaskTypeCell")
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskTypesInformation.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. Get reusable castom cell with ID
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTypeCell", for: indexPath) as! TaskTypeCell
        //2. Get current element, what show in row
        let typeDescription = taskTypesInformation[indexPath.row]
        //3. Add data to cell
        cell.typeTitle.text = typeDescription.title
        cell.typeDescription.text = typeDescription.description
        //4. If type selected, mark them
        if selectedType == typeDescription.type{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: - Transfer data betwen controllers -
    // обработчик Select Type
    var doAfterTypeSelected: ((TaskPriority) -> Void)?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get need type
        let selectedType = taskTypesInformation[indexPath.row].type
        // Cll обработчиk
        doAfterTypeSelected?(selectedType)
        // Move to previous screen
        navigationController?.popViewController(animated: true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}