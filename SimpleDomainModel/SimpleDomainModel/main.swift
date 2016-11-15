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
  
  public func convert(_ to: String) -> Money {
    var am = 0
    switch self.currency {
    case "USD":
        var XR: [String: (Int, Int)] = [
            "GBP": (2, 1),
            "EUR": (2, 3),
            "CAN": (4, 5)
        ]
        am += self.amount * XR[to]!.1 / XR[to]!.0
    case "GBP":
        var XR: [String: (Int, Int)] = [
            "USD": (1, 2),
            "EUR": (1, 3),
            "CAN": (2, 5)
        ]
        am += self.amount * XR[to]!.1 / XR[to]!.0
    case "EUR":
        var XR: [String: (Int, Int)] = [
            "GBP": (3, 1),
            "USD": (3, 2),
            "CAN": (6, 5)
        ]
        am += self.amount * XR[to]!.1 / XR[to]!.0
    case "CAN":
        var XR: [String: (Int, Int)] = [
            "GBP": (5, 2),
            "EUR": (5, 6),
            "USD": (5, 4)
        ]
        am += self.amount * XR[to]!.1 / XR[to]!.0
    default:
        break
    }
    return Money(amount: am, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    var temp: Money
    if self.currency != to.currency {
        temp = convert(to.currency)
        return Money(amount: temp.amount + to.amount, currency: to.currency)
    } else {
        return Money(amount: self.amount + to.amount, currency: self.currency)
    }
  }
  public func subtract(_ from: Money) -> Money {
    var temp: Money
    if self.currency != from.currency {
        temp = convert(from.currency)
        return Money(amount: temp.amount + from.amount, currency: from.currency)
    } else {
        return Money(amount: self.amount + from.amount, currency: self.currency)
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
  
  public init(title: String, type: JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let value):
        return hours * Int(value)
    case .Salary(let value):
        return value
    }
  }
  
  open func raise(_ amt: Double) {
    switch self.type {
    case let .Hourly(value):
        self.type = .Hourly(value + amt)
    case let .Salary(value):
        self.type = .Salary(value + Int(amt))
    }
  }
}

//////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return _job
    }
    set(value) {
        if self.age >= 16 {
            _job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if self.age >= 18 {
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    members.append(spouse1)
    members.append(spouse2)
  }
  
  open func haveChild(_ child: Person) -> Bool {
    members.append(child)
    for person in members {
        if person.age >= 21 {
            return true
        }
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var inc = 0
    for person in members {
        let p1 = person.job
        if p1 != nil {
            switch p1!.type {
            case let .Hourly(value):
                inc += Int(value * 10.0) * 200
            case let .Salary(value):
                inc += value
            }
        }
    }
    return inc
  }
}





