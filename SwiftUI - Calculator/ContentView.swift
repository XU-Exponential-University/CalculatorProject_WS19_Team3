//
//  ContentView.swift
//  SwiftUI - Calculator
//
//  Created by Benjamin Homuth on 15.01.20.
//  Copyright © 2020 Benjamin Homuth. All rights reserved.
//

import SwiftUI

// MARK: Felix Part I

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension NSExpression {

    // Converts everything in a NSExpression to doubles so a decimal result is returned.
    func toFloatingPoint() -> NSExpression {
        // Switch trough different types of expressions that need different handling
        switch expressionType {
            
            // Constant values
            case .constantValue:
                if let value = constantValue as? NSNumber {
                    return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
                }
            
            //
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

// MARK: Benny's Code I

struct ContentView: View {
    
    // declared everything at the beginning
    @State private var firstNumber = "0"
    @State private var secondNumber = "0"
    @State private var operand = ""
    @State private var calculatorText = "0"
    @State private var isTypingNumber = false
    @State private var calcHistory: [String: Double] = [:]
    
    // basically the whole body (= everything u see on screen)
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()

            
            /*
                Some explanation here, because it would get boring repeating myself for all HStacks:
                    - createCalcDigit: Should show the number pressed
                    - buttonStyle: Changes the design of the buttons respectively (declared in lines 355 - 400)
                    - Button: Shows the brackets or basic operations respectively
            */
            
            //textfield look / default number
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
                        Text("+/-")
                    }.onTapGesture {
                        self.plusMinusToggle()
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
    
    // MARK: Felix Code II
    
    // Fired when a digit is tappen. Appends the digit to the calculation or replaced it when it is empty
    private func digitTapped(_ number: String) -> Void {
        if(calculatorText == "0" || calculatorText == "Error"){
            calculatorText = number;
        } else {
            calculatorText.append(number);
        }
    }
    
    private func plusMinusToggle(){
        if(calculatorText.hasPrefix("-")){
            calculatorText = String(calculatorText.dropFirst(1))
        } else {
            calculatorText = "-\(calculatorText)"
        }
    }
    
    // adds operands to the calculation and formats them accordingly
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
    
    func checkParentheses(s: String) -> [Character] {
        let pairs: [Character: Character] = ["(": ")", "[": "]", "{": "}"] // Those are the pairs of brackets we are looking for
        var stack: [Character] = []
        for char in s { // Loop through the equation
            if let match = pairs[char] {
                stack.append(match) // We found a bracket and are now looking for the closing one
            } else if stack.last == char {
                stack.popLast() // Ignore the warning Xcode gives you, doing this is just faster then manually removing the last element
            }
        }
        return stack // In the end we return the unclosed brackets
    }
    
    func properRound(number: Double) -> Double {
        return Double(round(10000 * number)/10000)
    }
    
    // returns a boolean if a string matches a given regex
    func matchesForRegexInText(regex: String!, text: String!) -> Bool {

        // Do & Catch to pevent issues with invalid regex syntax (that might be caused through later changes)
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            
            guard regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length)) != nil else {
                return false // pattern does not match the string
            }
            
            return true // pattern does match (because a first match was found)
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
        
    }
    
    // Fired when you press the equal sign. First validating and sanitizing the input that is then passed onto NSExpressions to evaluate
    private func calculate() {
        
        let inputExpression = calculatorText;
        
        // Check if input is fa valid formula. Regex is explained in the documentation
        if !matchesForRegexInText(regex: "^([0-9\\-\\*\\+\\s\\(\\)\\.,√\\/]+)$", text: inputExpression) || !matchesForRegexInText(regex: "^[(]?[-]?([0-9√]+)[)(]??([)(]?([-+/*]?[0-9]?[)(]?([0-9]))?([.,][0-9]+)?[)]?)*$", text: inputExpression) {
            calculatorText = "Error"
        } else {
            
            // Replace signs used for better visuals with commands required by NSExpressions
            var cleanedExpression = inputExpression.replacingOccurrences(of: "√", with: "sqrt")

            // Find the amout of missing Parentheses
            let missingParentheses = checkParentheses(s: cleanedExpression)
            // and add the missing amount
            if(missingParentheses.count > 0){
                for i in missingParentheses {
                    cleanedExpression = cleanedExpression + "\(i)"
                }
            }
            
            // create Expression as Float
            let expr = NSExpression(format: cleanedExpression).toFloatingPoint()
            do {
                // Get result and round it
                let res:Double = try! expr.expressionValue(with: nil, context: nil) as! Double
                calculatorText = String(properRound(number: res))
                calcHistory[inputExpression] = res
            } catch {
                calculatorText = "ExError"
            }
            
        }

    }
    
    
    // MARK: Benny's Code II
   
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
    

    // This is just for preview reasons here, do not delete or change (unless you know what you are doing)!!
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
}

//


