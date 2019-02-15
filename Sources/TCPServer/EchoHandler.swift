import Foundation
import NIO

class EchoHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer
    
    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        var buffer = unwrapInboundIn(data)
        let readableBytes = buffer.readableBytes
        
        if let recieved = buffer.readString(length: readableBytes) {
            print("Received: \(recieved)")
        }
        
        ctx.write(data, promise: nil)
    }
    
    func channelReadComplete(ctx: ChannelHandlerContext) {
        ctx.flush()
    }
    
    func errorCaught(ctx: ChannelHandlerContext, error: Error) {
        print("Error: \(error.localizedDescription)")
        ctx.close(promise: nil)
    }
}
