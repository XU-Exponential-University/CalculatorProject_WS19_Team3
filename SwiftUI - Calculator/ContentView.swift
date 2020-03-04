//
//  ContentView.swift
//  SwiftUI - Calculator
//
//  Created by Benjamin Homuth on 15.01.20.
//  Copyright © 2020 Benjamin Homuth. All rights reserved.
//

import SwiftUI

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension NSExpression {

    func toFloatingPoint() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
           let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
           return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
           return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .anyKey:
            fatalError("anyKey not yet implemented")
        case .block:
            fatalError("block not yet implemented")
        case .evaluatedObject, .variable, .keyPath:
            break // Nothing to do here
        }
        return self
    }
}

struct ContentView: View {
    
    @State private var firstNumber = "0"
    @State private var secondNumber = "0"
    @State private var operand = ""
    @State private var calculatorText = "0"
    @State private var isTypingNumber = false
    @State private var calcHistory: [String: Double] = [:]
    
    // MARK: --------- Body ---------
    // basically the whole body (=everything u see on screen)
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()

            
    //textfield look/ default number
            TextField("0", text: $calculatorText)
                .font(.system(size: 100))
                .minimumScaleFactor(0.5) //font size smaller by 50%
                .padding()
                .multilineTextAlignment(.trailing)
                .foregroundColor(.white)
                .truncationMode(.head)
                .disabled(true)

            
            HStack {
                
                Button(action: {}) {
                    Text("(")
                }.onTapGesture {
                    self.operandTapped("(")
                }
                
                Button(action: {}) {
                    Text(")")
                }.onTapGesture {
                    self.operandTapped(")")
                }
                
            }.buttonStyle(klammernButton())
            
            HStack {
                
                Group {
                    createCalcDigit("7")
                    createCalcDigit("8")
                    createCalcDigit("9")
                }.buttonStyle(numberButton())
                
                Group {
                    
                    Button(action: {}) {
                        Text("√")
                    }.onTapGesture {
                        self.operandTapped("√")
                    }
                    
                    Button(action: {}) {
                        Text("%")
                    }.onTapGesture {
                        self.operandTapped("%")
                    }
                    
                }.buttonStyle(calcButton())
            }
            
            HStack {
                
                Group {
                    createCalcDigit("4")
                    createCalcDigit("5")
                    createCalcDigit("6")
                }.buttonStyle(numberButton())
                
                Group {
                    
                    Button(action: {}) {
                        Text("/")
                    }.onTapGesture {
                        self.operandTapped("/")
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("×")
                    }.onTapGesture {
                        self.operandTapped("*")
                    }
                    
                }.buttonStyle(calcButton())
            }
            
            HStack {
                
                Group {
                    createCalcDigit("1")
                    createCalcDigit("2")
                    createCalcDigit("3")
                }.buttonStyle(numberButton())
                
                Group {
                    
                    Button(action: {}) {
                        Text("+")
                    }.onTapGesture {
                        self.operandTapped("+")
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("-")
                    }.onTapGesture {
                        self.operandTapped("-")
                    }
                    
                }.buttonStyle(calcButton())
                
            }
            
            HStack {
                
                Group {
                    createCalcDigit("0")
                    createCalcDigit(".")
                }.buttonStyle(numberButton())
                
                Button(action: {}) {
                    Text("AC")
                    .font(.system(size: 25))
                }.buttonStyle(calcButton())
                 .onTapGesture {
                    self.calculatorText = "0"
                }
                
                Button(action: {}) {
                    (Text("="))
                }.buttonStyle(equalButton())
                 .onTapGesture {
                    self.calculate()
                }
                
            }.padding(.bottom, 50)
        }
            
    // Background of the calculator
        .font(.largeTitle)
        .padding()
        .background(Color(red: 72/255, green: 76/255, blue: 80/255))
        .edgesIgnoringSafeArea(.all)
    }
    
    private func createCalcDigit(_ number: String) -> some View {
        return Button(action: {
        }) {
            Text(number)
        }.onTapGesture {
            self.operandTapped(number)
        }
        
    }
    
    // MARK: --------- Calculations ---------
    // pressing a number
    private func digitTapped(_ number: String) -> Void {
        if(calculatorText == "0"){
            calculatorText = number;
        } else {
            calculatorText.append(number);
        }
    }
    
    // basic calculations
    private func operandTapped(_ operand: String) {
        
        var formattedOperand = "";
        
        switch operand {
            case "√":
                formattedOperand = "√("
            case "log":
                formattedOperand = "log("
            default:
                formattedOperand = operand
        }
        
        if(calculatorText == "0"){
            calculatorText = formattedOperand;
        } else {
            calculatorText.append(formattedOperand);
        }

    }
    
    func checkParentheses(s: String) -> Int {
        let pairs: [Character: Character] = ["(": ")", "[": "]", "{": "}"]
        var stack: [Character] = []
        for char in s {
            if let match = pairs[char] {
                stack.append(match)
            } else if stack.last == char {
                stack.popLast()
            }
        }
        return stack.count
    }
    
    
    func matchesForRegexInText(regex: String!, text: String!) -> Bool {

        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            guard let result = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length)) else {
                return false // pattern does not match the string
            }
            return true
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    // what happens when you press "="
    private func calculate() {
        let inputExpression = calculatorText;
        var cleanedExpression = inputExpression.replacingOccurrences(of: "√", with: "sqrt")
        
        if matchesForRegexInText(regex: "^([0-9\\-\\*\\+\\s\\(\\)\\.,]+)$", text: cleanedExpression) {
            calculatorText = "Error"
        } else {
            
            let missingParentheses = checkParentheses(s: cleanedExpression)
            print(missingParentheses)
            if(missingParentheses > 0){
                for _ in 1...missingParentheses {
                    cleanedExpression = cleanedExpression + ")"
                }
            }
            
            let expr = NSExpression(format: cleanedExpression).toFloatingPoint()
            do {
                
                let res:Double = try! expr.expressionValue(with: nil, context: nil) as! Double
                calculatorText = String(res)
                calcHistory[inputExpression] = res
            } catch {
                calculatorText = "Error"
            }
            
        }

    }
    
    
    // MARK: --------- ButtonStyle ---------
   
    // Button style for all Numbers
    struct numberButton: PrimitiveButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
        }
    }
    
    // Button style for brackets
    struct klammernButton: PrimitiveButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .font(.largeTitle)
                .multilineTextAlignment(.trailing)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical, 7)
                .foregroundColor(Color(red: 141/255, green: 201/255, blue: 207/255))
                .border(Color.gray, width: 1)
        }
    }
    
    // Button style for all compute-signs
    struct calcButton: PrimitiveButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.system(size: 25))
                .padding()
                .foregroundColor(.black)
                .background(Color(red: 141/255, green: 201/255, blue: 207/255))
                .cornerRadius(40)
        }
    }
    
    // Button style for "=" button
    struct equalButton: PrimitiveButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: 115, maxWidth: .infinity)
                .font(.system(size: 25))
                .foregroundColor(.black)
                .padding()
                .background(Color(red: 223/255, green: 241/255, blue: 186/255))
                .cornerRadius(40)
        }
    }
    
    

    
    // MARK: --------- ContenView Preview ---------
    // This is just for preview reasons here, do not delete or change (unless you know what you are doing)!!
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
}

//


