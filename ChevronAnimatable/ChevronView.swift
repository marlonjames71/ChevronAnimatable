//
//  ChevronView.swift
//  ChevronAnimatable
//
//  Created by Marlon Raskin on 11/12/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

@IBDesignable
public class ChevronView: UIView {

	@IBInspectable public var lineWidth: CGFloat = 5 {
		didSet {
			setNeedsDisplay()
		}
	}


	private var _pointHeight: CGFloat = 1
	/// Valid range is -1...1
	@IBInspectable public var pointHeight: CGFloat {
		get {
			_pointHeight
		}
		set {
			if newValue > 1 {
				_pointHeight = 1
			} else if newValue < -1 {
				_pointHeight = -1
			} else {
				_pointHeight = newValue
			}
			setNeedsDisplay()
		}
	}

	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		draw(frame)
	}

	override public func draw(_ rect: CGRect) {
		let halfLineWidth = lineWidth / 2
		let startPoint = CGPoint(x: halfLineWidth, y: rect.midY)
		let endPoint = CGPoint(x: rect.maxX - halfLineWidth, y: rect.midY)
		let maxY = rect.maxY - lineWidth
		let minY = halfLineWidth
		let normalizedHeight = maxY / 2
		let midY = (normalizedHeight * -pointHeight) + normalizedHeight + minY
		let midPoint = CGPoint(x: rect.midX, y: midY)

		if let context = UIGraphicsGetCurrentContext() {
			context.beginPath()
			context.move(to: startPoint)
			context.addLine(to: midPoint)
			context.addLine(to: endPoint)
			context.setLineWidth(lineWidth)
			context.setLineCap(.round)
			context.setStrokeColor(tintColor.cgColor)
			context.setLineJoin(.round)
			context.strokePath()
		}
    }
}
