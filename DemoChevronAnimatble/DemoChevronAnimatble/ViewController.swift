//
//  ViewController.swift
//  DemoChevronAnimatble
//
//  Created by Marlon Raskin on 11/12/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import ChevronAnimatable

class ViewController: UIViewController {

	@IBOutlet weak var chevron: ChevronView!

	override func viewDidLoad() {
		super.viewDidLoad()

		chevron.pointHeight = 1
	}

	@IBAction func animateButtonTapped(_ sender: UIButton) {
		UIView.animate(withDuration: 2) {
			self.chevron.pointHeight *= -1
		}
	}

	@IBAction func lineWidthSliderChanged(_ sender: UISlider) {
		chevron.lineWidth = CGFloat(sender.value)
	}

	@IBAction func pointinessChanged(_ sender: UISlider) {
		chevron.pointHeight = CGFloat(sender.value)
		chevron.curviness = CGFloat(1 - abs(sender.value) + 0.1)
	}

	@IBAction func curvinessChanged(_ sender: UISlider) {
		chevron.curviness = CGFloat(sender.value)
	}
}

