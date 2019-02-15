let server = EchoServer(host: "localhost", port: 3010)
do {
    try server.start()
} catch let error {
    print("There was an error: \(error.localizedDescription)")
    server.stop()
}

