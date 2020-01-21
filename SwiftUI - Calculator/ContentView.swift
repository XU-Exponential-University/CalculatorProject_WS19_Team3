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
    
// ----------  ----------  ---------- MARK - Body ----------  ----------  ----------
//      basically the whole body (=everything u see on screen)
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            TextField("0", text: $calculatorText).font(.system(size: 100))
                .padding()
                .multilineTextAlignment(.trailing)
                .foregroundColor(.white)
            
            HStack {
                Button(action: {
                    self.operandTapped("(")
                }) {
                    Text("[")
                }
                Button(action: {
                    self.operandTapped(")")
                }) {
                    Text("]")
                }
            }.buttonStyle(klammernButton())
            
            HStack {
                Group {
                    createCalcDigit("7")
                    createCalcDigit("8")
                    createCalcDigit("9")
                }.buttonStyle(numberButton())
                Group {
                    Button(action: {
                        self.operandTapped("±")
                    }) {
                        Text("±")
                    }
                    Button(action: {
                        self.operandTapped("%")
                    }) {
                        Text("%")
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
                    Button(action: {
                        self.operandTapped("/")
                    }) {
                        Text("/")
                    }
                    Spacer()
                    Button(action: {
                        self.operandTapped("*")
                    }) {
                        Text("×")
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
                    Button(action: {
                        self.operandTapped("+")
                    }) {
                        Text("+")
                    }
                    Spacer()
                    Button(action: {
                        self.operandTapped("-")
                    }) {
                        Text("-")
                    }
                }.buttonStyle(calcButton())
            }

            HStack {
                Group {
                    createCalcDigit("0")
                    createCalcDigit(".")
                }.buttonStyle(numberButton())
                Button(action: {
                    self.operandTapped("0")
                }) {
                    Text("AC")
                    .font(.system(size: 25))
                }.buttonStyle(calcButton())
                Button(action: {
                    self.calculate()
                }) {
                    (Text("="))
                }.buttonStyle(equalButton())
            }.padding(.bottom, 50)
        }
        .font(.largeTitle)
        .padding()
        .background(Color(red: 72/255, green: 76/255, blue: 80/255))
        .edgesIgnoringSafeArea(.all)
    }
    
    private func createCalcDigit(_ number: String) -> Button<Text> {
        return Button(action: {
            self.digitTapped(number)
        }) {
            (Text(number))
        }
    }

// ----------  ----------  ---------- MARK - Calculations ----------  ----------  ----------
//      pressing a number
    private func digitTapped(_ number: String) -> Void {
        if isTypingNumber {
            calculatorText += number
        } else {
            calculatorText = number
            isTypingNumber = true
        }
    }

//      basic calculations
    private func operandTapped(_ operand: String) {
        isTypingNumber = false
        firstNumber = calculatorText
        self.operand = operand
        calculatorText = operand
        
        var result  = "0"
        var intResult = 0.0
        
        if operand == "±" {
            intResult = Double(firstNumber)! * -1
            result = String(intResult)
        }
        calculatorText = result
    }

//      what happens when you press "="
    private func calculate() {
        isTypingNumber = false
        var result  = "0"
        var intResult = 0.0
        secondNumber = calculatorText

        if operand == "+" {
            intResult = Double(firstNumber)! + Double(secondNumber)!
            result = String(intResult)
        } else if operand == "-" {
            intResult = Double(firstNumber)! - Double(secondNumber)!
            result = String(intResult)
        } else if operand == "*" {
            intResult = Double(firstNumber)! * Double(secondNumber)!
            result = String(intResult)
        } else if operand == "/" {
            intResult = Double(firstNumber)! / Double(secondNumber)!
            result = String(intResult)
        } else if operand == "%" {
            intResult = (Double(secondNumber)! / 100) * Double(firstNumber)!
            result = String(intResult)
        }

        calculatorText = result
    }

    
// ----------  ----------  ---------- MARK - ButtonStyle ----------  ----------  ----------
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
                .font(.system(size: 25))
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
    
// ----------  ----------  ---------- MARK - ContenView Preview ----------  ----------  ----------
//      This is just for preview reasons here, do not delete or change (unless you know what you are doing)!!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    
    
}
