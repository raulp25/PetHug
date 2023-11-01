//
//  ValidatorsSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug

class ValidatorsTests: XCTestCase {
    var emailValidator: Validatable!
    var phoneValidator: Validatable!
    var passwordValidator: Validatable!
    var newAccountPasswordValidator: Validatable!
    var nameValidator: Validatable!
    
    private var state: PassthroughSubject<String, Never>!
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        emailValidator = ValidatorFactory.validateForType(type: .email)
        phoneValidator = ValidatorFactory.validateForType(type: .phone)
        passwordValidator = ValidatorFactory.validateForType(type: .password)
        newAccountPasswordValidator = ValidatorFactory.validateForType(type: .newAccountPassword )
        nameValidator = ValidatorFactory.validateForType(type: .name)
        
        state = PassthroughSubject<String, Never>()
    }
    
    override func tearDown() {
        state = nil
        stateSpy = nil
    }
    
    //MARK: - Note:
    // This tests support at max two values published at once. Xcode can't handle it like combined async
    
    //MARK: - Email validator
    func test_with_email_validator() {
        
        stateSpy = StateValueSpy(emailValidator.validate(publisher: state.eraseToAnyPublisher()))
        
        state.send("test@ds")
        
        XCTAssertEqual(stateSpy.values, [.error(.custom("Not valid"))], "Validator publisher value should be equal to [.error(.custom(Not valid))]")
        
        state.send("test@gmail.com")
        
        XCTAssertEqual(stateSpy.values, [.error(.custom("Not valid")), .valid], "Validator publisher value should be equal to [.error(.custom(Not valid)), .valid]")
    }
    
    //MARK: - Phone validator
    func test_with_phone_validator() {
        
        stateSpy = StateValueSpy(phoneValidator.validate(publisher: state.eraseToAnyPublisher()))
        
        state.send("1F983")
        
        XCTAssertEqual(stateSpy.values, [.error(.custom("Not valid"))], "Validator publisher value should be equal to [.error(.custom(Not valid))]")
        
        state.send("+0167638484938")
        
        XCTAssertEqual(stateSpy.values, [.error(.custom("Not valid")), .valid], "Validator publisher value should be equal to [.error(.custom(Not valid)), .valid]")
    }
    
    //MARK: - Password validator - just checks is not empty string, the rest is handled by backend
    func test_with_password_validator() {
        
        stateSpy = StateValueSpy(passwordValidator.validate(publisher: state.eraseToAnyPublisher()))
        
        state.send("")
        
        XCTAssertEqual(stateSpy.values, [.error(.custom("Not valid"))], "Validator publisher value should be equal to [.error(.custom(Not valid))]")
        
        state.send("NonEmptyPassword-#&")
        
        XCTAssertEqual(stateSpy.values, [.error(.custom("Not valid")), .valid], "Validator publisher value should be equal to [.error(.custom(Not valid)), .valid]")
    }
    
    //MARK: - NewAccountPassword validator
    func test_with_new_account_password_validator() {
        
        stateSpy = StateValueSpy(newAccountPasswordValidator.validate(publisher: state.eraseToAnyPublisher()))
        
        state.send("fakePass *with spaces3//")
        
        XCTAssertEqual(stateSpy.values, [.error(.custom("Not valid"))], "Validator publisher value should be equal to [.error(.custom(Not valid))]")
        
        state.send("coolPassword74")
        
        XCTAssertEqual(stateSpy.values, [.error(.custom("Not valid")), .valid], "Validator publisher value should be equal to [.error(.custom(Not valid)), .valid]")
    }
    
    //MARK: - Name validator - This test case just supports one value published at once
    func test_with_name_validator() {
        
        stateSpy = StateValueSpy(nameValidator.validate(publisher: state.eraseToAnyPublisher()))
        
        state.send("PaganiH3")
        
        XCTAssertEqual(stateSpy.values, [.valid], "Validator publisher value should be equal to [.valid]")
    }
    
}

private class StateValueSpy {
    private(set) var values = [ValidationState]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<ValidationState, Never>) {
        cancellable = publisher
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .valid:
                    self?.values.append(.valid)
                default:
                    self?.values.append(.error(.custom("Not valid")))
                }
        })
    }
}
