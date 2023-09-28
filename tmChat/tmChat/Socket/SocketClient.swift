//
//  SocketClient.swift
//  tmchat
//
//  Created by Shirin on 3/26/23.
//

import Foundation
import Starscream

extension Notification.Name {
    static let socketClientDidReceiveEvent = Notification.Name("SocketClient.didReceiveEvent")
}

class SocketClient: NSObject, WebSocketDelegate {
    
    static let shared = SocketClient()
    
    var socket: WebSocket!

    var isConnected = false {
        didSet {
            socketStatusChanged?(isConnected)
        }
    }

    var reconnectTimer: Timer?
    var reconnectTime: Double = 5

    var pingTimer = Timer()
    var pingTime: Double = 60

    var socketStatusChanged: ((Bool)->())?
    func clear(){
        socket.disconnect()
        socket = nil
        reconnectTimer?.invalidate()
        pingTimer.invalidate()
    }

    func connect(){
        var request = URLRequest(url: URL(string: ApiPath.SOCKET_URL)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()

        print(request.url as Any)
        startReconnetTimer()
    }

    func connected(){
        isConnected = true
        reconnectTimer?.invalidate()
        pingTimer.invalidate()
        reconnectTimer = nil

        pingTimer = Timer.scheduledTimer(timeInterval: self.pingTime,
                                         target: self,
                                         selector: #selector(ping),
                                         userInfo: nil,
                                         repeats: false)
    }
    
    func startReconnetTimer(){
        if reconnectTimer != nil { return }
        print("reconnectTimer fired")
        reconnectTimer = Timer.scheduledTimer(timeInterval: reconnectTime,
                                              target: self,
                                              selector: #selector(reconnect),
                                              userInfo: nil,
                                              repeats: true)
    }

    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
            connected()

        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            isConnected = false
            startReconnetTimer()

        case .text(let string):
            print("Received text: \(string)")
            SocketOn.shared.setupOn(string)

        case .binary(let data):
            guard let string = String(data: data, encoding: .utf8) else { return }

            print("Received data: \(string)")
            SocketOn.shared.setupOn(string)

        case .ping( _ ):
            print("Ping get ", Date())
            isConnected = true
            setupPing()

        case .cancelled:
            print("Cancelled")
            isConnected = false
            startReconnetTimer()

        case .error(let error):
            debugPrint(error as Any)
            isConnected = false
            startReconnetTimer()
            
        default:
            break
        }
    }

    func setupPing(){
        pingTimer.invalidate()
        pingTimer = Timer.scheduledTimer(timeInterval: self.pingTime,
                                         target: self,
                                         selector: #selector(ping),
                                         userInfo: nil,
                                         repeats: false)
    }

    @objc func ping(){
        print("Ping gelmedi, that's why reconnect etyan ... ?")
        isConnected = false
        startReconnetTimer()
    }

    @objc func reconnect(){
        print("reconnect")
        socket.connect()
    }
}


extension SocketClient {

    func sendMsg(emitMsg: EmitMsg) {
        sendMsg(data: emitMsg, emit: .new)

        if isConnected == false {
            MessageTable.shared.updateMsgToError(msgId: emitMsg.localId)
        }
    }

    func sendMsg<T: Codable>(data: T, emit: SocketEmits) {
        guard socket != nil, isConnected else { return }

        let emitData = SocketEvent(event: emit.rawValue, data: data)

        guard let jsonData = try? JSONEncoder().encode(emitData) else { return }

        let jsonString = String(data: jsonData, encoding: .utf8)

        socket.write(string: jsonString ?? "", completion: {
            print("completed ", jsonString as Any)
        })
    }
    
    func sendRead(data: ReadMsg){
        if socket == nil { return }

        let emitData = SocketEvent(event: SocketEmits.read.rawValue, data: data)
        
        guard let jsonData = try? JSONEncoder().encode(emitData) else { return }

        let jsonString = String(data: jsonData, encoding: .utf8)

        socket.write(string: jsonString ?? "", completion: {
            print("completed ", jsonString as Any)
            MessageTable.shared.readRoomMsg(date: data.date ?? "", roomId: data.roomId)
        })
    }
    
    func sendMsgDelete(uuids: [String]){
        if socket == nil { return }
        let data = ["messageIds": uuids]
        let emitData = SocketEvent(event: SocketEmits.deleteMsg.rawValue, data: data)
        
        guard let jsonData = try? JSONEncoder().encode(emitData) else { return }

        let jsonString = String(data: jsonData, encoding: .utf8)

        socket.write(string: jsonString ?? "", completion: {
            print("completed ", jsonString as Any)
            
        })
    }
}
