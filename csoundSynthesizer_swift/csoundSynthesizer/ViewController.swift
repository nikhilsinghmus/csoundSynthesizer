/*
 
 ViewController.swift
 Nikhil Singh, Dr. Richard Boulanger
 
 This app is a simple example of using Csound iOS in Swift.
 
*/

import UIKit
import SafariServices

enum sigType: Int {
    case sin = 1
    case saw = 2
    case sqr = 3
    case tri = 4
}

class ViewController: UIViewController {
    
    // Declarations
    var sig: sigType = .sin
    var vol = 0.8
    var csound: CsoundObj!
    var csoundUI: CsoundUI!
    
    // IBOutlets
    @IBOutlet var sinButton: UIButton!
    @IBOutlet var sqrButton: UIButton!
    @IBOutlet var sawButton: UIButton!
    @IBOutlet var triButton: UIButton!
    @IBOutlet var levelSlider: UISlider!
    @IBOutlet var keyboardView: CsoundVirtualKeyboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize CsoundObj and CsoundUI objects
        csound = CsoundObj()
        csoundUI = CsoundUI(csoundObj: csound)

        csoundUI.add(levelSlider, forChannelName:"amp") // Bind to a UISlider
        csound.play(Bundle.main.path(forResource:"swiftSynth", ofType: "csd")) // Play .csd
        
        keyboardView.keyboardDelegate = self
        didSelectSigtype(sinButton)
        levelChange(levelSlider) // Initialize slider properties
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: IBActions
    @IBAction func levelChange(_ sender: UISlider) {
        // Mock level meter with minimum track color of slider
        let color = UIColor(hue: CGFloat(1/3 - (sender.value/3)), saturation: 1, brightness: 1, alpha: 1)
        sender.minimumTrackTintColor = color
    }
    
    // Show csound.github.io in an SFSafariViewController
    @IBAction func showSite(_ sender: UIButton) {
        let csoundURL = URL(string: "http://csound.github.io")
        let SafariVC = SFSafariViewController(url: csoundURL!)
        present(SafariVC, animated: true, completion: nil)
    }
    
    // sig is set according to which button is touched
    @IBAction func didSelectSigtype(_ sender: UIButton) {
        // Set all other buttons to false, sender to true
        for button in [sinButton, sawButton, sqrButton, triButton] {
            if button == sender {
                button?.isSelected = true
            } else {
                button?.isSelected = false
            }
        }
        
        // Set sig depending on identity of sender
        switch sender {
        case sinButton: sig = .sin
        case sawButton: sig = .saw
        case sqrButton: sig = .sqr
        case triButton: sig = .tri
        default: break
        }
    }
}

// MARK: Keyboard delegate methods
extension ViewController: CsoundVirtualKeyboardDelegate {
    func keyDown(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        // Key touched
        let score = String(format: "i1.%003d 0 -1 %d %d", keyNum+60, keyNum+60, sig.rawValue)
        csound.sendScore(score)
    }
    
    func keyUp(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        // Key released
        let score = String(format: "i-1.%003d 0 -1 %d %d", keyNum+60, keyNum+60, sig.rawValue)
        csound.sendScore(score)
    }
}

