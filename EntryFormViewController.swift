//
//  EntryFormViewController.swift
//  AlcCalc
//
//  Created by Andrew Regan on 29/5/17.
//  Copyright © 2017 Andrew Regan. All rights reserved.
//

import UIKit
import os.log

class EntryFormViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
//MARK: Outlets

    @IBOutlet weak var calculateButton: UIBarButtonItem!
    
    var alcCalcResult: Double = 0.00

    @IBOutlet weak var drinkNameTextField: UITextField!

    @IBOutlet weak var drinkNumberTextField: UITextField! { didSet {
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 0, height: 44)))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .done, target: self.drinkNumberTextField,
                            action: #selector(resignFirstResponder))
        ]
        drinkNumberTextField?.inputAccessoryView = toolbar
        }}
    
    @IBOutlet weak var drinkVolumeTextField: UITextField! { didSet {
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 0, height: 44)))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .done, target: self.drinkVolumeTextField,
                            action: #selector(resignFirstResponder))
        ]
        drinkVolumeTextField?.inputAccessoryView = toolbar
        }
    }
    
    @IBOutlet weak var alcoholContentTextField: UITextField! { didSet {
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 0, height: 44)))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .done, target: self.alcoholContentTextField,
                            action: #selector(resignFirstResponder))
        ]
        alcoholContentTextField?.inputAccessoryView = toolbar
        }
    }

    @IBOutlet weak var drinkPriceTextField: UITextField! { didSet {
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 0, height: 44)))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .done, target: self.drinkPriceTextField,
                            action: #selector(resignFirstResponder))
        ]
        drinkPriceTextField?.inputAccessoryView = toolbar
        }
    }

    
    /*
     This value is either passed by `ResultsTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new result.
     */
    var result: Result?
    
override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        drinkNameTextField?.delegate = self
    
        
        // Set up views if editing an existing result.
        if let result = result {
            navigationItem.title = "Enter Details"
            drinkNameTextField?.text = result.drinkName
            drinkNumberTextField?.text = String(result.drinkNumber)
            drinkVolumeTextField?.text = String(result.drinkVolume)
            alcoholContentTextField?.text = String(result.drinkAlcoholContent)
            drinkPriceTextField?.text = String(result.drinkPrice)
        }
        
        // Enable the Save button only if the text field has a valid Result name.
        updateSaveButtonState()
    }
    
    
//MARK: UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        calculateButton.isEnabled = true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddResultMode = presentingViewController is UINavigationController
        
        if isPresentingInAddResultMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The EntryFormViewController is not inside a navigation controller.")
        }

    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === calculateButton else {
            if #available(iOS 10.0, *) {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return
        }
        
        let drinkName = drinkNameTextField?.text ?? ""
        let drinkNumber = Int(drinkNumberTextField?.text ?? "") ?? 0
        let drinkVolume = Int(drinkVolumeTextField?.text ?? "") ?? 0
        let drinkAlcoholContent = Double(alcoholContentTextField?.text ?? "") ?? 0.00
        let drinkPrice = Float(drinkPriceTextField?.text ?? "") ?? 0
        let alcCalcResult = Double(self.alcCalcResult) 
        
        // Set the result to be passed to ResultsTableViewController after the unwind segue.
        result = Result(drinkName: drinkName, drinkNumber: drinkNumber, drinkAlcoholContent: drinkAlcoholContent, drinkVolume: drinkVolume, drinkPrice: Float(drinkPrice), alcCalcResult: alcCalcResult)

    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = drinkNameTextField?.text ?? ""
        calculateButton.isEnabled = !text.isEmpty
    }
}


