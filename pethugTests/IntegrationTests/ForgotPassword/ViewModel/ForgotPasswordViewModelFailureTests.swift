//
//  ForgotPasswordViewModelFailureTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class ForgotPasswordViewModelFailureTests: XCTestCase {
    private var authServiceMock: AuthServiceFailureMock!
    private var vm: ForgotPasswordViewModel!
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        authServiceMock = AuthServiceFailureMock()
        vm = ForgotPasswordViewModel(authService: authServiceMock)
        stateSpy = StateValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        stateSpy = nil
    }
    
    
    func test_with_failure_Forgot_Password_flow() async {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published value should be equal to [.error(.someThingWentWrong]")
        }
        
        await vm.resetPasswordWith(email: "SubFocus@gmail.com")
    }
    
    func test_with_networkFailure_Login() async {
        NetworkMonitor.shared.disconnect()
        
        defer {
            XCTAssertEqual(stateSpy.values, [.networkError], "The published value should be equal to [.networkError]")
        }
        
        await vm.resetPasswordWith(email: "SubFocus@gmail.com")
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
                case .error(_):
                    self?.values.append(.error(.someThingWentWrong))
                case .networkError:
                    self?.values.append(.networkError)
                default:
                    print("not an error log")
                }
            })
    }
}

