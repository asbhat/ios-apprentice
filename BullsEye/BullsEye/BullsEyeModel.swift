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

    private(set) var round = 0
    private(set) var target = 0
    private(set) var score = 0

    /**
     Calculates points and updates the game's total score for a guess.

     - Parameter guess: The user's attempt to get close to the `target`.

     - Returns:
        - `points`: number of points awarded for the `guess`.
        - `message`: qualitative message for the `guess`.
     */
    func calcPoints(from guess: Int) -> (points: Int, message: String) {
        let difference = abs(target - guess)
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

        let points = slider.max - abs(target - guess) + bonusPoints
        score += points
        return (points, pointsMessage)
    }

    func startNewRound() {
        setNewTarget()
        round += 1
    }

    func resetGame() {
        round = 0
        score = 0
        startNewRound()
    }

    private func setNewTarget() {
        target = 1 + Int(arc4random_uniform(UInt32(slider.max)))
    }
}
