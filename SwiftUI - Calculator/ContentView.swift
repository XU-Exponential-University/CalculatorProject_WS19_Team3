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
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            TextField("0", text: $calculatorText).font(.system(size: 100))
                .padding()
                .multilineTextAlignment(.trailing)
            
            HStack {
                Button(action: {
                    self.operandTapped("0")
                }) {
                    Text("AC")
                }
                Spacer()
                Button(action: {
                    self.operandTapped("±")
                }) {
                    Text("+/-")
                }
                Spacer()
                Button(action: {
                    self.operandTapped("%")
                }) {
                    Text("%")
                }
                Spacer()
                Button(action: {
                    self.operandTapped("/")
                }) {
                    Text("/")
                }
            }.padding()

            HStack {
                createCalcDigit("7")
                Spacer()
                createCalcDigit("8")
                Spacer()
                createCalcDigit("9")
                Spacer()
                Button(action: {
                    self.operandTapped("*")
                }) {
                    Text("×")
                }
            }.padding()

            HStack {
                createCalcDigit("4")
                Spacer()
                createCalcDigit("5")
                Spacer()
                createCalcDigit("6")
                Spacer()
                Button(action: {
                    self.operandTapped("-")
                }) {
                    Text("-")
                }
            }.padding()

            HStack {
                createCalcDigit("1")
                Spacer()
                createCalcDigit("2")
                Spacer()
                createCalcDigit("3")
                Spacer()
                Button(action: {
                    self.operandTapped("+")
                }) {
                    Text("+")
                }
            }.padding()

            HStack {
                Spacer()
                createCalcDigit("0")
                Spacer()
                createCalcDigit(".")
                Spacer()
                Button(action: {
                    self.calculate()
                }) {
                    (Text("="))
                }

            }.padding()
        }
        .font(.largeTitle)
    }
    
    private func createCalcDigit(_ number: String) -> Button<Text> {
        return Button(action: {
            self.digitTapped(number)
        }) {
            (Text(number))
        }
    }

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

//      This is just for preview reasons here, do not delete or change (unless you know what you are doing)!!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    
    
}
