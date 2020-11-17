//
//  IntentHandler.swift
//  WidgetColorSelection
//
//  Created by Wootae Jeon on 2020/11/11.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Intents

class IntentHandler: INExtension, SelectColorIntentHandling {
    func resolveColor(for intent: SelectColorIntent, with completion: @escaping (ColorResolutionResult) -> Void) {
        
    }
    
    func provideColorOptionsCollection(for intent: SelectColorIntent, with completion: @escaping (INObjectCollection<Color>?, Error?) -> Void) {
        let hexValues = ["#EADE4Cff", "#F5A997ff", "#F0E7CFff", "#FF6B39ff", "#206491ff"]
        let names = ["노란색", "분홍색", "흰 색", "주황색", "파란색"]
        var colors: [Color] = []
        for i in 0..<5 {
            colors.append(Color(identifier: hexValues[i], display: names[i]))
        }
        let collection = INObjectCollection(items: colors)
        completion(collection, nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
    
}
