//
//  ViewController.swift
//  Prework
//
//  Created by Jordan Sukhnandan on 12/21/21.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipSliderLabel: UILabel!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var peopleStepper: UIStepper!
    @IBOutlet weak var billAmountLabel: UILabel!
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var numPeople: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var calcButton: UIButton!
    
    let defaults = UserDefaults.standard
    let ON_OFF_KEY = "switchOnOff"
    let TIP_ONE_KEY = "tip1"
    let TIP_TWO_KEY = "tip2"
    let TIP_THREE_KEY = "tip3"
    let greenColor = UIColor(red: 51/255, green: 105/255, blue: 30/255, alpha: 1)
    let goldColor = UIColor(red: 1, green: 221/255, blue: 14/255, alpha: 1)
    let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startUpUI()
        customizeBackButton()
        billAmountTextField.becomeFirstResponder()
        billAmountTextField.delegate = self
        billAmountTextField.addDoneButtonToKeyboard(myAction:  #selector(self.billAmountTextField.resignFirstResponder))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        // This is a good place to retrieve the default tip percentage from UserDefaults
        // and use it to update the tip amount
        //Toggle between segment control and slider
        let switch_on = defaults.bool(forKey: ON_OFF_KEY)
        
        if(switch_on)
        {
            tipControl.isHidden = true
            tipSlider.isHidden = false
            tipSliderLabel.isHidden = false
        }
        else
        {
            tipControl.isHidden = false
            tipSlider.isHidden = true
            tipSliderLabel.isHidden = true
        }
        
        //Update Segment
        let tipOne = defaults.string(forKey: TIP_ONE_KEY) ?? "15"
        tipControl.setTitle(tipOne + "%", forSegmentAt: 0)
        let tipTwo = defaults.string(forKey: TIP_TWO_KEY) ?? "18"
        tipControl.setTitle(tipTwo + "%", forSegmentAt: 1)
        let tipThree = defaults.string(forKey: TIP_THREE_KEY) ?? "20"
        tipControl.setTitle(tipThree + "%", forSegmentAt: 2)
    }
    
    //Contains ui customizations on app start up
    func startUpUI()
    {
        //Navigation Bar changes
        self.navigationController?.setStatusBar(backgroundColor: greenColor)
        self.title = "Tipculator"
        
        center()
        
        //UISegmentControl changes
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: goldColor], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : blackColor], for: .selected)
        
        //UIStepper changes
        peopleStepper.setDecrementImage(peopleStepper.decrementImage(for: .normal), for: .normal)
        peopleStepper.setIncrementImage(peopleStepper.incrementImage(for: .normal), for: .normal)
        
    }
    
    //Removes the text from the back button
    func customizeBackButton()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //Increment the party size
    @IBAction func incrementPeople(_ sender: UIStepper) {
        numPeople.text = String(format: "%.0f",peopleStepper.value)
    }
    
    //Display the corresponding slider percentage
    @IBAction func tipSliderPercentage(_ sender: Any) {
        tipSliderLabel.text = String(format: "%.0f", roundf(tipSlider.value)) + "%"
    }
    
    //Calculate the total bill including tip
    @IBAction func calculateTip(_ sender: Any) {
        let switch_on = defaults.bool(forKey: ON_OFF_KEY)
    
        //Get bill amount from text field
        var bill = Double(billAmountTextField.text!) ?? 0
        let numOfPeople = Double(numPeople.text!) ?? 1
        bill = bill/numOfPeople
        
        if(!switch_on) //Calculation utilizing the segment control
        {
            //Calculate total tip based on percentage
            //let tipPercentages = [0.15, 0.18, 0.2, 0.0]
            var tipPercentages = 0.0
            if(tipControl.selectedSegmentIndex == 0)
            {
                tipPercentages = defaults.double(forKey: TIP_ONE_KEY) * 0.01
            }
            else if(tipControl.selectedSegmentIndex == 1)
            {
                tipPercentages = defaults.double(forKey: TIP_TWO_KEY) * 0.01
            }
            else if(tipControl.selectedSegmentIndex == 2)
            {
                tipPercentages = defaults.double(forKey: TIP_THREE_KEY) * 0.01
            }
    
            //let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
            let tip = bill * tipPercentages
            let total = bill + tip
            
            //Update Tip Amount
            tipAmountLabel.text = String(format: "$%.2f", tip)
            //Update Total Amount
            totalLabel.text = String(format: "$%.2f", total)
        }
        else if(switch_on) //Calculation utilizing the slider
        {
            let slider_value = roundf(tipSlider.value);
            let tipPercentage = Double(slider_value) * 0.01
            let tip = bill * tipPercentage
            let total = bill + tip
            
            //Update Tip Amount
            tipAmountLabel.text = String(format: "$%.2f", tip)
            //Update Total Amount
            totalLabel.text = String(format: "$%.2f", total)
        }
    }
    
    //Sets widget(s) horizontally in the center
    func center(){
        billAmountLabel.center.x = view.frame.width/2
        billAmountTextField.center.x = view.frame.width/2
        //partySizeLabel.center.x = view.frame.width/2
        tipControl.center.x = view.frame.width/2
        calcButton.center.x = view.frame.width/2
    }
}

//Removes the keyboard after the user enters their bill amount and presses return
/*extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}*/
extension UITextField{

 func addDoneButtonToKeyboard(myAction:Selector?){
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    doneToolbar.barStyle = UIBarStyle.default

     let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
     let done: UIBarButtonItem = UIBarButtonItem(title: "Enter", style: UIBarButtonItem.Style.done, target: self, action: myAction)

    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)

    doneToolbar.items = items
    doneToolbar.sizeToFit()

    self.inputAccessoryView = doneToolbar
 }
}

//Change the color of the status bar
extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}

