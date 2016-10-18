//
//  LetoToggiUITests.swift
//  LetoToggiUITests
//
//  Created by Ismael Gobernado Alonso on 14/6/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import XCTest

class LetoToggiUITests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
   /*
    * Test First Login from not installed state
    */
    func testLogin() {
        let app = XCUIApplication()
        
        addUIInterruptionMonitorWithDescription("Leto Toggl” Would Like to Send You Notifications") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }
       
        app.tap() // need to interact with the app for the handler to fire
        snapshot("LoginScreen") //make a snapshot
        
        //Set textfield Email
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        app.textFields["Email"].typeText("leto.test.user@gmail.com")
        
        //Set textfield Password
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        app.secureTextFields["Password"].typeText("weareleto")
        
        //Tap in Sign in
        app.buttons["SIGN IN"].tap()
        
    }
    
    
}
