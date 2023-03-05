//
//  CDDAUITests.m
//  CDDAUITests
//
//  Created by Аполлов Юрий Андреевич on 11.01.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

import XCTest

import CoreGraphics


class CDDAUITests: XCTestCase {
    override func setUp() {
        XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeLeft
    }

    func testNewGameCreationSucceeds() {
        let app = XCUIApplication()
        app.launch()

        app.swipeUp()

        let gamePad = app.otherElements["GamePad"]
        let gamepadSize = gamePad.frame.size
        let gamepadButtonSize = CGSize(width: CGFloat(gamepadSize.width / CGFloat(CDDAUITests.GAMEPAD_BUTTON_COUNT)), height: CGFloat(gamepadSize.height / CGFloat(CDDAUITests.GAMEPAD_BUTTON_COUNT)))
        let gamepadCenterCoordinate = gamePad.coordinate(withNormalizedOffset:CGVector(dx: 0.5, dy: 0.5))
        let leftArrowCoordinate = gamepadCenterCoordinate.withOffset(CGVector(dx: -gamepadButtonSize.width, dy: 0))
        let returnButton = app.otherElements["Return button"]
        let returnButtonCenterCoordinate = returnButton.coordinate(withNormalizedOffset:CGVector(dx: 0.5, dy: 0.5))

        app.keyboards.keys["n"].tap()
        leftArrowCoordinate.tap()
        returnButtonCenterCoordinate.tap()
        app.keyboards.keys["x"].tap()
        app.keyboards.buttons["return"].tap()
    }

    func tapKey(_ key:String)
    {

    }

    static let GAMEPAD_BUTTON_COUNT = 3;
}
