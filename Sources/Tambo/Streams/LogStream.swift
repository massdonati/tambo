//
//  LogStream.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation
import Combine

protocol LogStream: Subscriber where Input == Log, Failure == Never {}

extension LogStream {
    func receive(completion: Subscribers.Completion<Failure>) {}
}
