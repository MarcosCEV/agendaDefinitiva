class Evento : Codable {
    public let date: Double
    public let name: String
    init(json: [String: Any])  {
        date = json["date"] as? Double ?? 0
        name = json["name"] as? String ?? ""
    }
    //var date: Int
    //var name: String
}
