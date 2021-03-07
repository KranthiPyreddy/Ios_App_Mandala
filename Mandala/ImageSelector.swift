//  ImageSelector.swift
//  Mandala
//  Created by Kranthi Pyreddy on 2/28/21.
import UIKit

class ImageSelector: UIControl {
    //Adding a stack view property
    private let selectorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints =
            false
        return stackView
    }()
    //method that will configure the view hierarchy for the control
    private func configureViewHierarchy() {
        addSubview(selectorStackView)
        //Adding the highlight view to the view hierarchy
        insertSubview(highlightView, belowSubview: selectorStackView)
        /*The control should be able to be created either programmatically or
         within an interface file (such as a storyboard), and the view hierarchy needs
         to be configured in both cases */
        NSLayoutConstraint.activate([
            selectorStackView.leadingAnchor.constraint(equalTo:leadingAnchor),
            selectorStackView.trailingAnchor.constraint(equalTo:trailingAnchor),
            selectorStackView.topAnchor.constraint(equalTo:topAnchor),
            selectorStackView.bottomAnchor.constraint(equalTo:bottomAnchor),
            //Adding the highlight view to the view hierarchy
            highlightView.heightAnchor.constraint(equalTo:
                                                    highlightView.widthAnchor),
            highlightView.heightAnchor.constraint(equalTo:
                                                    heightAnchor, multiplier: 0.9),
            highlightView.centerYAnchor
                .constraint(equalTo:
                                selectorStackView.centerYAnchor),
        ])
    }
    //Overriding the control initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViewHierarchy()
    }
    //Adding properties to manage the images
    //Updating the horizontal constraint
    var selectedIndex = 0 {
        didSet {
        if selectedIndex < 0 {
        selectedIndex = 0
        }
        if selectedIndex >= imageButtons.count {
        selectedIndex = imageButtons.count - 1
        }
        //Updating the highlight color
        highlightView.backgroundColor = highlightColor(forIndex: selectedIndex)
            
        let imageButton = imageButtons[selectedIndex]
        highlightViewXConstraint =
        highlightView.centerXAnchor.constraint(equalTo:
        imageButton.centerXAnchor)
        }
        }
    private var imageButtons: [UIButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            imageButtons.forEach {
                selectorStackView.addArrangedSubview($0)}
        }
    }
    var images: [UIImage] = [] {
        didSet {
            imageButtons = images.map { image in
                let imageButton = UIButton()
                imageButton.setImage(image, for: .normal)
                imageButton.imageView?.contentMode = .scaleAspectFit
                imageButton.adjustsImageWhenHighlighted = false
                imageButton.addTarget(self,
                                      action:
                                        #selector(imageButtonTapped(_:)),
                                      for: .touchUpInside)
                return imageButton
            }
            selectedIndex = 0
        }
    }
    //method that will be called when a button is tapped
    @objc private func imageButtonTapped(_ sender: UIButton) {
        guard let buttonIndex = imageButtons.firstIndex(of: sender)
        else {
            preconditionFailure("The buttons and images are not parallel.")
        }
        //selectedIndex = buttonIndex
        //Animating the highlight view’s frame
        let selectionAnimator = UIViewPropertyAnimator(
        duration: 0.3,
        //curve: .easeOut,
        //Using a spring animation
        dampingRatio: 0.7,
        animations: {
        self.selectedIndex = buttonIndex
        self.layoutIfNeeded()
        })
        selectionAnimator.startAnimation()
        
        //sendActions(for:) method on the control, passing in the type of event that has occurred
        //Sending control event actions
        sendActions(for: .valueChanged)
    }
    //Adding the highlight view
    private let highlightView: UIView = {
        let view = UIView()
        //Removing the existing background color
        //view.backgroundColor = view.tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //Adding the horizontal constraint
    private var highlightViewXConstraint: NSLayoutConstraint! {
    didSet {
    oldValue?.isActive = false
    highlightViewXConstraint.isActive = true
    }
    }
    //To make it a circle, set its corner radius to be half of its width.
    //Setting the corner radius
    override func layoutSubviews() {
    super.layoutSubviews()
    highlightView.layer.cornerRadius = highlightView.bounds.width / 2.0
    }
    //Adding highlight colors
    var highlightColors: [UIColor] = [] {
        //Updating the current background color
        didSet {
        highlightView.backgroundColor = highlightColor(forIndex:
        selectedIndex)
        }
        }
    //Implementing a method to return a highlight color
    private func highlightColor(forIndex index: Int) -> UIColor {
    guard index >= 0 && index < highlightColors.count else {
    return UIColor.blue.withAlphaComponent(0.6)
    }
    return highlightColors[index]
    }
}
