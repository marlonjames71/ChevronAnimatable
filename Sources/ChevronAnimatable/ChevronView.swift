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

	public override class var layerClass: AnyClass {
		ProgressLayer.self
	}

	private var progressLayer: ProgressLayer {
		layer as! ProgressLayer
	}

	/// Valid range is 0...1
	@IBInspectable public dynamic var curviness: CGFloat {
		get {
			progressLayer.curviness
		}
		set {
			if newValue > 1 {
				progressLayer.curviness = 1
			} else if newValue < 0 {
				progressLayer.curviness = 0
			} else {
				progressLayer.curviness = newValue
			}
		}
	}

	@IBInspectable public dynamic var lineWidth: CGFloat {
		get { progressLayer.lineWidth }
		set { progressLayer.lineWidth = newValue }
	}


	/// Valid range is -1...1
	@IBInspectable public dynamic var pointHeight: CGFloat {
		get {
			progressLayer.pointHeight
		}
		set {
			if newValue > 1 {
				progressLayer.pointHeight = 1
			} else if newValue < -1 {
				progressLayer.pointHeight = -1
			} else {
				progressLayer.pointHeight = newValue
			}
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

	class ProgressLayer: CALayer {
		@NSManaged var curviness: CGFloat
		@NSManaged var lineWidth: CGFloat
		@NSManaged var pointHeight: CGFloat

		override init(layer: Any) {
			super.init(layer: layer)

			if let layer = layer as? ProgressLayer {
				curviness = layer.curviness
				lineWidth = layer.lineWidth
				pointHeight = layer.pointHeight
			}
		}

		override init() {
			super.init()
			commonInit()
		}

		required init?(coder: NSCoder) {
			super.init(coder: coder)
			commonInit()
		}

		private func commonInit() {
			curviness = 0.25
			lineWidth = 5
			pointHeight = 1
		}


		override class func needsDisplay(forKey key: String) -> Bool {
			if isAnimationKeySupported(key) {
				return true
			}
			return super.needsDisplay(forKey: key)
		}

		override func action(forKey event: String) -> CAAction? {
			if ProgressLayer.isAnimationKeySupported(event) {
				guard let animation = currentAnimationContext(in: self)?.copy() as? CABasicAnimation else {
					setNeedsDisplay()
					return nil
				}

				animation.keyPath = event
				if let presentation = presentation() {
					animation.fromValue = presentation.value(forKey: event)
				}
				animation.toValue = nil
				return animation
			}

			return super.action(forKey: event)
		}

		private static let _animatableKeys = Set([
			#keyPath(curviness),
			#keyPath(lineWidth),
			#keyPath(pointHeight),
		])
		private class func isAnimationKeySupported(_ key: String) -> Bool {
			_animatableKeys.contains(key)
		}


		private func currentAnimationContext(in layer: CALayer) -> CABasicAnimation? {
			/// The UIView animation implementation is private, so to check if the view is animating and
			/// get its property keys we can use the key "backgroundColor" since its been a property of
			/// UIView which has been forever and returns a CABasicAnimation.
			action(forKey: #keyPath(backgroundColor)) as? CABasicAnimation
		}
	}
}
