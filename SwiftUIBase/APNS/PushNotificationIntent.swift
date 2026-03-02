//
//  PushNotificationIntent.swift
//  SwiftUIBase
//
//  Created by hb on 02/03/26.
//

import Foundation
import Combine

@Observable
final class PushNotificationIntent {
    var notiType: PushRoute? = nil
    
    enum PushRoute: Equatable {
        case home(id: String)
        case redeem(id: String)
        case wallet(id: String)
        case profile(id: String)
    }
}

