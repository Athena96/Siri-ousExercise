//
//  WorkoutViewController.swift
//  Siri-ousExercise
//
//  Created by Jared Franzone on 10/16/16.
//  Copyright © 2016 Jared Franzone. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var startDate = Date()
    
    var userEndedWorkout = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.userEndedWorkout {
                
                timer.invalidate()
                
            } else {
                
                let duration = -self.startDate.timeIntervalSinceNow
                let durationString = duration.hoursMinutesSeconds
                self.timerLabel.text = durationString
                
            }
        }
        
    }
    
    func add(workout: HKWorkout) {
        
        let healthStore = HKHealthStore()
        
        healthStore.save(workout) { (success, error) in
            // Handle Save Error
        }
    }
    
    @IBAction func endWorkoutButton(_ sender: UIButton) {
        
        userEndedWorkout = true
        
        let workout = HKWorkout(
            activityType: .running,
            start: startDate,
            end: Date())
        
        add(workout: workout)
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension TimeInterval {
    var hoursMinutesSeconds: String {
        let ti = Int(self)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%02d:%02d:%02d", hours, minutes, seconds) as String
    }
}

