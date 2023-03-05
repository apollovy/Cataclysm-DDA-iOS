//
// Created by Аполлов Юрий Андреевич on 12.01.2021.
// Copyright (c) 2021 Аполлов Юрий Андреевич. All rights reserved.
//

import Foundation

import XCTest

class BackspaceInMenuTest : XCTestCase
{
    func testInput()
    {
        let app = XCUIApplication()
        app.launch()
        app.swipeUp()
        app.keyboards.keys["t"].tap()  // settings
        app.keyboards.keys["o"].tap()  // options
        app.keyboards.buttons["Return"].tap()  // change default character name
        for _ in 0..<2 {
            app.keyboards.keys["x"].tap()
        }
        app.keyboards.keys["delete"].tap()
    }
}
