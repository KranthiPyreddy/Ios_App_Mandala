//  ViewController.swift
//  Mandala
//  Created by Kranthi Pyreddy on 2/21/21.
import UIKit

class MoodSelectionViewController: UIViewController {
    //Adding mood properties
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var addMoodButton: UIButton!
    //Updating the mood buttons
    var moods: [Mood] = [] {
        didSet {
            //Connecting the current mood to the selection
            currentMood = moods.first
            moodButtons = moods.map { mood in
                let moodButton = UIButton()
                moodButton.setImage(mood.image, for: .normal)
                moodButton.imageView?.contentMode = .scaleAspectFit
                moodButton.adjustsImageWhenHighlighted = false
                //Connecting the current mood to the selection
                moodButton.addTarget(self,
                                     action: #selector(moodSelectionChanged(_:)), for: .touchUpInside)
                return moodButton
            }
        }
    }
    //Updating the stack view’s buttons
    var moodButtons: [UIButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            moodButtons.forEach { stackView.addArrangedSubview($0)}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Declaring the moods to display
        moods = [.happy, .sad, .angry, .goofy, .crying, .confused, .sleepy, .meh]
        addMoodButton.layer.cornerRadius = addMoodButton.bounds.height / 2
    }
    //Updating the currently selected mood
    var currentMood: Mood? {
        didSet {
            guard let currentMood = currentMood else {
                addMoodButton?.setTitle(nil, for: .normal)
                addMoodButton?.backgroundColor = nil
                return
            }
            addMoodButton?.setTitle("I'm \(currentMood.name)", for:
                                        .normal)
            addMoodButton?.backgroundColor = currentMood.color
        }
    }
    @objc func moodSelectionChanged(_ sender: UIButton) {
        guard let selectedIndex = moodButtons.firstIndex(of: sender)
        else {
            preconditionFailure("Unable to find the tapped button in the buttons array.")
        }
        currentMood = moods[selectedIndex]
    }
    
    //Declare a new property of type MoodsConfigurable and implement
    //Handling the embed segue
    var moodsConfigurable: MoodsConfigurable!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier {
        case "embedContainerViewController":
            guard let moodsConfigurable = segue.destination as?
                    MoodsConfigurable else {
                preconditionFailure("View controller expected to conform to MoodsConfigurable")
            }
            self.moodsConfigurable = moodsConfigurable
            segue.destination.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 160, right:0)
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    //Adding new mood entries
    @IBAction func addMoodTapped(_ sender: Any) {
        guard let currentMood = currentMood else {
            return
        }
        let newMoodEntry = MoodEntry(mood: currentMood, timestamp:
                                        Date())
        moodsConfigurable.add(newMoodEntry)
    }
}

