//
//  HUDView.swift
//  MyLocations
//
//  Created by Aditya Bhat on 12/21/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

class HUDView: UIView {

    // MARK: - Instance variables

    let boxWidth: CGFloat = 96
    let boxHeight: CGFloat = 96
    let boxCornerRadius: CGFloat = 10

    var boxRect: CGRect {
        return CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth,
            height: boxHeight)
    }

    var text = ""

    // MARK: - Initialization

    convenience init(in view: UIView, animated: Bool) {
        self.init(frame: view.bounds)
        self.isOpaque = false

        view.addSubview(self)
        view.isUserInteractionEnabled = false
        self.show(animated)

//        self.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.5)
    }

    // MARK: - Public methods

    func show(_ animated: Bool) {
        guard animated else {
            return
        }
        // TODO: animate the checkmark

        alpha = 0  // invisible
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
            self.alpha = 1  // fully opaque
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    func hide() {
        superview?.isUserInteractionEnabled = true
        removeFromSuperview()
    }

    // MARK: - draw

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: boxCornerRadius)
        #colorLiteral(red: 0.3730429411, green: 0.3730429411, blue: 0.3730429411, alpha: 0.8009417808).setFill()
        roundedRect.fill()

        // Draw checkmark
        if let checkmark = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(
                x: center.x - round(checkmark.size.width / 2),
                y: center.y - round(checkmark.size.height / 2) - boxHeight / 8)
            checkmark.draw(at: imagePoint)
        }

        let attribs : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ]

        let textSize = text.size(withAttributes: attribs)

        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)

        text.draw(at: textPoint, withAttributes: attribs)
    }

}
