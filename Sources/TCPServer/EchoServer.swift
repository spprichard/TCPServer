import Foundation
import NIO

enum EchoServerError: Error {
    case invalidHost
    case invalidPort
}

class EchoServer {
    private let group = MultiThreadedEventLoopGroup(numThreads: System.coreCount)
    private var host: String?
    var port: Int?
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
    
    private var serverBootstrap: ServerBootstrap{
        return ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.add(handler: BackPressureHandler()).then { v in
                    channel.pipeline.add(handler: EchoHandler())
                }
            }
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
        
    }
    
    func start() throws {
        guard let host = host else {
            throw EchoServerError.invalidHost
        }
        
        guard let port = port else {
            throw EchoServerError.invalidPort
        }
        
        do {
            let channel = try serverBootstrap.bind(host: host, port: port).wait()
            print("Listening on \(String(describing: channel.localAddress))")
            try channel.closeFuture.wait()
        } catch let error {
            throw error
        }
    }
    
    func stop() {
        do {
            try group.syncShutdownGracefully()
        } catch let error {
            print("Error shutting down: \(error.localizedDescription)")
            // I feel like this exit code should be non-zero if there was an error shutting down...
            exit(0)
        }
    }
}
