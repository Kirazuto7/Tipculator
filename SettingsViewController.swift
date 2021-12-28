//
//  SettingsViewController.swift
//  Tipculator
//
//  Created by Jordan Sukhnandan on 12/23/21.
//

import UIKit

class SettingsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var tipSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var customizeSegmentLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    let defaults = UserDefaults.standard
    let ON_OFF_KEY = "switchOnOff"
    
    //Customize tip segment variables
    @IBOutlet weak var tipOneTextField: UITextField!
    @IBOutlet weak var tipTwoTextField: UITextField!
    @IBOutlet weak var tipThreeTextField: UITextField!
    let TIP_ONE_KEY = "tip1"
    let TIP_TWO_KEY = "tip2"
    let TIP_THREE_KEY = "tip3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        customizeSegmentLabel.center.x = view.frame.width/2
        resetButton.center.x = view.frame.width/2
        
        setSwitchState()
        updateTipTextField()
        defaults.synchronize()
        
        tipOneTextField.delegate = self
        tipOneTextField.addDoneButtonToKeyboard(myAction:  #selector(self.tipOneTextField.resignFirstResponder))
        tipTwoTextField.delegate = self
        tipTwoTextField.addDoneButtonToKeyboard(myAction:  #selector(self.tipTwoTextField.resignFirstResponder))
        tipThreeTextField.delegate = self
        tipThreeTextField.addDoneButtonToKeyboard(myAction:  #selector(self.tipThreeTextField.resignFirstResponder))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func reset(_ sender: Any) {
        defaults.removeObject(forKey: ON_OFF_KEY)
        defaults.removeObject(forKey: TIP_ONE_KEY)
        defaults.removeObject(forKey: TIP_TWO_KEY)
        defaults.removeObject(forKey: TIP_THREE_KEY)
        defaults.set("15", forKey: TIP_ONE_KEY)
        defaults.set("18", forKey: TIP_TWO_KEY)
        defaults.set("20", forKey: TIP_THREE_KEY)
        updateTipTextField()
        tipSwitch.setOn(false, animated: false)
        switchLabel.text = "Tip Segment"
    }
    
    //Update the tip text field information
    func updateTipTextField()
    {
        let tipOneText = defaults.string(forKey: TIP_ONE_KEY)
        tipOneTextField.text = tipOneText
        let tipTwoText = defaults.string(forKey: TIP_TWO_KEY)
        tipTwoTextField.text = tipTwoText
        let tipThreeText = defaults.string(forKey: TIP_THREE_KEY)
        tipThreeTextField.text = tipThreeText
    }
    
    //Change the tip segment according to the user input
    @IBAction func setTipOne(_ sender: UITextField) {
        let tipOne = tipOneTextField.text
        defaults.set(tipOne, forKey: TIP_ONE_KEY)
    }
    @IBAction func setTipTwo(_ sender: UITextField) {
        let tipTwo = tipTwoTextField.text
        defaults.set(tipTwo, forKey: TIP_TWO_KEY)
    }
    @IBAction func setTipThree(_ sender: UITextField) {
        let tipThree = tipThreeTextField.text
        defaults.set(tipThree, forKey: TIP_THREE_KEY)
    }
    
    //Sets the state of the flipped switch
    func setSwitchState()
    {
        if(defaults.bool(forKey: ON_OFF_KEY)){
            tipSwitch.setOn(true, animated: false)
            switchLabel.text = "Tip Slider"
        }
        else
        {
            tipSwitch.setOn(false, animated: false)
            switchLabel.text = "Tip Segment"
        }
    }
    
    //Toggles the switch between a slider and a segment control
    @IBAction func flipSwitch(_ sender: Any) {
        if(tipSwitch.isOn) //Use slider when switch is on
        {
            defaults.set(true, forKey: ON_OFF_KEY)
            switchLabel.text = "Tip Slider"
        }
        else //Use segmentted controller when switch is off
        {
            defaults.set(false, forKey: ON_OFF_KEY)
            switchLabel.text = "Tip Segment"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
