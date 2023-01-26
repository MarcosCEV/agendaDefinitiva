class Usuario : Codable {
    public let pass: String
    public let user: String
    
    init(json: [String: Any])  {
        pass = json["date"] as? String ?? ""
        user = json["name"] as? String ?? ""
    }
}
