//
//  WorkoutTableViewController.swift
//  Siri-ousExercise
//
//  Created by Jared Franzone on 10/16/16.
//  Copyright © 2016 Jared Franzone. All rights reserved.
//

import UIKit
import HealthKit
import Intents


class WorkoutTableViewController: UITableViewController {
    
    private let healthStore = HKHealthStore()
    
    private var workouts = [HKWorkout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HKHealthStore.isHealthDataAvailable() {
            
            let writeTypes: Set<HKSampleType> = Set([ HKObjectType.workoutType() ])
            let readTypes: Set<HKObjectType> = Set([ HKObjectType.workoutType() ])
            
            healthStore.requestAuthorization(toShare: writeTypes, read: readTypes, completion: { (success, error) in
                // Handle authorization if necessary
            })
            
        }
        
        INPreferences.requestSiriAuthorization { (status) in
            // Handle authorization if necessary
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if SiriStarted {
            self.performSegue(withIdentifier: "StartWorkoutSegue", sender: nil)
            SiriStarted = false
        }
        
        fetchWorkouts()
    }
    
    func fetchWorkouts() {
        
        let sampleType = HKObjectType.workoutType()
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let limit = 50
        
        let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: nil,
            limit: limit,
            sortDescriptors: [sortDescriptor]) { (query, results, error) in
                
                
                self.workouts.removeAll()
                
                if let samples = results as? [HKWorkout] {
                    
                    self.workouts = samples
                    
                } else {
                    
                    self.workouts = [HKWorkout]()
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
        }
        
        healthStore.execute(query)
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let workoutToShow = workouts[indexPath.row]
        
        cell.detailTextLabel?.text = formatWorkoutDuration(duration: workoutToShow.duration)
        cell.textLabel?.text = workoutToShow.startDate.short
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func formatWorkoutDuration(duration: TimeInterval) -> String {
        
        let ti = Int(duration)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if (hours != 0) {
            return (hours == 1) ? String("\(hours) hour") : String("\(hours) hours")
        }
        else if(minutes != 0) {
            return (minutes == 1) ? String("\(minutes) minute") : String("\(minutes) minutes")
        }
        else {
            return (seconds == 1) ? String("\(seconds) second") : String("\(seconds) seconds")
        }
    }
    
}

extension Date {
    var short: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let dateString = formatter.string(from: self)
        
        return dateString
    }
}


