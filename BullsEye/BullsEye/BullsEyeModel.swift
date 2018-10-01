//
//  BullsEyeModel.swift
//  BullsEye
//
//  Created by Aditya Bhat on 9/30/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Foundation

class BullsEyeModel {

    let slider = (min:0, max:100)

    private var roundCounter = 0
    private var targetValue = 0
    private var scoreValue = 0

    var round: Int {
        return roundCounter
    }
    var target: Int {
        return targetValue
    }
    var score: Int {
        return scoreValue
    }

    func calcPoints(currentValue: Int) -> (value: Int, message: String) {
        let difference = abs(targetValue - currentValue)
        let pointsMessage: String
        var bonusPoints = 0

        switch difference {
        case 0:
            bonusPoints = 100
            pointsMessage = "Perfect!"
        case 1:
            bonusPoints = 50
            fallthrough
        case 2...5:
            pointsMessage = "Almost Had It!"
        case 6...10:
            pointsMessage = "Pretty good!"
        default:
            pointsMessage = "Not Even Close..."
        }

        let pointsValue = slider.max - abs(targetValue - currentValue) + bonusPoints
        scoreValue += pointsValue
        return (pointsValue, pointsMessage)
    }

    func startNewRound() {
        setNewTarget()
        roundCounter += 1
    }

    func resetGame() {
        roundCounter = 0
        scoreValue = 0
        startNewRound()
    }

    private func setNewTarget() {
        targetValue = 1 + Int(arc4random_uniform(UInt32(slider.max)))
    }
}
