//
//  TelegramStream.swift
//  Tambo
//
//  Created by Massimo Donati on 6/9/20.
//

import Foundation

public final class TelegramStream: StreamProtocol {
    let botToken: String
    let chatId: String
    private var api: URL {
        URL(string: "https://api.telegram.org/bot\(botToken)/sendMessage")!
    }
    public var logFormatter = LogStringFormatter()
    public var isAsync: Bool = true
    public var identifier: String
    public var outputLevel: LogLevel
    public var queue: DispatchQueue = .global()
    public var metadata: [String : Any]?
    public var filters: AtomicWrite<[FilterClosure]> = AtomicWrite<[FilterClosure]>(wrappedValue: [])

    public init(identifier: String,
                botToken: String,
                chatId: String,
                dispatchQueue: DispatchQueue? = nil) {
        self.identifier = identifier
        outputLevel = .trace
        self.botToken = botToken
        self.chatId = chatId
        queue = streamQueue(target: dispatchQueue)
    }
    
    public func process(_ log: Log) {
        let logstr = logFormatter.format(log)

        var req = URLRequest(url: api)
        req.httpMethod = "POST"
        let telegramMessage = TelegramMessage(
            chat_id: chatId,
            text: logstr
        )
        req.httpBody = try? JSONEncoder().encode(telegramMessage)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "no data")
            }
        }.resume()
    }
}

private struct TelegramMessage: Encodable {
    let chat_id: String
    let text: String
//    let parse_mode = "pre-formatted fixed-width code block"
}
