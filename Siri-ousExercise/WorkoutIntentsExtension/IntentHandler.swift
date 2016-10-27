//
//  IntentHandler.swift
//  WorkoutIntentsExtension
//
//  Created by Jared Franzone on 10/16/16.
//  Copyright © 2016 Jared Franzone. All rights reserved.
//

import Intents


class IntentHandler: INExtension, INStartWorkoutIntentHandling {
    
    func resolveWorkoutName(forStartWorkout intent: INStartWorkoutIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        
        var result: INSpeakableStringResolutionResult
        
        result = INSpeakableStringResolutionResult.success(with: INSpeakableString(identifier: "Workout", spokenPhrase: "My Running Workout", pronunciationHint: nil))
        
        completion(result)
        
    }
    
    func confirm(startWorkout intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        let response = INStartWorkoutIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }
    
    func handle(startWorkout intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartWorkoutIntent.self))
        let response = INStartWorkoutIntentResponse(code: .continueInApp, userActivity: userActivity)
        completion(response)
    }
    
}

