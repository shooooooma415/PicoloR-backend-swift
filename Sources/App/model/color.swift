import Vapor

typealias ColorCode = String
typealias ColorID = Int

struct Color: Content {
    let colorID: ColorID
    let colorCode: ColorCode
}

struct CreateColor: Content{
    let colorCode: [ColorCode]
    let roomID: RoomID
}

struct GetColorResponse: Content{
    let themeColor: [Color]
}