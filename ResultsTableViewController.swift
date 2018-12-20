//
//  ResultsTableViewController.swift
//  AlcCalc
//
//  Created by Andrew Regan on 29/5/17.
//  Copyright © 2017 Andrew Regan. All rights reserved.
//

import UIKit
import os.log

class ResultsTableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var addButton: UIBarButtonItem!
    var results = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved results, otherwise load sample data.
        if let savedResults = loadResults() {
            results += savedResults
        }
        else {
            // Load the sample data.
            loadSampleResults()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ResultsTableViewCell"
        
        guard let resultCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ResultsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ResultsTableViewCell.")
        }
        
        // Fetches the appropriate result for the data source layout.
        let result = results[indexPath.row]
        
        resultCell.drinkNameLabel.text = result.drinkName
        resultCell.alcCalcResultLabel.text = String(result.alcCalcResult)
        
        return resultCell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            results.remove(at: indexPath.row)
            saveResults()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            if #available(iOS 10.0, *) {
                os_log("Adding a new result.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            
        case "ShowDetails":
            guard let resultDetailViewController = segue.destination as? EntryFormViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedResultCell = sender as? ResultsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedResultCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedResult = results[indexPath.row]
            resultDetailViewController.result = selectedResult
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToResultList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EntryFormViewController, let result = sourceViewController.result {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing result.
                results[selectedIndexPath.row] = result
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new result.
                let newIndexPath = IndexPath(row: results.count, section: 0)
                
                results.append(result)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the results.
            saveResults()
        }
        
    }
    
    //MARK: Private Methods
    
    private func loadSampleResults() {
        
        guard let result1 = Result(drinkName: "Carlton Draught", drinkNumber: 6, drinkAlcoholContent: 4.5, drinkVolume: 375, drinkPrice: 20.00, alcCalcResult: 2.5) else {
            fatalError("Unable to instantiate result1")
        }
        
        guard let result2 = Result(drinkName: "VB", drinkNumber: 6, drinkAlcoholContent: 4.5, drinkVolume: 375, drinkPrice: 25.00, alcCalcResult: 2.5) else {
            fatalError("Unable to instantiate result2")
        }
        
        guard let result3 = Result(drinkName: "Shit bottle of wine", drinkNumber: 1, drinkAlcoholContent: 12, drinkVolume: 800, drinkPrice: 15.00, alcCalcResult: 2.5) else {
            fatalError("Unable to instantiate result3")
        }
        
        
        results += [result1, result2, result3]
    }
    
    private func saveResults() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(results, toFile: Result.ArchiveURL.path)
        if isSuccessfulSave {
            if #available(iOS 10.0, *) {
                os_log("Result successfully saved", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 10.0, *) {
                os_log("Failed to save results...", log: OSLog.default, type: .error)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func loadResults() -> [Result]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Result.ArchiveURL.path) as? [Result]
    }
    
    func input() -> String {
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        return NSString(data: inputData, encoding:String.Encoding.utf8.rawValue)! as String
    }
    
}
