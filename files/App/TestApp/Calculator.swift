//
//  Calculator.swift
//  Calculate
//
//  Created by 张乐简 on 2021/9/27.
//

import Foundation
import UIKit

class Calculator : NSObject{
    
    enum Operation{
        case UnaryOp((Double)->Double)
        case BinaryOp((Double,Double)->Double)
        case EqualOp
        case Rad
        case Deg
        case Constant(Double)
    }
    var radMode:Double=Double.pi/180
    var _result:Double?
    var result:Double?{
        get{
            return _result
        }
        set(v){
            if(abs(v!)<1e-6){
                print("to small")
                _result=0
            }else if(v!>2147483647.0){
                _result=nil
            }else{
                _result=v
            }
        }
    }
    var operations=[
        "+":Operation.BinaryOp{
            (op1,op2) in
            return op1+op2
        },
        "-":Operation.BinaryOp{
            (op1,op2) in
            return op1-op2
        },
        "*":Operation.BinaryOp{
            (op1,op2) in
            return op1*op2
        },
        "/":Operation.BinaryOp{
            (op1,op2) in
            return op1/op2
        },
        "=":Operation.EqualOp,
        "%":Operation.UnaryOp{
            op in
            return op/100
        },
        "+/-":Operation.UnaryOp{
            op in
            return -op
        },
        "x^2":Operation.UnaryOp{
            op in
            return op*op
        },
        "x^3":Operation.UnaryOp{
            op in
            return op*op*op
        },
        "x^y":Operation.BinaryOp{
            (op1,op2) in
            return pow(Double(op1), Double(op2))
        },
        "e^x":Operation.UnaryOp{
            op in
            return pow(2.7182818284, Double(op))
        },
        "10^x":Operation.UnaryOp{
            op in
            return pow(10, Double(op))
        },
        "1/x":Operation.UnaryOp{
            op in
            return 1/Double(op)
        },
        "√x":Operation.UnaryOp{
            op in
            return sqrt(Double(op))
        },
        "x^(1/3)":Operation.UnaryOp{
            op in
            return pow(Double(op), 1/3)
        },
        "x^(1/y)":Operation.BinaryOp{
            (op1,op2) in
            return pow(Double(op1), 1/Double(op2))
        },
        "ln":Operation.UnaryOp{
            op in
            return log(Double(op))
        },
        "log10":Operation.UnaryOp{
            op in
            return log10(Double(op))
        },
        "x!":Operation.UnaryOp{
            op in
            var ret=1
            var L=Int(op)
            for i in 1...L{
                ret=ret*i
            }
            return Double(ret)
        },
        "sinh":Operation.UnaryOp{
            op in
            return sinh(Double(op))
        },
        "cosh":Operation.UnaryOp{
            op in
            return cosh(Double(op))
        },
        "tanh":Operation.UnaryOp{
            op in
            return tanh(Double(op))
        },
        "Rad":Operation.Rad,
        "Deg":Operation.Deg,
        "EE":Operation.BinaryOp{
            (op1,op2) in
            return op1*pow(10,op2)
        },
        "e":Operation.Constant(
            2.7182818284
        ),
        "pi":Operation.Constant(
            Double.pi
        )
    ]
    struct Intermediate{
        var firstOp:Double
        var waitingOperation:((Double,Double)->Double)
    }
    public func Init(){
        operations["sin"]=Operation.UnaryOp{
            op in
            return sin(Double(op)*self.radMode)
        }
        operations["cos"]=Operation.UnaryOp{
            op in
            return cos(Double(op)*self.radMode)
        }
        operations["tan"]=Operation.UnaryOp{
            op in
            return tan(Double(op)*self.radMode)
        }
    }
    
    var pendingOp:Intermediate?=nil
    func performOperation(operation:String,operand:Double)->Double?{
        if let op=operations[operation]{
            switch op {
            case .BinaryOp(let function):
                pendingOp=Intermediate(firstOp: operand, waitingOperation: function)
                return nil
            case .Constant(let value):
                return value
            case .EqualOp:
                result=pendingOp!.waitingOperation(pendingOp!.firstOp,operand)
                return result
            case .Rad:
                radMode=1
                return nil
            case .Deg:
                radMode=Double.pi/180
                return nil
            case .UnaryOp(let function):
                result=function(operand)
                return result
            }
        }
        return nil
    }
    func clear(){
        pendingOp=nil
    }
    
}
