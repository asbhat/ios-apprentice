//
//  ViewController.swift
//  BullsEye
//
//  Created by Aditya Bhat on 9/29/18.
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

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!

    private let bullsEyeGame = BullsEyeModel()

    private var scoreFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    private let startingSliderValue = 50
    private var score = 0 {
        didSet {
            scoreLabel.text = scoreFormatter.string(from: score as NSNumber)
        }
    }
    private var targetValue = 0 {
        didSet {
            targetLabel.text = String(targetValue)
        }
    }
    private var currentValue: Int {
        set {
            slider.value = Float(newValue)
        }
        get {
            return lroundf(slider.value)
        }
    }
    private var round = 0 {
        didSet {
            roundLabel.text = String(round)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetGame()
    }

    @IBAction func showAlert() {
        let (points, alertTitle) = bullsEyeGame.calcPoints(currentValue: currentValue)
        score = bullsEyeGame.score

        let alertMessage = "You scored \(points) points!"
        let actionTitle = "OK"

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: {_ in self.startNewRound()})

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    private func syncToBullsEyeGame() {
        score = bullsEyeGame.score
        targetValue = bullsEyeGame.target
        round = bullsEyeGame.round
    }

    private func startNewRound() {
        bullsEyeGame.startNewRound()
        currentValue = startingSliderValue
        syncToBullsEyeGame()
    }

    @IBAction func resetGame() {
        bullsEyeGame.resetGame()
        currentValue = startingSliderValue
        syncToBullsEyeGame()
    }
}

