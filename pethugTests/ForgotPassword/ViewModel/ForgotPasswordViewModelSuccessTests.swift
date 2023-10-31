//
//  ForgotPasswordViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class ForgotPasswordViewModelSuccessTests: XCTestCase {
    private var authServiceMock: AuthServiceSuccessMock!
    private var vm: ForgotPasswordViewModel!
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        authServiceMock = AuthServiceSuccessMock()
        vm = ForgotPasswordViewModel(authService: authServiceMock)
        stateSpy = StateValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        stateSpy = nil
    }
    
    
    func test_with_successfull_Forgot_Passsword_flow() async {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.success], "The published value should be equal to [.success]")
        }
        
        await vm.resetPasswordWith(email: "Disclosure@gmail.com")
    }
}

//MARK: - Combine publisher Spy

private class StateValueSpy {
    private(set) var values = [ForgotPasswordViewModel.State]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<ForgotPasswordViewModel.State, Never>) {
        cancellable = publisher
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .success:
                    self?.values.append(.success)
                default:
                    print("not an error log")
                }
            })
    }
}
 


