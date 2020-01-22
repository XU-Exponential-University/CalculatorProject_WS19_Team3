//
//  ContentView.swift
//  SwiftUI - Calculator
//
//  Created by Benjamin Homuth on 15.01.20.
//  Copyright © 2020 Benjamin Homuth. All rights reserved.
//

import SwiftUI

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
            
            TextField("0", text: $calculatorText).font(.system(size: 100))
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
    
    // what happens when you press "="
    private func calculate() {
        let inputExpression = calculatorText;
        let cleanedExpression = inputExpression.replacingOccurrences(of: "√", with: "sqrt")
        let res: Double = NSExpression(format: cleanedExpression).expressionValue(with: nil, context: nil) as! Double
        
        calculatorText = String(res)
        calcHistory[inputExpression] = res
    }
    
    
    // MARK: --------- ButtonStyle ---------
    struct numberButton: PrimitiveButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
        }
    }
    
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
