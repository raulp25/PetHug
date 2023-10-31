//
//  LoginViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class LoginViewModelSuccessTests: XCTestCase {
    private var authServiceMock: AuthServiceSuccessMock!
    private var vm: LoginViewModel!
    
    override func setUp() {
        authServiceMock = AuthServiceSuccessMock()
        vm = LoginViewModel(authService: authServiceMock)
    }
    
    override func tearDown() {
        vm = nil
    }
    
    func test_with_successfull_Login() async {
        await vm.login(email: "fakeEmail@gmail.com", password: "fakePassword")
    }
}
 
