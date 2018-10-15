//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    init(amount:Int, currency:String) {
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ to: String) -> Money {
        
        switch self.currency {
        case "USD":
            if(to == "GBP") {
                return Money(amount: Int(Double(self.amount) * 0.5), currency: "GBP")
            } else if (to == "EUR"){
                return Money(amount: Int(Double(self.amount) * 1.5), currency: "EUR")
            }else if (to == "CAN"){
                return Money(amount: Int(Double(self.amount) * 1.25), currency: "CAN")
            }
        case "GBP":
            return Money(amount: Int(Double(self.amount) / 0.5), currency: "USD")
        case "EUR":
            return Money(amount: Int(Double(self.amount) / 1.5), currency: "USD")
        case "CAN":
            return Money(amount: Int(Double(self.amount) / 1.25), currency: "USD")
        default:
            return self
        }
        return self
    }
    
    public func add(_ to: Money) -> Money {
        if(self.currency != to.currency){
            var newMon = self.convert(to.currency)
            newMon.amount = newMon.amount + to.amount
            return newMon
        }else{
            let newVal = self.amount + to.amount
            return Money(amount: newVal, currency: self.currency)
        }
    }
    public func subtract(_ from: Money) -> Money {
        if(self.currency != from.currency){
            var newMon = self.convert(from.currency)
            newMon.amount = newMon.amount + from.amount
            return newMon
        }else{
            let newVal = self.amount - from.amount
            return Money(amount: newVal, currency: self.currency)
        }
    }
}
////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }

    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type{
        case .Hourly(let payAmount):
            return Int(payAmount * Double(hours))
        case .Salary(let payAmount):
            return payAmount
        }
    }

    open func raise(_ amt : Double) {
        switch self.type{
        case .Hourly(let payAmount):
            self.type = .Hourly(payAmount + amt)
        case .Salary(let payAmount):
            self.type = .Salary(Int((Double(payAmount) + amt)))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0

    fileprivate var _job : Job? = nil
        open var job : Job? {
            get {
                if (self.age > 21) {
                    return _job
                }
                return nil
            } set {
                _job = newValue
        }
    }

    fileprivate var _spouse : Person? = nil
        open var spouse : Person? {
            get {
                if( self.age > 21){
                    return _spouse
                }
                return nil
            } set {
               _spouse = newValue
        }
    }

    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    // "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]"
    open func toString() -> String {
        let output = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(spouse)]"
        return output
    }
}

////////////////////////////////////
// Family
//
open class Family {
    
    fileprivate var members : [Person] = []

    public init(spouse1: Person, spouse2: Person) {
        if(spouse1.spouse == nil && spouse2.spouse == nil) {
            self.members.append(spouse2)
            self.members.append(spouse1)
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
    }

    open func haveChild(_ child: Person) -> Bool {
        if(self.members[0].age > 21 || self.members[1].age > 21) {
            self.members.append(child)
            return true
        }
        return false
    }

    open func householdIncome() -> Int {
        var total = 0
        for person in members {
            if(person.job != nil){
                let income = person.job!.calculateIncome(2000)
                total += income
            }
        }
        return total
    }
}





