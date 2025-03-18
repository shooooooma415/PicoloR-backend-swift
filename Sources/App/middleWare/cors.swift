import Vapor

struct CORSMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        if request.method == .OPTIONS {
            let response = Response(status: .ok)
            addCORSHeaders(to: response)
            return request.eventLoop.makeSucceededFuture(response)
        }
        
        return next.respond(to: request).map { response in
            addCORSHeaders(to: response)
            return response
        }
    }
    
    public func addCORSHeaders(to response: Response) {
        response.headers.replaceOrAdd(name: "Access-Control-Allow-Origin", value: "*")
        response.headers.replaceOrAdd(name: "Access-Control-Allow-Methods", value: "GET, POST, DELETE, PUT, OPTIONS")
        response.headers.replaceOrAdd(name: "Access-Control-Allow-Headers", value: "Content-Type, Authorization")
    }
}

extension CORSMiddleware {
    static let `default` = CORSMiddleware()
}