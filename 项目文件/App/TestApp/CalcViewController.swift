//
//  CalcViewController.swift
//  Calculate
//
//  Created by 张乐简 on 2021/9/27.
//

import UIKit

class CalcViewController: UIViewController {

    @IBOutlet weak var text:UILabel!
    var digitsOnDisplay:String{
        get{
            return self.text.text!
        }
        set{
            self.text.text!=newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.Init()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var inTypingMode:Bool=false
    var calculator=Calculator()
    @IBAction func onPressed(_ sender:UIButton){
        if inTypingMode{
            digitsOnDisplay=digitsOnDisplay+(sender.currentTitle!)
        }else{
            digitsOnDisplay=sender.currentTitle!
            inTypingMode=true
        }
    
    }


    @IBAction func onOperationPressed(_ sender: UIButton) {
        if(sender.currentTitle=="Rand"){
            digitsOnDisplay=String(drand48())
            return
        }
        var op=sender.currentTitle
        var result:Double?=calculator.performOperation(operation: op!, operand: (Double)(digitsOnDisplay)!)
                if(result==nil){
                    if(op=="="){
                        digitsOnDisplay="nan"
                    }
                }else{
                    digitsOnDisplay=String(result!)
                }
            inTypingMode=false
        //状态键
        if(sender.currentTitle=="Rad"){
            sender.setTitle("Deg",for: UIControl.State.normal)
        }else if(sender.currentTitle=="Deg"){
            sender.setTitle("Rad",for: UIControl.State.normal)
        }
        
    }
    @IBAction func onClear(_ sender: UIButton) {
        calculator.clear()
        digitsOnDisplay="0"
        inTypingMode=false
    }
}
