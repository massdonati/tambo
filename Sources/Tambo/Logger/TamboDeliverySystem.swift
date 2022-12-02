//
//  File.swift
//  
//
//  Created by Massimo Donati on 12/2/22.
//

import Foundation

public enum TamboDeliverySystem {
    case syncToMain
    case async(DispatchQueue)
    case syncToCurrentThread

    var queue: DispatchQueue? {
        switch self {
        case .syncToMain:
            return .main
        case .async(let queue):
            return queue
        case .syncToCurrentThread:
            return nil
        }
    }
}
