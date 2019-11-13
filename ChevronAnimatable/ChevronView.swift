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

	private var _curviness: CGFloat = 0.25
	/// Valid range is 0...1
	@IBInspectable public var curviness: CGFloat {
		get {
			_curviness
		}
		set {
			if newValue > 1 {
				_curviness = 1
			} else if newValue < 0 {
				_curviness = 0
			} else {
				_curviness = newValue
			}
			setNeedsDisplay()
		}
	}

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
		guard let context = UIGraphicsGetCurrentContext() else { return }

		// Constants
		let halfLineWidth = lineWidth / 2
		let maxY = rect.maxY - lineWidth
		let minY = halfLineWidth
 		let normalizedHeight = maxY / 2

		// End Points
		let startPoint = CGPoint(x: halfLineWidth, y: rect.midY)
		let endPoint = CGPoint(x: rect.maxX - halfLineWidth, y: rect.midY)

		// Midpoint
		let midY = (normalizedHeight * -pointHeight) + normalizedHeight + minY
		let midPoint = CGPoint(x: rect.midX, y: midY)

		// Curve Start
		let curveStartX = midPoint.x - ((midPoint.x - halfLineWidth) * curviness)
		let curveStartYOffset = midPoint.y - (bounds.midY)
		let curveStartY = (curveStartYOffset * (1 - curviness)) + bounds.midY
		let curveStart = CGPoint(x: curveStartX, y: curveStartY)

		// Curve End
		let curveEndX = ((midPoint.x - curveStart.x) * 2) + curveStartX
		let curveEnd = CGPoint(x: curveEndX, y: curveStartY)

		context.beginPath()
		context.move(to: startPoint)
		context.addLine(to: curveStart)
		context.addQuadCurve(to: curveEnd, control: midPoint)
		context.addLine(to: endPoint)
		context.setLineWidth(lineWidth)
		context.setLineCap(.round)
		context.setStrokeColor(tintColor.cgColor)
		context.setLineJoin(.round)
		context.strokePath()
	}
}
